use starknet::ContractAddress;
use snforge_std::{start_cheat_caller_address, stop_cheat_caller_address};
use trajectfi::tests::test_utils::deploy_contract;
use trajectfi::interfaces::itrajectfi::{ITrajectfiDispatcher, ITrajectfiDispatcherTrait};

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
