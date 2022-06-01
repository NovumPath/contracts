use crate::error::CustomError;
use arrayref::{array_mut_ref, array_ref, array_refs, mut_array_refs};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    program_error::ProgramError,
    program_pack::{IsInitialized, Pack, Sealed},
    pubkey::Pubkey,
};
use std::str;

pub const ROLE_BIDDER: u8 = 1;
pub const ROLE_ADVERTISER: u8 = 2;
pub const ROLE_PUBLISHER: u8 = 3;
pub const ROLE_VOTER: u8 = 4;

#[derive(Debug)]
pub struct Member {
    name: String,
    endpoint: String,
    pub role: u8,
    voter: bool,
    initialized: bool,
    owner: Pubkey,
    last_blocked_member: Pubkey,
    last_unblocked_member: Pubkey
}
impl IsInitialized for Member {
    fn is_initialized(&self) -> bool {
        self.initialized
    }
}
impl Sealed for Member {}
impl Pack for Member {
    const LEN: usize = 32 + 64 + 1 + 1 + 1 + 32 + 32 + 32;
    fn unpack_from_slice(src: &[u8]) -> Result<Self, ProgramError> {
        let src = array_ref![src, 0, Member::LEN];
        let (name, endpoint, role, voter, initialized, owner, last_blocked_member, last_unblocked_member) =
            array_refs![src, 32, 64, 1, 1, 1, 32, 32, 32];
        Ok(Member {
            name: String::from(str::from_utf8(name).unwrap()),
            endpoint: String::from(str::from_utf8(endpoint).unwrap()),
            role: role[0],
            voter: voter[0] != 0,
            initialized: initialized[0] != 0,
            owner: Pubkey::new(owner),
            last_blocked_member: Pubkey::new(last_blocked_member),
            last_unblocked_member: Pubkey::new(last_unblocked_member)
        })
    }

    fn pack_into_slice(&self, dst: &mut [u8]) {
        let dst = array_mut_ref![dst, 0, Member::LEN];
        let (name_dst, endpoint_dst, role_dst, voter_dst, initialized_dst, owner_dst, blocked_member_dst, unblocked_member_dst) =
            mut_array_refs![dst, 32, 64, 1, 1, 1, 32, 32, 32];
        let &Member {
            ref name,
            ref endpoint,
            role,
            voter,
            initialized,
            ref owner,
            ref last_blocked_member,
            ref last_unblocked_member
        } = self;

        name_dst.copy_from_slice(name.as_ref());
        endpoint_dst.copy_from_slice(endpoint.as_ref());
        role_dst[0] = role as u8;
        voter_dst[0] = voter as u8;
        initialized_dst[0] = initialized as u8;
        owner_dst.copy_from_slice(owner.as_ref());
        blocked_member_dst.copy_from_slice(last_blocked_member.as_ref());
        unblocked_member_dst.copy_from_slice(last_unblocked_member.as_ref());
    }
}

impl Member {
    pub fn register_member(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
        let account_info_iter = &mut accounts.iter();
        let account_info = next_account_info(account_info_iter)?;
        let wallet_info = next_account_info(account_info_iter)?;

        if !wallet_info.is_signer {
            return Err(CustomError::MissingSignature.into());
        }

        let member = Self::initialize_member(data, *wallet_info.key);
        Self::validate_new_member(account_info, member.role)?;
        Member::pack(member, &mut account_info.try_borrow_mut_data()?)
    }

    pub fn change_information(accounts: &[AccountInfo], data: &[u8]) -> ProgramResult {
        let account_iter = &mut accounts.iter();
        let account_info = next_account_info(account_iter)?;
        let owner_info = next_account_info(account_iter)?;
        let mut account = Self::unpack(&account_info.try_borrow_data()?)?;

        Self::check_owner_match(&account, account_info, owner_info)?;

        let data = array_ref![data, 0, (32 + 64)];
        let (name, endpoint) = array_refs![data, 32, 64];
        account.name = String::from(str::from_utf8(name).unwrap());
        account.endpoint = String::from(str::from_utf8(endpoint).unwrap());
        Self::pack(account, &mut account_info.try_borrow_mut_data()?)
    }

    pub fn block_member(
        accounts: &[AccountInfo],
        is_blocked: bool,
        program_id: &Pubkey,
    ) -> ProgramResult {
        let account_iter = &mut accounts.iter();
        let bidder_info = next_account_info(account_iter)?;
        let member_info = next_account_info(account_iter)?;

        let mut bidder = Self::unpack(&bidder_info.try_borrow_mut_data()?)?;
        if bidder.role != ROLE_BIDDER || bidder_info.owner != program_id {
            return Err(CustomError::AccountNotBidder.into());
        }

        if is_blocked {
            bidder.last_blocked_member =  *member_info.key;
        } else {
            bidder.last_unblocked_member = *member_info.key;
        }
        Self::pack(bidder, &mut bidder_info.try_borrow_mut_data()?)
    }

    pub fn set_voter(accounts: &[AccountInfo], is_voter: bool) -> ProgramResult {
        let account_iter = &mut accounts.iter();
        let account_info = next_account_info(account_iter)?;
        let owner_info = next_account_info(account_iter)?;
        let mut account = Self::unpack(&account_info.try_borrow_data()?)?;

        Self::check_owner_match(&account, account_info, owner_info)?;

        account.voter = is_voter;
        Self::pack(account, &mut account_info.try_borrow_mut_data()?)
    }

    pub fn get_member(accounts: &[AccountInfo]) -> Result<Self, ProgramError> {
        let account_iter = &mut accounts.iter();
        let account = next_account_info(account_iter)?;
        Self::unpack(&account.try_borrow_data()?)
    }

    fn initialize_member(data: &[u8], owner: Pubkey) -> Member {
        let data = array_ref![data, 0, (32 + 64 + 1)];
        let (name, endpoint, role) = array_refs![data, 32, 64, 1];
        let name = String::from(str::from_utf8(name).unwrap());
        let role = role[0];
        let endpoint = if role != ROLE_VOTER {
            String::from(str::from_utf8(endpoint).unwrap())
        } else {
            String::from("")
        };

        let default_pubkey = [0; 32];
        Member {
            name,
            endpoint,
            role,
            voter: role == ROLE_VOTER,
            initialized: true,
            owner,
            last_blocked_member: Pubkey::new(&default_pubkey),
            last_unblocked_member: Pubkey::new(&default_pubkey)
        }
    }

    fn validate_new_member(
        account_info: &AccountInfo,
        role: u8,
    ) -> ProgramResult {
        let account_data = &account_info.try_borrow_data()?;
        if account_data.len() > 0 {
            match Self::unpack(account_data) {
                Ok(_) => {
                    return Err(CustomError::AlreadyInitialized.into());
                }
                Err(e) => {
                    if e != ProgramError::UninitializedAccount {
                        return Err(e);
                    }
                }
            }
        }

        if role > 4 {
            return Err(CustomError::UnknownRole.into());
        }
        Ok(())
    }

    fn check_owner_match(
        account: &Self,
        account_info: &AccountInfo,
        owner_info: &AccountInfo,
    ) -> ProgramResult {
        if account.role == 0 {
            return Err(CustomError::NotRegistered.into());
        }
        if !account_info.is_signer || !owner_info.is_signer {
            return Err(CustomError::MissingSignature.into());
        }
        if account.owner != *owner_info.key {
            return Err(CustomError::OwnerMismatch.into());
        }
        Ok(())
    }
}
