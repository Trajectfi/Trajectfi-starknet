#[starknet::interface]
pub trait ITrajectfi<TContractState> {
    /// Pauses the contract (only callable by owner)
    fn pause(ref self: TContractState);

    /// Unpauses the contract (only callable by owner)
    fn unpause(ref self: TContractState);
    
    /// Invalidates a unique ID to prevent replay attacks
    fn invalidate_unique_id(ref self: TContractState, unique_id: u256) -> bool;
    
    /// Checks if a unique ID is invalid for a given contract address
    fn is_unique_id_invalid(self: @TContractState, contract_address: starknet::ContractAddress, unique_id: u256) -> bool;
}
