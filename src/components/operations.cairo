/// Components for the major operations of Trajectfi.
/// This Operations are:
/// starting a loan , repaying a loan, renegotiating a loan and foreclosing a loan.
/// This component will be dependent on all other components defined in the Trajectfi contract

#[starknet::component]
pub mod OperationsComponent {
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StorageMapReadAccess, StoragePathEntry, StoragePointerReadAccess,
        StoragePointerWriteAccess,
    };
    use trajectfi::interfaces::ioperations::IOperations;
    use crate::types::Loan;


    #[storage]
    pub struct Storage {
        pub loans: Map<u256, Loan>,
        pub loan_count: u256,
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
    > of InternalTrait<TContractState> {}
}
