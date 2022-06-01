use crate::error::CustomError;
use arrayref::{array_mut_ref, array_ref, array_refs, mut_array_refs};
use solana_program::{
	account_info::{next_account_info, AccountInfo},
	entrypoint::ProgramResult,
	msg, program,
	program_error::ProgramError,
	program_pack::{IsInitialized, Pack, Sealed},
	pubkey::Pubkey,
};
use std::str;
use spl_token::instruction;

pub const ROLE_BIDDER: u8 = 1;
pub const ROLE_ADVERTISER: u8 = 2;
pub const ROLE_PUBLISHER: u8 = 3;
pub const ROLE_VOTER: u8 = 4;

pub const INITIAL_THRESHOLD: u16 = 50;
pub const THRESHOLD_STEP: u16 = 10;
pub const BLOCK_DEPOSIT: u64 = 1000000; //0.01 ADT
pub const MAJORITY: u32 = 666; // 0.666 considered as supermajority

pub const VOTER_POOL_TOKEN: Pubkey = Pubkey::new_from_array([
	133, 246, 232, 67, 91, 176, 132, 205, 152, 115, 102, 37, 60, 22, 127, 217, 61, 92, 130, 84,
	221, 235, 159, 100, 20, 19, 160, 218, 100, 96, 54, 47,
]);
pub const VOTER_AUTHORITY: Pubkey = Pubkey::new_from_array([
	197, 251, 51, 47, 44, 188, 118, 4, 74, 239, 49, 197, 128, 57, 187, 162, 12, 202, 55, 54, 137,
	81, 31, 122, 214, 49, 143, 245, 128, 46, 147, 133,
]);

#[derive(Debug)]
pub struct Creative {
	hash: String,
	treshold: u16,
	blocked: bool,
	initialized: bool,
	owner: Pubkey,
}

impl IsInitialized for Creative {
	fn is_initialized(&self) -> bool {
		self.initialized
	}
}
impl Sealed for Creative {}
impl Pack for Creative {
	const LEN: usize = 255 + 2 + 1 + 1 + 32;

	fn unpack_from_slice(src: &[u8]) -> Result<Self, ProgramError> {
		let src = array_ref![src, 0, Creative::LEN];
		let (hash, treshold, blocked, initialized, owner) = array_refs![src, 255, 2, 1, 1, 32];
		Ok(Creative {
			hash: String::from(str::from_utf8(hash).unwrap()),
			treshold: u16::from_le_bytes(*treshold),
			blocked: blocked[0] != 0,
			initialized: initialized[0] != 0,
			owner: Pubkey::new(owner),
		})
	}

	fn pack_into_slice(&self, dst: &mut [u8]) {
		let dst = array_mut_ref![dst, 0, Creative::LEN];
		let (hash_dst, treshold_dst, blocked_dst, initialized_dst, owner_dst) =
			mut_array_refs![dst, 255, 2, 1, 1, 32];
		let &Creative {
			ref hash,
			treshold,
			blocked,
			initialized,
			ref owner,
		} = self;

		hash_dst.copy_from_slice(hash.as_ref());
		*treshold_dst = treshold.to_le_bytes();
		blocked_dst[0] = blocked as u8;
		initialized_dst[0] = initialized as u8;
		owner_dst.copy_from_slice(owner.as_ref());
	}
}

impl Creative {
	pub fn announce_creative(
		accounts: &[AccountInfo],
		data: &[u8],
		program_id: &Pubkey,
	) -> ProgramResult {
		let account_info_iter = &mut accounts.iter();
		let account_info = next_account_info(account_info_iter)?;
		let owner_info = next_account_info(account_info_iter)?;

		Self::validate_new_creative(account_info, owner_info, program_id)?;
		Self::initialize_creative(account_info, owner_info, data)
	}

	pub fn announce_creatives(
		accounts: &[AccountInfo],
		data: &[u8],
		program_id: &Pubkey,
	) -> ProgramResult {
		const ITERATION: usize = 255;
		let account_info_iter = &mut accounts.iter();
		let owner_info = next_account_info(account_info_iter)?;
		let mut i: usize = 0;

		while i < data.len() {
			let account_info = next_account_info(account_info_iter)?;
			Self::validate_new_creative(account_info, owner_info, program_id)?;
			Self::initialize_creative(
				account_info,
				owner_info,
				array_ref![data, i, ITERATION],
			)
			.unwrap();
			i += ITERATION;
		}
		Ok(())
	}

	pub fn start_block_creative(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
		let account_iter = &mut accounts.iter();
		let initiator_token_info = next_account_info(account_iter)?;
		let wallet_info = next_account_info(account_iter)?;
		let creative_info = next_account_info(account_iter)?;
		let mut creative = Self::unpack(&creative_info.try_borrow_data()?)?;
		let reason = String::from(str::from_utf8(data).unwrap());

		Self::transfer(
			accounts,
			initiator_token_info.key,
			&VOTER_POOL_TOKEN,
			wallet_info.key,
			BLOCK_DEPOSIT,
		)?;
		msg!(
			"vote initiator: {:?} creative: {}",
			initiator_token_info.key,
			&creative.hash[0..255]
		);
		msg!("reason: {}", reason);
		if creative.treshold == 0 {
			creative.treshold = INITIAL_THRESHOLD;
			Self::pack(creative, &mut creative_info.try_borrow_mut_data()?)?;
		}
		Ok(())
	}

	pub fn end_block_creative(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
		let account_iter = &mut accounts.iter();
		let initiator_token_info = next_account_info(account_iter)?;
		let wallet_info = next_account_info(account_iter)?;
		let creative_info = next_account_info(account_iter)?;
		let voter_pool_token_info = next_account_info(account_iter)?;
		let mut creative = Self::unpack(&creative_info.try_borrow_data()?)?;

		let data = array_ref![data, 0, 8];
		let (votes_for, votes_against) = array_refs![data, 4, 4];
		let votes_for = u32::from_le_bytes(*votes_for);
		let votes_against = u32::from_le_bytes(*votes_against);
		let transfer_to;

		if *wallet_info.key != VOTER_AUTHORITY || !wallet_info.is_signer {
			return Err(CustomError::OwnerMismatch.into());
		}

		if votes_for * 1000 / (votes_for + votes_against) > MAJORITY {
			// Voting successful - mark as blocked and return ADT
			creative.blocked = true;
			transfer_to = initiator_token_info.key;
			msg!("creative was blocked with {:?} votes for and {:?} votes against", votes_for, votes_against);
		} else {
			// Voting unsuccessful - increase difficulty and move ADT to pool
			creative.treshold += THRESHOLD_STEP;
			transfer_to = voter_pool_token_info.key;
			msg!("creative was not blocked with {:?} votes for and {:?} votes against", votes_for, votes_against);
		}

		Self::transfer(
			accounts,
			&VOTER_POOL_TOKEN,
			transfer_to,
			wallet_info.key,
			BLOCK_DEPOSIT,
		)?;
		Self::pack(creative, &mut creative_info.try_borrow_mut_data()?)?;
		let creative = Self::unpack(&creative_info.try_borrow_data()?)?;
		msg!("{:?} {:?}", creative.blocked, creative.treshold);

		Ok(())
	}

	fn validate_new_creative(
		account_info: &AccountInfo,
		owner_info: &AccountInfo,
		program_id: &Pubkey
	) -> ProgramResult {
		if !owner_info.is_signer {
			return Err(CustomError::MissingSignature.into());
		}
		if account_info.owner != program_id {
			return Err(CustomError::OwnerMismatch.into());
		}

		let creative_data = Self::unpack(&account_info.try_borrow_data()?);
		match creative_data {
			Ok(_) => {
				return Err(CustomError::AlreadyInitialized.into());
			}
			Err(e) => {
				if e != ProgramError::UninitializedAccount {
					return Err(e);
				}
			}
		}
		Ok(())
	}

	fn initialize_creative(
		account_info: &AccountInfo,
		owner_info: &AccountInfo,
		data: &[u8]
	) -> ProgramResult {
		let hash = array_ref![data, 0, 255];
		let creative = Self {
			hash: String::from(str::from_utf8(hash).unwrap()),
			treshold: 0,
			blocked: false,
			initialized: true,
			owner: *owner_info.key,
		};

		Self::pack(creative, &mut account_info.try_borrow_mut_data()?)
	}

	fn transfer(
        accounts: &[AccountInfo],
        source_key: &Pubkey,
        destination_key: &Pubkey,
        authority_key: &Pubkey,
        amount: u64,
    ) -> ProgramResult {
        let instruction = instruction::transfer(
            &spl_token::id(),
            source_key,
            destination_key,
            authority_key,
            &[],
            amount,
        )?;
        program::invoke(&instruction, accounts)
    }
}
