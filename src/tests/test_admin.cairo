use snforge_std::{
    EventSpyAssertionsTrait, spy_events, start_cheat_caller_address, stop_cheat_caller_address,
};
use starknet::contract_address_const;
use trajectfi::components::admin::AdminComponent;
use trajectfi::interfaces::iadmin::{IAdminDispatcher, IAdminDispatcherTrait};
use super::test_utils::deploy_contract;

#[test]
fn test_set_and_get_admin_fee() {
    let (contract_address, owner_address) = deploy_contract();
    let admin_dispatcher = IAdminDispatcher { contract_address };

    let fee: u64 = 10;
    start_cheat_caller_address(contract_address, owner_address);
    let mut spy = spy_events();

    admin_dispatcher.set_admin_fee(fee);
    stop_cheat_caller_address(contract_address);

    assert!(
        admin_dispatcher.get_admin_fee() == fee,
        "The stored admin fee does not match the expected value",
    );

    let expected_event = AdminComponent::Event::AdminFeeUpdated(
        AdminComponent::AdminFeeUpdated { caller: owner_address, new_fee: fee },
    );
    spy.assert_emitted(@array![(contract_address, expected_event)]);
}

#[test]
#[should_panic(expected: 'Error: Missing required role')]
fn test_set_admin_fee_unauthorized_call() {
    let (contract_address, _) = deploy_contract();
    let admin_dispatcher = IAdminDispatcher { contract_address };
    let user_address = contract_address_const::<'user_address'>();

    let fee: u64 = 10;
    start_cheat_caller_address(contract_address, user_address);
    admin_dispatcher.set_admin_fee(fee);
    stop_cheat_caller_address(contract_address);
}

#[test]
#[should_panic(expected: 'Error: New fee exceeds limit')]
fn test_set_admin_fee_exceeds_limit() {
    let (contract_address, owner_address) = deploy_contract();
    let admin_dispatcher = IAdminDispatcher { contract_address };

    let excessive_fee: u64 = 5000;
    start_cheat_caller_address(contract_address, owner_address);
    admin_dispatcher.set_admin_fee(excessive_fee);
    stop_cheat_caller_address(contract_address);
}
