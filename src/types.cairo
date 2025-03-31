// All types here
use starknet::ContractAddress;
#[derive(Copy, Drop, PartialEq, Serde, starknet::Store)]
pub struct Loan {
    pub principal: u256,
    pub repayment_amount: u256,
    pub collateral_contract: ContractAddress,
    pub collateral_id: u256,
    pub token_contract: ContractAddress,
    pub loan_start_time: u64,
    pub loan_duration: u64,
    pub admin_fee: u64,
    pub borrower: ContractAddress,
    pub lender: ContractAddress,
    pub id: u256,
}
pub const OWNER_ROLE: felt252 = selector!("Owner");
pub const ADMIN_ROLE: felt252 = selector!("Admin");

