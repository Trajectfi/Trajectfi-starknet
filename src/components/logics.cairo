#[starknet::component]
pub mod LogicComponent {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};

    #[storage]
    pub struct Storage {
        pub is_unique_id_invalid: Map<(ContractAddress, u256), bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        UniqueIdInvalidated: UniqueIdInvalidated,
    }

    #[derive(Drop, starknet::Event)]
    pub struct UniqueIdInvalidated {
        pub contract_address: ContractAddress,
        pub unique_id: u256,
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {
        fn invalidate_unique_id(ref self: ComponentState<TContractState>, unique_id: u256) -> bool {
            let contract_address = get_caller_address();

            let key = (contract_address, unique_id);

            let is_already_invalid = self.is_unique_id_invalid.read(key);

            if !is_already_invalid {
                self.is_unique_id_invalid.write(key, true);

                self.emit(UniqueIdInvalidated { contract_address, unique_id });

                return true;
            }

            false
        }

        fn is_unique_id_invalid(
            self: @ComponentState<TContractState>,
            contract_address: ContractAddress,
            unique_id: u256
        ) -> bool {
            let key = (contract_address, unique_id);
            self.is_unique_id_invalid.read(key)
        }
    }
}
