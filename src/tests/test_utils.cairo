use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::{ContractAddress, contract_address_const};

pub fn deploy_contract() -> (ContractAddress, ContractAddress) {
    let owner_address = contract_address_const::<'owner_address'>();

    let contract = declare("Trajectfi").expect('Declaration failed').contract_class();
    let mut calldata: Array<felt252> = array![owner_address.into()];
    let (contract_address, _) = contract.deploy(@calldata).expect('Trajectfi deployment failed');

    (contract_address, owner_address)
}
