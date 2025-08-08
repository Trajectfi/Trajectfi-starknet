#[starknet::component]
pub mod MarketComponent {
    #[storage]
    pub struct Storage {}

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {}
}
