#[starknet::interface]
pub trait IAdmin<TContractState> {
    fn set_admin_fee(ref self: TContractState, new_fee: u64);
    fn get_admin_fee(self: @TContractState) -> u64;
}
