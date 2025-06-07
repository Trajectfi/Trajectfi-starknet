use starknet::{ContractAddress};
use starknet::storage::{StoragePointerWriteAccess, StoragePathEntry};
use trajectfi::components::operations::OperationsComponent;
use trajectfi::components::operations::OperationsComponent::{OperationsImpl};
use trajectfi::types::{Loan, LoanStatus};


#[test]
fn test_get_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    let timestamp = 3000000000_u64;

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
        status: LoanStatus::ONGOING,
    };

    state.operations.loans.entry(loan_id).write(loan);

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
    use starknet::ContractAddress;
    use trajectfi::components::operations::OperationsComponent;

    component!(path: OperationsComponent, storage: operations, event: OperationsEvent);

    #[abi(embed_v0)]
    pub impl OperationsImpl = OperationsComponent::OperationsImpl<ContractState>;
    pub impl OperationsInternalImpl = OperationsComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub operations: OperationsComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OperationsEvent: OperationsComponent::Event,
    }

    #[generate_trait]
    pub impl InternalImpl of InternalTrait {
        fn create_loan(
            ref self: ContractState,
            principal: u256,
            repayment_amount: u256,
            collateral_contract: ContractAddress,
            collateral_id: u256,
            token_contract: ContractAddress,
            loan_duration: u64,
            admin_fee: u64,
            lender: ContractAddress,
            borrower: ContractAddress
        ) -> u256 {
            self
                .operations
                ._create_loan(
                    principal,
                    repayment_amount,
                    collateral_contract,
                    collateral_id,
                    token_contract,
                    loan_duration,
                    admin_fee,
                    lender,
                    borrower
                )
        }
    }
}

use MockOperationsContract::InternalTrait;

#[test]
fn test_create_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();
    let principal = 1000_u256;
    let repayment_amount = 1100_u256;
    let collateral_id = 1_u256;
    let loan_duration = 86400_u64;
    let admin_fee = 250_u64;
    let loan_id = state
        .create_loan(
            principal,
            repayment_amount,
            collateral_contract,
            collateral_id,
            token_contract,
            loan_duration,
            admin_fee,
            lender,
            borrower
        );
    let retrieved_loan = state.get_loan(loan_id);

    // Verify the loan details
    assert(retrieved_loan.id == loan_id, 'Wrong loan ID');
    assert(retrieved_loan.principal == 1000_u256, 'Wrong principal');
    assert(retrieved_loan.repayment_amount == 1100_u256, 'Wrong repayment amount');
    assert(retrieved_loan.collateral_contract == collateral_contract, 'Wrong collateral contract');
    assert(retrieved_loan.collateral_id == 1_u256, 'Wrong collateral ID');
    assert(retrieved_loan.token_contract == token_contract, 'Wrong token contract');
    assert(retrieved_loan.loan_duration == 86400_u64, 'Wrong loan duration');
    assert(retrieved_loan.admin_fee == 250_u64, 'Wrong admin fee');
    assert(retrieved_loan.borrower == borrower, 'Wrong borrower');
    assert(retrieved_loan.lender == lender, 'Wrong lender');
    assert(retrieved_loan.status == LoanStatus::ONGOING, 'Wrong status');
}

fn test_is_active_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    let timestamp = 3000000000_u64;

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
        status: LoanStatus::ONGOING,
    };

    state.operations.loans.entry(loan_id).write(loan);

    assert(state.is_active_loan(loan_id), 'Loan should be active');
}
fn test_is_active_loan_false() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    let timestamp = 3000000000_u64;

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
        status: LoanStatus::REPAID
    };

    state.operations.loans.entry(loan_id).write(loan);

    assert(!state.is_active_loan(loan_id), 'Loan should not be active');
}

// ---- Test for is_valid_loan ----
#[test]
fn test_is_valid_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create loan directly in storage
    let loan_id = 1_u256;

    // Create a valid loan
    let valid_loan = create_test_loan(loan_id, LoanStatus::ONGOING);
    state.operations.loans.entry(loan_id).write(valid_loan);
    state.operations.loan_exists.entry(loan_id).write(true);

    // Check if the loan is valid
    assert(state.is_valid_loan(loan_id), 'Loan should be valid/true');
}

#[test]
fn test_is_valid_loan_non_existent() {
    // Setup
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();
    let non_existent_loan_id = 123_u256;

    // Check
    assert(!state.is_valid_loan(non_existent_loan_id), 'Should return false');
}

#[test]
fn test_is_valid_loan_zero_id() {
    // Setup
    let state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Test
    assert(!state.is_valid_loan(0_u256), 'Should return false');
}

#[test]
fn test_is_valid_loan_mismatched_id() {
    // Setup
    let mut state = MockOperationsContract::contract_state_for_testing();
    let loan_id = 789_u256;

    // Create loan with mismatched ID
    let loan_with_wrong_id = create_test_loan(id: 10_u256, status: LoanStatus::ONGOING);
    state.operations.loans.entry(loan_id).write(loan_with_wrong_id);

    // Test
    let is_valid = state.is_valid_loan(loan_id);
    assert(!is_valid, 'Should return false');
}

#[test]
fn test_is_valid_loan_foreclosed_status() {
    // Setup
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create a loan with FORECLOSED status
    let loan_id = 1_u256;
    let foreclosed_loan = create_test_loan(loan_id, LoanStatus::FORECLOSED);
    state.operations.loans.entry(loan_id).write(foreclosed_loan);
    state.operations.loan_exists.entry(loan_id).write(true);

    // Check if the loan is valid
    assert(state.is_valid_loan(loan_id), 'Loan should still be valid');
}

#[test]
fn test_is_valid_loan_repaid_status() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create a loan with REPAID status
    let loan_id = 1_u256;
    let repaid_loan = create_test_loan(loan_id, LoanStatus::REPAID);
    state.operations.loans.entry(loan_id).write(repaid_loan);
    state.operations.loan_exists.entry(loan_id).write(true);

    // Check if the loan is valid
    assert(state.is_valid_loan(loan_id), 'Loan should be still valid');
}


// Helper function to create test loans
fn create_test_loan(id: u256, status: LoanStatus) -> Loan {
    Loan {
        id,
        principal: 1000_u256,
        repayment_amount: 1100_u256,
        collateral_contract: contract_address_const::<1>(),
        collateral_id: 1_u256,
        token_contract: contract_address_const::<2>(),
        loan_start_time: 3600000000_u64,
        loan_duration: 86400_u64,
        admin_fee: 250_u64,
        borrower: contract_address_const::<3>(),
        lender: contract_address_const::<4>(),
        status,
    }
}

#[test]
fn test_can_renegotiate_active_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create loan directly in storage
    let loan_id = 1_u256;

    // Create a valid loan
    let valid_loan = create_test_loan(loan_id, LoanStatus::ONGOING);
    state.operations.loans.entry(loan_id).write(valid_loan);
    state.operations.loan_exists.entry(loan_id).write(true);

    // Verify an active loan can be renegotiated
    let result = state.can_renegotiate_loan(loan_id);
    assert(result, 'Loan should be renegotiable');
}

#[test]
fn test_can_renegotiate_repaid_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    let timestamp = 3000000000_u64;

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
        status: LoanStatus::REPAID,
    };
    state.operations.loans.entry(loan_id).write(loan);

    // Verify a repaid loan cannot be renegotiated
    let result = state.can_renegotiate_loan(loan_id);
    assert(!result, 'Loan should not be renegotiable');
}

#[test]
fn test_can_renegotiate_foreclosed_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Create mock addresses
    let borrower = contract_address_const::<1>();
    let lender = contract_address_const::<2>();
    let collateral_contract = contract_address_const::<3>();
    let token_contract = contract_address_const::<4>();

    let timestamp = 3000000000_u64;

    // Create loan directly in storage (foreclosed)
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
        status: LoanStatus::FORECLOSED,
    };
    state.operations.loans.entry(loan_id).write(loan);

    // Verify a foreclosed loan cannot be renegotiated
    let result = state.can_renegotiate_loan(loan_id);
    assert(!result, 'Loan should not be renegotiable');
}

#[test]
fn test_can_renegotiate_invalid_id_loan() {
    // Setup test environment
    let mut state: MockOperationsContract::ContractState =
        MockOperationsContract::contract_state_for_testing();

    // Use a loan ID that does not exist
    let invalid_id = 99_u256;

    // Verify an uninitialised loan cannot be renegotiated
    let result = state.can_renegotiate_loan(invalid_id);
    assert(!result, 'Loan should not be renegotiable');
}
