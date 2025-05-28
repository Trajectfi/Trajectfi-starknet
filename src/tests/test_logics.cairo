use starknet::ContractAddress;
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
    let mut state: TestingState = LogicComponent::component_state_for_testing();
    let unique_id: u256 = 10000;
    let owner_address: ContractAddress = 'address'.try_into().unwrap();
    state.invalidate_unique_id(owner_address, unique_id);

    let is_invalid = state.is_unique_id_invalid(owner_address, unique_id);
    assert(is_invalid == true, 'Should be marked as invalid');

    let different_id = 456_u256;
    let is_invalid = state.is_unique_id_invalid(owner_address, different_id);
    assert(is_invalid == false, 'Different ID should be valid');
}

#[test]
fn test_admin_fee_standard_percentage() {
    let mut state: TestingState = LogicComponent::component_state_for_testing();
    let interest = 100_000_u256;
    let admin_fee_bps = 500_u256; // 5%
    let expected = 5_000_u256; // (100_000 * 500) / 10_000 = 5_000
    let result = state.compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Standard percentage failed');
}

#[test]
fn test_admin_fee_large_interest() {
    let mut state: TestingState = LogicComponent::component_state_for_testing();
    let interest = u256 { low: 0, high: 1_000_000 };
    let admin_fee_bps = 1000_u256; // 10%
    let expected = u256 { low: 0, high: 100_000 };
    let result = state.compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Large interest failed');
}

#[test]
fn test_admin_fee_zero_interest() {
    let mut state: TestingState = LogicComponent::component_state_for_testing();
    let interest = 0_u256;
    let admin_fee_bps = 500_u256;
    let expected = 0_u256;
    let result = state.compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Zero interest failed');
}

#[test]
fn test_admin_fee_zero_fee() {
    let mut state: TestingState = LogicComponent::component_state_for_testing();
    let interest = 100_000_u256;
    let admin_fee_bps = 0_u256;
    let expected = 0_u256;
    let result = state.compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Zero fee failed');
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
        fn invalidate_unique_id(ref self: ContractState, owner: ContractAddress, unique_id: u256) {
            self.logics.invalidate_unique_id(owner, unique_id)
        }
        fn is_unique_id_invalid(
            self: @ContractState, contract_address: ContractAddress, unique_id: u256
        ) -> bool {
            self.logics.is_unique_id_invalid(contract_address, unique_id)
        }
        fn compute_admin_fee(self: @ContractState, interest: u256, admin_fee_bps: u256) -> u256 {
            self.logics.compute_admin_fee(interest, admin_fee_bps)
        }
    }
}
