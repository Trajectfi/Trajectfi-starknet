#[starknet::interface]
pub trait ITrajectfi<TContractState> {
    /// Pauses the contract (only callable by owner)
    fn pause(ref self: TContractState);

    /// Unpauses the contract (only callable by owner)
    fn unpause(ref self: TContractState);
}
