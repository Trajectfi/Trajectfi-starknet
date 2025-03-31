use snforge_std::{ContractClassTrait, DeclareResultTrait, declare, load, map_entry_address, store};
use starknet::testing::{set_block_timestamp, set_caller_address, set_contract_address};
use starknet::{ContractAddress, get_block_timestamp};
use trajectfi::components::operations::OperationsComponent;
use trajectfi::components::operations::OperationsComponent::{InternalTrait, OperationsImpl};
use trajectfi::types::Loan;
use super::test_utils::deploy_contract;


#[test]
fn test_get_loan() {
    // Setup test environment
    let mut state = OperationsComponent::component_state_for_testing();
    let (contract_address, _) = deploy_contract();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    // Set block timestamp for testing
    set_block_timestamp(1000);
    let timestamp = get_block_timestamp();

    // Create loan directly in storage
    let loan_id = 1_u256;
    let loan = Loan {
        id: loan_id,
        principal: 1000_u256,
        repayment_amount: 1100_u256,
        collateral_contract,
        collateral_id: 1_u256,
        token_contract,
        loan_start_time: timestamp,
        loan_duration: 86400_u64,
        admin_fee: 250_u64,
        borrower,
        lender,
    };

    // Write loan to storage
    store(contract_address, map_entry_address(selector!("loans"), loan_id.into()), loan.into());

    store(contract_address, selector!("loan_count"), array![loan_id].span());
    // Retrieve the loan using the get_loan function
    let retrieved_loan = state.get_loan(loan_id);

    // Verify the loan details
    assert(retrieved_loan.id == loan_id, 'Wrong loan ID');
    assert(retrieved_loan.principal == 1000_u256, 'Wrong principal');
    assert(retrieved_loan.repayment_amount == 1100_u256, 'Wrong repayment amount');
    assert(retrieved_loan.collateral_contract == collateral_contract, 'Wrong collateral contract');
    assert(retrieved_loan.collateral_id == 1_u256, 'Wrong collateral ID');
    assert(retrieved_loan.token_contract == token_contract, 'Wrong token contract');
    assert(retrieved_loan.loan_start_time == timestamp, 'Wrong loan start time');
    assert(retrieved_loan.loan_duration == 86400_u64, 'Wrong loan duration');
    assert(retrieved_loan.admin_fee == 250_u64, 'Wrong admin fee');
    assert(retrieved_loan.borrower == borrower, 'Wrong borrower');
    assert(retrieved_loan.lender == lender, 'Wrong lender');
}


// Helper function to create contract addresses for testing
fn contract_address_const<const ADDRESS: felt252>() -> ContractAddress {
    starknet::contract_address_const::<ADDRESS>()
}

#[starknet::contract]
mod MockOperationsContract {
    use trajectfi::components::operations::OperationsComponent;
    use trajectfi::types::Loan;

    component!(path: OperationsComponent, storage: operations, event: OperationsEvent);

    #[abi(embed_v0)]
    impl OperationsImpl = OperationsComponent::OperationsImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        operations: OperationsComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OperationsEvent: OperationsComponent::Event,
    }
}
