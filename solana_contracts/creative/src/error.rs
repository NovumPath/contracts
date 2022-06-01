use num_derive::FromPrimitive;
use solana_program::{decode_error::DecodeError, program_error::ProgramError};
use thiserror::Error;

#[derive(Clone, Debug, Eq, Error, FromPrimitive, PartialEq)]
pub enum CustomError {
    #[error("Owner does not match.")]
    OwnerMismatch,
    #[error("Account is already initialized.")]
    AlreadyInitialized,
    #[error("You are not registered yet.")]
    NotRegistered,
    #[error("The sender must be a bidder.")]
    NotBidder,
    #[error("Unknown role.")]
    UnknownRole,
    #[error("Bidder is unauthorized.")]
    BiddersUnauthorized,
    #[error("Invalid instruction.")]
    InvalidInstruction,
    #[error("Insufficient funds.")]
    InsufficientFunds,
    #[error("Only bidders can send this type of transaction.")]
    AccountNotBidder,
    #[error("Owner account is not a signer.")]
    MissingSignature,
    #[error("Invalid contract type.")]
    InvalidContractType,
    #[error("Insufficient lamports in payer account.")]
    InsufficientLamports,
}
impl From<CustomError> for ProgramError {
    fn from(e: CustomError) -> Self {
        ProgramError::Custom(e as u32)
    }
}
impl<T> DecodeError<T> for CustomError {
    fn type_of() -> &'static str {
        "CustomError"
    }
}