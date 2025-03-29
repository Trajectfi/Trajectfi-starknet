use crate::types::Loan;

#[starknet::interface]
pub trait IOperations<TContractState> {
    fn get_loan(self: @TContractState, loan_id: u256) -> Loan;
}

