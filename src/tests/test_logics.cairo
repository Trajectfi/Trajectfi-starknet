use starknet::ContractAddress;
use snforge_std::{start_cheat_caller_address, stop_cheat_caller_address};
use trajectfi::tests::test_utils::deploy_contract;
use trajectfi::interfaces::itrajectfi::{ITrajectfiDispatcher, ITrajectfiDispatcherTrait};
use starknet::storage::{StoragePathEntry, StoragePointerWriteAccess};
use trajectfi::components::logics::LogicComponent;
use trajectfi::components::logics::LogicComponent::InternalTrait;
use trajectfi::trajectfi::Trajectfi;

type TestingState = LogicComponent::ComponentState<Trajectfi::ContractState>;

#[test]
fn test_is_unique_id_invalid() {
    let mut state: TestingState = LogicComponent::component_state_for_testing();

    let address: ContractAddress = 'address'.try_into().unwrap();
    let id: u256 = 42;

    // Fresh ID must be valid
    let result = state.is_unique_id_invalid(address, id);
    assert(result == false, 'ID should be valid');

    // Mark the ID as non-unique
    state.is_unique_id_invalid.entry((address, id)).write(true);

    // Now the ID must be invalid
    let result = state.is_unique_id_invalid(address, id);
    assert(result == true, 'IDs should be invalid');
}

#[test]
fn test_invalidate_unique_id() {
    let (contract_address, owner_address) = deploy_contract();

    let dispatcher = ITrajectfiDispatcher { contract_address };

    let unique_id = 123_u256;

    start_cheat_caller_address(dispatcher.contract_address, owner_address);

    let result = dispatcher.invalidate_unique_id(unique_id);
    assert(result == true, 'Should be newly invalidated');

    let is_invalid = dispatcher.is_unique_id_invalid(owner_address, unique_id);
    assert(is_invalid == true, 'Should be marked as invalid');

    let result = dispatcher.invalidate_unique_id(unique_id);
    assert(result == false, 'Should be already invalidated');

    let different_id = 456_u256;
    let is_invalid = dispatcher.is_unique_id_invalid(owner_address, different_id);
    assert(is_invalid == false, 'Different ID should be valid');

    stop_cheat_caller_address(dispatcher.contract_address);
}
#[starknet::contract]
mod MockLogicsContract {
    use starknet::ContractAddress;
    use trajectfi::components::logics::LogicComponent;


    component!(path: LogicComponent, storage: logics, event: LogicEvent);


    pub impl LogicsInternalImpl = LogicComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub logics: LogicComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        LogicEvent: LogicComponent::Event,
    }

    #[generate_trait]
    pub impl InternalImpl of InternalTrait {
        fn invalidate_unique_id(ref self: ContractState, unique_id: u256) -> bool {
            self.logics.invalidate_unique_id(unique_id)
        }
        fn is_unique_id_invalid(
            self: @ContractState,
            contract_address: ContractAddress,
            unique_id: u256
        ) -> bool {
            self.logics.is_unique_id_invalid(contract_address, unique_id)
        }
        fn compute_admin_fee(self: @ContractState, interest: u256, admin_fee_bps: u256) -> u256 {
            self.logics.compute_admin_fee(interest, admin_fee_bps)
        }
    }
}