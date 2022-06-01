use solana_program::{
    account_info::{AccountInfo},
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    entrypoint,
    msg,
};
use crate::{
    error::CustomError,
    token::Token,
};

entrypoint!(process_instruction);

fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    let (instruction, rest) = instruction_data.split_first().ok_or(CustomError::InvalidInstruction)?;
    match instruction {
        1 => {
            Token::create_token(accounts, rest, program_id)
        },
        2 => {
            Token::make_payment(accounts, rest)
        },
        3 => {
            Token::make_deposit(accounts, rest)
        },
        4 => {
            Token::withdraw_deposit(accounts, rest)
        },
        5 => {
            Token::fine_deposit(accounts, rest)
        }
        6 => {
            let token = Token::get_token(accounts);
            msg!("token: {:?}", token.unwrap());
            Ok(())
        },
        7 => {
            Token::initialize_mint_account(accounts)
        },
        8 => {
            Token::create_nft(accounts)
        },
        _ => return Err(CustomError::InvalidInstruction.into())
    }
}