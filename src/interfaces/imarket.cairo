use starknet::ContractAddress;
use trajectfi::types::{Listing, Offer};

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
    );
    fn close_listing(ref self: TContractState, id: u256);
    fn get_listing(self: @TContractState, id: u256) -> Listing;
    fn get_listings(self: @TContractState) -> Array<Listing>;
    fn get_listings_by_nft(self: @TContractState, nft_contract: ContractAddress) -> Array<Listing>;
    fn get_listings_by_token(
        self: @TContractState, token_contract: ContractAddress
    ) -> Array<Listing>;
    fn make_offer(
        ref self: TContractState,
        listing_id: u256,
        token_contract: ContractAddress,
        token_amount: u256,
        borrow_amount: u256,
        repayment_amount: u256,
        loan_duration: u64
    );
    fn accept_offer(ref self: TContractState, listing_id: u256, offer_id: u256);
    fn close_offer(ref self: TContractState, listing_id: u256, offer_id: u256);
    fn get_offer(self: @TContractState, listing_id: u256, offer_id: u256) -> Offer;
    fn get_offers(self: @TContractState, listing_id: u256, offer_id: u256) -> Array<Offer>;
    fn get_open_offers(self: @TContractState, listing_id: u256, offer_id: u256) -> Array<Offer>;
}
