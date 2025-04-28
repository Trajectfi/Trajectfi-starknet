use core::integer::u256;
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::{ContractAddress, contract_address_const};
use crate::components::logics::compute_admin_fee;

pub fn deploy_contract() -> (ContractAddress, ContractAddress) {
    let owner_address = contract_address_const::<'owner_address'>();

    let contract = declare("Trajectfi").expect('Declaration failed').contract_class();
    let mut calldata: Array<felt252> = array![owner_address.into()];
    let (contract_address, _) = contract.deploy(@calldata).expect('Trajectfi deployment failed');

    (contract_address, owner_address)
}

#[test]
fn test_admin_fee_standard_percentage() {
    let interest = 100_000_u256;
    let admin_fee_bps = 500_u256; // 5%
    let expected = 5_000_u256; // (100_000 * 500) / 10_000 = 5_000
    let result = compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Standard percentage failed');
}

#[test]
fn test_admin_fee_large_interest() {
    let interest = u256 { low: 0, high: 1_000_000 };
    let admin_fee_bps = 1000_u256; // 10%
    let expected = u256 { low: 0, high: 100_000 };
    let result = compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Large interest failed');
}

#[test]
fn test_admin_fee_zero_interest() {
    let interest = 0_u256;
    let admin_fee_bps = 500_u256;
    let expected = 0_u256;
    let result = compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Zero interest failed');
}

#[test]
fn test_admin_fee_zero_fee() {
    let interest = 100_000_u256;
    let admin_fee_bps = 0_u256;
    let expected = 0_u256;
    let result = compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Zero fee failed');
}
