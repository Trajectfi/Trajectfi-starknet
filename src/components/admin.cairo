#[starknet::component]
pub mod AdminComponent {
    use trajectfi::interfaces::iadmin::IAdmin;


    #[storage]
    pub struct Storage {}
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[embeddable_as(AdminImpl)]
    impl Admin<
        TContractState, +HasComponent<TContractState>
    > of IAdmin<ComponentState<TContractState>> {}

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {}
}
