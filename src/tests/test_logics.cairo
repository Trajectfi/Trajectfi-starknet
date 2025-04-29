use starknet::ContractAddress;
use starknet::storage::{StoragePathEntry, StoragePointerWriteAccess};
use trajectfi::components::logics::LogicComponent;
use trajectfi::components::logics::LogicComponent::InternalTrait;
use trajectfi::trajectfi::Trajectfi;

type TestingState = LogicComponent::ComponentState<Trajectfi::ContractState>;

#[test]
fn test_unique_id_validity() {
    let mut state: TestingState = LogicComponent::component_state_for_testing();

    let address: ContractAddress = 'address'.try_into().unwrap();
    let id: u256 = 42;

    // Fresh ID must be valid
    let result = state.is_valid_unique_id(address, id);
    assert(result == true, 'ID should be valid');

    // Mark the ID as non-unique
    state.is_unique_id_invalid.entry((address, id)).write(true);

    // Now the ID must be invalid
    let result = state.is_valid_unique_id(address, id);
    assert(result == false, 'IDs should be invalid');
}
