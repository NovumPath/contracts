use solana_program::{
    account_info::{AccountInfo},
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    entrypoint,
    msg,
};
use crate::{
    error::CustomError,
    member::Member,
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
            Member::register_member(accounts, rest)
        },
        2 => {
            Member::get_member(accounts)?;
            Ok(())
        },
        4 => {
            Member::change_information(accounts, rest)
        },
        5 => {
            Member::block_member(accounts, rest[0] == 1, program_id)
        },
        6 => {
            Member::set_voter(accounts, rest[0] == 1)
        },
        _ => return Err(CustomError::InvalidInstruction.into())
    }
}