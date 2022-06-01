use solana_program::{
    account_info::AccountInfo,
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey
};
use crate::{
    error::CustomError,
    creative::Creative
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
            Creative::announce_creative(accounts, rest, program_id)
        },
        5 => {
            Creative::announce_creatives(accounts, rest, program_id)
        }, 
        6 => {
            Creative::start_block_creative(accounts, rest)
        },
        7 => {
            Creative::end_block_creative(accounts, rest)
        },
        _ => return Err(CustomError::InvalidInstruction.into())
    }
}