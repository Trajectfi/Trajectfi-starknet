use starknet::ContractAddress;

#[starknet::interface]
pub trait ILogicsComponent<TContractState> {
    fn invalidate_unique_id(ref self: TContractState, unique_id: u256) -> bool;
    fn is_unique_id_invalid(
        self: @TContractState, contract_address: ContractAddress, unique_id: u256
    ) -> bool;
}
