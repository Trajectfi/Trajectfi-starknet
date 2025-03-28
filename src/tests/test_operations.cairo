use starknet::testing::{set_block_timestamp, set_caller_address, set_contract_address};
use starknet::{ContractAddress, get_block_timestamp};
use trajectfi::components::operations::OperationsComponent;
use trajectfi::components::operations::OperationsComponent::{InternalTrait, OperationsImpl};
use trajectfi::types::Loan;
#[test]
fn test_get_loan() {
    // Setup test environment
    let mut state = OperationsComponent::component_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    // Set block timestamp for testing
    set_block_timestamp(1000);
    let timestamp = get_block_timestamp();

    // Create test loan using internal function
    let loan_id = state
        .create_loan(
            1000_u256, // principal
            1100_u256, // repayment_amount
            collateral_contract, // collateral_contract
            1_u256, // collateral_id
            token_contract, // token_contract
            timestamp, // loan_start_time
            86400_u64, // loan_duration (1 day)
            250_u64, // admin_fee (2.5%)
            borrower, // borrower
            lender // lender
        );

    // Retrieve the loan using the get_loan function
    let loan = state.get_loan(loan_id);

    // Verify the loan details
    assert(loan.id == loan_id, 'Wrong loan ID');
    assert(loan.principal == 1000_u256, 'Wrong principal');
    assert(loan.repayment_amount == 1100_u256, 'Wrong repayment amount');
    assert(loan.collateral_contract == collateral_contract, 'Wrong collateral contract');
    assert(loan.collateral_id == 1_u256, 'Wrong collateral ID');
    assert(loan.token_contract == token_contract, 'Wrong token contract');
    assert(loan.loan_start_time == timestamp, 'Wrong loan start time');
    assert(loan.loan_duration == 86400_u64, 'Wrong loan duration');
    assert(loan.admin_fee == 250_u64, 'Wrong admin fee');
    assert(loan.borrower == borrower, 'Wrong borrower');
    assert(loan.lender == lender, 'Wrong lender');
}


// Helper function to create contract addresses for testing
fn contract_address_const<const ADDRESS: felt252>() -> ContractAddress {
    starknet::contract_address_const::<ADDRESS>()
}
