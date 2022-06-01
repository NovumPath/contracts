use crate::{error::CustomError};
use arrayref::{array_mut_ref, array_ref, array_refs, mut_array_refs};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg, program,
    program_error::ProgramError,
    program_pack::{IsInitialized, Pack, Sealed},
    pubkey::Pubkey,
    system_instruction,
};
use spl_token::instruction;

pub const CURRENCY_RATIO: u64 = 2;
pub const DECIMALS: u8 = 8;
pub const INITIAL_SUPPLY: u64 = 100000000 * 10u64.pow(8);

#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Token {
    owner: Pubkey,
    bidder: Pubkey,
    supply: u64,
    initialized: bool,
}

impl Sealed for Token {}
impl IsInitialized for Token {
    fn is_initialized(&self) -> bool {
        self.initialized
    }
}
impl Pack for Token {
    const LEN: usize = 32 + 32 + 8 + 1;
    fn unpack_from_slice(src: &[u8]) -> Result<Self, ProgramError> {
        let src = array_ref![src, 0, Token::LEN];
        let (owner, bidder, supply, initialized) = array_refs![src, 32, 32, 8, 1];
        let initialized = match initialized {
            [0] => false,
            [1] => true,
            _ => return Err(ProgramError::InvalidAccountData),
        };
        Ok(Token {
            owner: Pubkey::new(owner),
            bidder: Pubkey::new(bidder),
            supply: u64::from_le_bytes(*supply),
            initialized,
        })
    }
    fn pack_into_slice(&self, dst: &mut [u8]) {
        let dst = array_mut_ref![dst, 0, Token::LEN];
        let (owner_dst, bidder_dst, supply_dst, initialized_dst) = mut_array_refs![dst, 32, 32, 8, 1];
        let &Token {
            ref owner,
            ref bidder,
            supply,
            initialized,
        } = self;
        owner_dst.copy_from_slice(owner.as_ref());
        bidder_dst.copy_from_slice(bidder.as_ref());
        *supply_dst = supply.to_le_bytes();
        initialized_dst[0] = initialized as u8;
    }
}

impl Token {
    pub fn create_token(
        accounts: &[AccountInfo],
        data: &[u8],
        program_id: &Pubkey,
    ) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let account_info = next_account_info(account_info_iter)?;
        let mint_wallet_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;
        let bidder_wallet_info = next_account_info(account_info_iter)?;
        let token_info = next_account_info(account_info_iter)?;
        let mint_token_info = next_account_info(account_info_iter)?;

        Self::validate_new_token(account_info, wallet_info, program_id)?;

        let supply = u64::from_le_bytes(*array_ref![data, 0, 8]);
        Self::transfer(
            accounts,
            mint_token_info.key,
            token_info.key,
            mint_wallet_info.key,
            supply,
        )?;

        let token = Token {
            owner: *wallet_info.key,
            bidder: *bidder_wallet_info.key,
            supply: 0,
            initialized: true,
        };
        Self::pack(token, &mut account_info.try_borrow_mut_data()?)
    }

    pub fn make_payment(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let sender_info = next_account_info(account_info_iter)?;
        let recipient_info = next_account_info(account_info_iter)?;
        let wallet = next_account_info(account_info_iter)?;
        let amount = u64::from_le_bytes(*array_ref![data, 0, 8]);

        Self::transfer(
            accounts,
            sender_info.key,
            recipient_info.key,
            wallet.key,
            amount,
        )
    }

    pub fn make_deposit(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let deposit_token_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;
        let mint_token_info = next_account_info(account_info_iter)?;
        let bidder_token_info = next_account_info(account_info_iter)?;
        let mut deposit_token = Self::unpack(&deposit_token_info.try_borrow_data()?)?;
        let amount = u64::from_le_bytes(*array_ref![data, 0, 8]);

        if !deposit_token_info.is_signer {
            return Err(CustomError::MissingSignature.into());
        }

        Self::transfer(
            accounts,
            mint_token_info.key,
            bidder_token_info.key,
            wallet_info.key,
            amount,
        )?;

        deposit_token.supply += amount;
        Self::pack(
            deposit_token,
            &mut deposit_token_info.try_borrow_mut_data()?,
        )
    }

    pub fn withdraw_deposit(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let deposit_token_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;
        let bidder_token_info = next_account_info(account_info_iter)?;
        let member_token_info = next_account_info(account_info_iter)?;
        let mut deposit_token = Self::unpack(&deposit_token_info.try_borrow_data()?)?;
        let amount = u64::from_le_bytes(*array_ref![data, 0, 8]);

        Self::validate_deposit_transaction(wallet_info, deposit_token_info, deposit_token)?;

        Self::transfer(
            accounts,
            bidder_token_info.key,
            member_token_info.key,
            wallet_info.key,
            amount,
        )?;

        deposit_token.supply -= amount;
        Self::pack(
            deposit_token,
            &mut deposit_token_info.try_borrow_mut_data()?,
        )
    }

    pub fn fine_deposit(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let deposit_token_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;
        let mut deposit_token = Self::unpack(&deposit_token_info.try_borrow_data()?)?;
        let amount = u64::from_le_bytes(*array_ref![data, 0, 8]);

        Self::validate_deposit_transaction(wallet_info, deposit_token_info, deposit_token)?;
        if !wallet_info.is_signer {
            return Err(CustomError::MissingSignature.into());
        }

        deposit_token.supply -= amount;
        Self::pack(
            deposit_token,
            &mut deposit_token_info.try_borrow_mut_data()?,
        )
    }

    pub fn get_token(accounts: &[AccountInfo]) -> Result<Self, ProgramError> {
        let account_iter = &mut accounts.iter();
        let account = next_account_info(account_iter)?;
        Self::unpack(&account.try_borrow_data()?)
    }

    pub fn transfer(
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

    pub fn initialize_mint_account(accounts: &[AccountInfo]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let mint_account_info = next_account_info(account_info_iter)?;
        let mint_token_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;

        let instruction = instruction::mint_to(
            &spl_token::id(), 
            mint_account_info.key, 
            mint_token_info.key, 
            wallet_info.key, 
            &[], 
            INITIAL_SUPPLY
        )?;
        program::invoke(&instruction, accounts)?;

        let instruction = instruction::set_authority(
            &spl_token::id(),
            mint_account_info.key,
            None,
            instruction::AuthorityType::MintTokens,
            wallet_info.key, 
            &[]
        )?;
        program::invoke(&instruction, accounts)
    }

    pub fn create_nft(accounts: &[AccountInfo]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let mint_account_info = next_account_info(account_info_iter)?;
        let mint_token_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;

        let instruction = instruction::mint_to(
            &spl_token::id(), 
            mint_account_info.key, 
            mint_token_info.key, 
            wallet_info.key, 
            &[], 
            1
        )?;
        program::invoke(&instruction, accounts)?;

        let instruction = instruction::set_authority(
            &spl_token::id(),
            mint_account_info.key,
            None,
            instruction::AuthorityType::MintTokens,
            wallet_info.key, 
            &[]
        )?;
        program::invoke(&instruction, accounts)
    }

    fn validate_new_token(
        account_info: &AccountInfo,
        wallet_info: &AccountInfo,
        program_id: &Pubkey,
    ) -> ProgramResult {
        if !wallet_info.is_signer {
            return Err(CustomError::MissingSignature.into());
        }
        if account_info.owner != program_id {
            return Err(CustomError::OwnerMismatch.into());
        }

        let token_data = Self::unpack(&account_info.try_borrow_data()?);
        match token_data {
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

    fn validate_deposit_transaction(bidder_wallet: &AccountInfo, deposit_token_info: &AccountInfo, deposit_token: Token) -> ProgramResult {
        if !deposit_token_info.is_signer || !bidder_wallet.is_signer {
            return Err(CustomError::MissingSignature.into());
        }
        if deposit_token.bidder != *bidder_wallet.key {
            return Err(CustomError::OwnerMismatch.into());
        }
        Ok(())
    }
}
