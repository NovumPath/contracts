use solana_program::{
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    account_info::{next_account_info, AccountInfo},
    program
};
use spl_token::instruction;

pub const INITIAL_SUPPLY: u64 = 100000000 * 10u64.pow(8);

entrypoint!(initialize_mint_account);
pub fn initialize_mint_account(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
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