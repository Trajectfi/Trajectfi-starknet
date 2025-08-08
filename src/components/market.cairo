#[starknet::component]
pub mod MarketComponent {
    use starknet::storage::{Map};
    use starknet::ContractAddress;
    use trajectfi::types::{Listing, ListingStatus};
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
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {}
}
