use starknet::ContractAddress;

#[starknet::interface]
pub trait IAdmin<TContractState> {
    fn set_admin_fee(ref self: TContractState, new_fee: u64);
    fn get_admin_fee(self: @TContractState) -> u64;
    fn whitelist_nft(ref self: TContractState, nft: ContractAddress, status: bool);
    fn is_nft_whitelisted(self: @TContractState, token: ContractAddress) -> bool;
}
