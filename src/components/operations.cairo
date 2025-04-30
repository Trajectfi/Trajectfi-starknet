/// Components for the major operations of Trajectfi.
/// This Operations are:
/// starting a loan , repaying a loan, renegotiating a loan and foreclosing a loan.
/// This component will be dependent on all other components defined in the Trajectfi contract

#[starknet::component]
pub mod OperationsComponent {
    use starknet::{ContractAddress, get_block_timestamp};
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
    pub enum Event {
        LoanCreated: LoanCreated,
    }

    #[derive(Drop, starknet::Event)]
    pub struct LoanCreated {
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
        fn _create_loan(
            ref self: ComponentState<TContractState>,
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
            let id = self.loan_count.read() + 1;
            let loan_start_time = get_block_timestamp();
            let loan = Loan {
                principal,
                repayment_amount,
                collateral_contract,
                collateral_id,
                token_contract,
                loan_start_time,
                loan_duration,
                admin_fee,
                lender,
                borrower,
                id
            };
            self.loans.entry(id).write(loan);
            self.loan_count.write(id);
            self
                .emit(
                    LoanCreated {
                        principal,
                        repayment_amount,
                        collateral_contract,
                        collateral_id,
                        token_contract,
                        loan_start_time,
                        loan_duration,
                        admin_fee,
                        lender,
                        borrower,
                        id
                    }
                );
            id
        }
    }
}
