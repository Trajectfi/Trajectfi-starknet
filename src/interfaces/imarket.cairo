use starknet::ContractAddress;
use trajectfi::types::Listing;

#[starknet::interface]
pub trait IMarket<TContractState> {
    fn create_listing(
        ref self: TContractState,
        nft_contract: ContractAddress,
        nft_id: u256,
        token_contract: Option<ContractAddress>,
        token_amount: Option<u256>,
        borrow_amount: Option<u256>,
        repayment_amount: Option<u256>,
        loan_duration: Option<u64>,
    ) -> u256;
    fn close_listing(ref self: TContractState, id: u256) -> u256;
    fn get_listing(self: @TContractState, id: u256) -> Listing;
    fn get_listings(self: @TContractState) -> Array<Listing>;
    fn get_listings_by_nft(self: @TContractState, nft_contract: ContractAddress) -> Array<Listing>;
    fn get_listings_by_token(self: @TContractState, token_contract: ContractAddress) -> Array<Listing>;
}