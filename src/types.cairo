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

#[derive(Copy, Drop, PartialEq, Serde, starknet::Store)]
pub enum ListingStatus {
    OPEN,
    CLOSED,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
pub struct Listing {
    pub id: u256,
    pub nft_contract: ContractAddress,
    pub nft_id: u256,
    pub token_contract: Option<ContractAddress>,
    pub token_amount: Option<u256>,
    pub borrow_amount: Option<u256>,
    pub repayment_amount: Option<u256>,
    pub loan_duration: Option<u64>,
    pub status: ListingStatus,
    pub created_at: u64,
    pub updated_at: u64,
}

#[derive(Copy, Drop, PartialEq, Serde, starknet::Store)]
pub enum OfferStatus {
    OPEN,
    ACCEPTED,
    CLOSED,
    REJECTED
}

#[derive(Copy, Drop, Serde, starknet::Store)]
pub struct Offer {
    pub id: u256,
    pub listing_id: u256,
    pub borrower: ContractAddress,
    pub nft_contract: ContractAddress,
    pub nft_id: u256,
    pub token_contract: ContractAddress,
    pub token_amount: u256,
    pub borrow_amount: u256,
    pub repayment_amount: u256,
    pub loan_duration: u64,
    pub offer_expiration: u64,
    pub status: OfferStatus,
    pub created_at: u64,
    pub updated_at: u64,
}
