#[starknet::component]
pub mod AdminComponent {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use openzeppelin::access::accesscontrol::interface::IAccessControl;
    use trajectfi::interfaces::iadmin::IAdmin;
    use trajectfi::types::{OWNER_ROLE, ADMIN_ROLE};
    use trajectfi::errors::Errors::{MISSING_ROLE};

    /// Maximum admin fee (in basis points), where 1000 bps equals 10%
    const MAX_ADMIN_FEE: u64 = 1000;

    #[storage]
    pub struct Storage {
        admin_fee: u64,
        accepted_nft_status: Map<ContractAddress, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        AdminFeeUpdated: AdminFeeUpdated,
        NFTWhitelisted: NFTWhitelisted,
    }

    #[derive(Drop, starknet::Event)]
    pub struct AdminFeeUpdated {
        #[key]
        pub caller: ContractAddress,
        pub new_fee: u64,
    }

    #[derive(Drop, starknet::Event)]
    pub struct NFTWhitelisted {
        #[key]
        pub token: ContractAddress,
        pub status: bool,
    }

    #[embeddable_as(AdminImpl)]
    impl Admin<
        TContractState, +HasComponent<TContractState>, +IAccessControl<TContractState>
    > of IAdmin<ComponentState<TContractState>> {
        fn set_admin_fee(ref self: ComponentState<TContractState>, new_fee: u64) {
            let caller = get_caller_address();

            // Ensure the caller has the admin or owner role
            let is_caller_authorized = self.get_contract().has_role(ADMIN_ROLE, caller)
                || self.get_contract().has_role(OWNER_ROLE, caller);
            assert(is_caller_authorized, MISSING_ROLE);

            assert(new_fee <= MAX_ADMIN_FEE, 'Error: New fee exceeds limit');

            self.admin_fee.write(new_fee);
            self.emit(AdminFeeUpdated { caller, new_fee });
        }

        fn get_admin_fee(self: @ComponentState<TContractState>) -> u64 {
            self.admin_fee.read()
        }

        fn whitelist_nft(
            ref self: ComponentState<TContractState>, nft: ContractAddress, status: bool
        ) {
            let caller = get_caller_address();

            // Ensure the caller has the admin or owner role
            let is_caller_authorized = self.get_contract().has_role(ADMIN_ROLE, caller)
                || self.get_contract().has_role(OWNER_ROLE, caller);
            assert(is_caller_authorized, MISSING_ROLE);

            // Update whitelist status for the NFT collection (true to add, false to remove)
            self.accepted_nft_status.entry(nft).write(status);
            self.emit(NFTWhitelisted { token: nft, status });
        }

        fn is_nft_whitelisted(
            self: @ComponentState<TContractState>, token: ContractAddress
        ) -> bool {
            self.accepted_nft_status.entry(token).read()
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {}
}
