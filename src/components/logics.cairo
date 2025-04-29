#[starknet::component]
pub mod LogicComponent {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess};

    #[storage]
    pub struct Storage {
        pub is_unique_id_invalid: Map<(ContractAddress, u256), bool>,
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {
        fn is_valid_unique_id(
            self: @ComponentState<TContractState>,
            contract_address: ContractAddress,
            unique_id: u256,
        ) -> bool {
            !self.is_unique_id_invalid.entry((contract_address, unique_id)).read()
        }
    }
}
