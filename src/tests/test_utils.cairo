use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::{ContractAddress, contract_address_const};

pub fn deploy_contract() -> (ContractAddress, ContractAddress) {
    let owner_address = contract_address_const::<'owner_address'>();

    let contract = declare("Trajectfi").expect('Declaration failed').contract_class();
    let mut calldata: Array<felt252> = array![owner_address.into()];
    let (contract_address, _) = contract.deploy(@calldata).expect('Trajectfi deployment failed');

    (contract_address, owner_address)
}

#[test]
fn test_admin_fee_zero_interest() {
    let interest = u256_from_u32(0);
    let admin_fee_bps = u256_from_u32(500);
    let expected = u256_from_u32(0);
    let result = compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Zero interest failed');
}

#[test]
fn test_admin_fee_zero_fee() {
    let interest = u256_from_u32(100_000);
    let admin_fee_bps = u256_from_u32(0);
    let expected = u256_from_u32(0);
    let result = compute_admin_fee(interest, admin_fee_bps);
    assert(result == expected, 'Zero fee failed');
}