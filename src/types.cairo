// All types here
use starknet::{ContractAddress, contract_address_const};
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
    pub status: LoanStatus,
    pub id: u256,
}

#[derive(Copy, Drop, PartialEq, Serde, starknet::Store)]
pub enum LoanStatus {
    NOT_INITIALIZED,
    ONGOING,
    REPAID,
    FORECLOSED,
}

pub const OWNER_ROLE: felt252 = selector!("Owner");
pub const ADMIN_ROLE: felt252 = selector!("Admin");

#[generate_trait]
pub impl DefaultLoan of LoanTrait {
    fn default() -> Loan {
        Loan {
            principal: 0_u256,
            repayment_amount: 0_u256,
            collateral_contract: contract_address_const::<0>(),
            collateral_id: 0_u256,
            token_contract: contract_address_const::<0>(),
            loan_start_time: 0_u64,
            loan_duration: 0_u64,
            admin_fee: 0_u64,
            borrower: contract_address_const::<0>(),
            lender: contract_address_const::<0>(),
            status: LoanStatus::NOT_INITIALIZED,
            id: 0_u256,
        }
    }
}
