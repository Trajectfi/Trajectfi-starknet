/// Components for the major operations of Trajectfi.
/// This Operations are:
/// starting a loan , repaying a loan, renegotiating a loan and foreclosing a loan.
/// This component will be dependent on all other components defined in the Trajectfi contract

#[starknet::component]
pub mod OperationsComponent {
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StorageMapReadAccess, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use trajectfi::interfaces::ioperations::IOperations;
    use crate::types::Loan;


    #[storage]
    pub struct Storage {
        loans: Map<u256, Loan>,
        loan_count: u256,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[embeddable_as(OperationsImpl)]
    impl Operations<
        TContractState, +HasComponent<TContractState>,
    > of IOperations<ComponentState<TContractState>> {
        fn get_loan(self: @ComponentState<TContractState>, loan_id: u256) -> Loan {
            // Check if the loan exists
            let loan = self.loans.read(loan_id);
            assert(loan.id == loan_id, 'Loan does not exist');
            loan
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>, +Drop<TContractState>,
    > of InternalTrait<TContractState> {
        fn create_loan(
            ref self: ComponentState<TContractState>,
            principal: u256,
            repayment_amount: u256,
            collateral_contract: ContractAddress,
            collateral_id: u256,
            token_contract: ContractAddress,
            loan_start_time: u64,
            loan_duration: u64,
            admin_fee: u64,
            borrower: ContractAddress,
            lender: ContractAddress,
        ) -> u256 {
            let loan_id = self.loan_count.read() + 1_u256;

            // Create the loan struct
            let loan = Loan {
                id: loan_id,
                principal,
                repayment_amount,
                collateral_contract,
                collateral_id,
                token_contract,
                loan_start_time,
                loan_duration,
                admin_fee,
                borrower,
                lender,
            };

            // Store the loan
            self.loans.write(loan_id, loan);

            // Increment loan count
            self.loan_count.write(loan_id);

            loan_id
        }
    }
}
