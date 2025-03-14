/// Components for the major operations of Trajectfi.
/// This Operations are:
/// starting a loan , repaying a loan, renegotiating a loan and foreclosing a loan.
/// This component will be dependent on all other components defined in the Trajectfi contract

#[starknet::component]
pub mod OperationsComponent {
    use trajectfi::interfaces::ioperations::IOperations;


    #[storage]
    pub struct Storage {}
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[embeddable_as(OperationsImpl)]
    impl Operations<
        TContractState, +HasComponent<TContractState>
    > of IOperations<ComponentState<TContractState>> {}

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>, +Drop<TContractState>
    > of InternalTrait<TContractState> {}
}
