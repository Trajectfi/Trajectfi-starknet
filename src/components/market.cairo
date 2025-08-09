#[starknet::component]
pub mod MarketComponent {
    use starknet::storage::{Map};
    use starknet::ContractAddress;
    use trajectfi::types::{Listing, ListingStatus, Offer, OfferStatus};
    use trajectfi::interfaces::imarket::IMarket;

    #[storage]
    pub struct Storage {
        pub listings: Map<u256, Listing>,
        pub listing_counter: u256,
    }

    #[embeddable_as(MarketImpl)]
    impl Market<
        TContractState, +HasComponent<TContractState>,
    > of IMarket<ComponentState<TContractState>> {
        fn create_listing(
            ref self: ComponentState<TContractState>,
            nft_contract: ContractAddress,
            nft_id: u256,
            token_contract: Option<ContractAddress>,
            token_amount: Option<u256>,
            borrow_amount: Option<u256>,
            repayment_amount: Option<u256>,
            loan_duration: Option<u64>,
        ) {}
        fn close_listing(ref self: ComponentState<TContractState>, id: u256,) {}
        fn get_listing(self: @ComponentState<TContractState>, id: u256,) -> Listing {
            Listing {
                id: id,
                nft_contract: 0.try_into().unwrap(),
                nft_id: 0,
                token_contract: Option::None,
                token_amount: Option::None,
                borrow_amount: Option::None,
                repayment_amount: Option::None,
                loan_duration: Option::None,
                status: ListingStatus::OPEN,
                created_at: 0,
                updated_at: 0,
            }
        }
        fn get_listings(self: @ComponentState<TContractState>) -> Array<Listing> {
            let listings: Array<Listing> = array![];
            listings
        }
        fn get_listings_by_nft(
            self: @ComponentState<TContractState>, nft_contract: ContractAddress
        ) -> Array<Listing> {
            let listings: Array<Listing> = array![];
            listings
        }
        fn get_listings_by_token(
            self: @ComponentState<TContractState>, token_contract: ContractAddress
        ) -> Array<Listing> {
            let listings: Array<Listing> = array![];
            listings
        }
        fn make_offer(
            ref self: ComponentState<TContractState>,
            listing_id: u256,
            token_contract: ContractAddress,
            token_amount: u256,
            borrow_amount: u256,
            repayment_amount: u256,
            loan_duration: u64,
        ) {}
        fn accept_offer(
            ref self: ComponentState<TContractState>, listing_id: u256, offer_id: u256,
        ) {}
        fn close_offer(
            ref self: ComponentState<TContractState>, listing_id: u256, offer_id: u256
        ) {}
        fn get_offer(
            self: @ComponentState<TContractState>, listing_id: u256, offer_id: u256
        ) -> Offer {
            Offer {
                id: 0,
                listing_id: listing_id,
                borrower: 0.try_into().unwrap(),
                nft_contract: 0.try_into().unwrap(),
                nft_id: 0,
                token_contract: 0.try_into().unwrap(),
                token_amount: 0,
                borrow_amount: 0,
                repayment_amount: 0,
                loan_duration: 0,
                status: OfferStatus::OPEN,
                offer_expiration: 0,
                created_at: 0,
                updated_at: 0,
            }
        }
        fn get_offers(
            self: @ComponentState<TContractState>, listing_id: u256, offer_id: u256
        ) -> Array<Offer> {
            let offers: Array<Offer> = array![];
            offers
        }
        fn get_open_offers(
            self: @ComponentState<TContractState>, listing_id: u256, offer_id: u256
        ) -> Array<Offer> {
            let offers: Array<Offer> = array![];
            offers
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {}
}
