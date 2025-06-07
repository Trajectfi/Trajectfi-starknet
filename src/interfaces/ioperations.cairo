use crate::types::Loan;

#[starknet::interface]
pub trait IOperations<TContractState> {
    fn get_loan(self: @TContractState, loan_id: u256) -> Loan;
    fn is_active_loan(self: @TContractState, loan_id: u256) -> bool;
    fn is_valid_loan(self: @TContractState, loan_id: u256) -> bool;
    fn can_renegotiate_loan(self: @TContractState, loan_id: u256) -> bool;
}
