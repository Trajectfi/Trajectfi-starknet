use core::integer::u256;

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
        /// Computes the admin fee from interest using basis points (bps).
        /// admin_fee = (interest * admin_fee_bps) / 10_000
        /// Handles zero values and uses safe u256 math.
        fn compute_admin_fee(self: @ComponentState<TContractState>, interest: u256, admin_fee_bps: u256) -> u256 {
            if interest == 0_u256 || admin_fee_bps == 0_u256 {
                return 0_u256;
            }
            let product = interest * admin_fee_bps;
            let fee = product / 10_000_u256;
            fee
        }
    }
}

