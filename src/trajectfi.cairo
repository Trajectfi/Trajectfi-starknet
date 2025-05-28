#[starknet::contract]
pub mod Trajectfi {
    //use AdminComponent::super::super::logics::LogicComponent::InternalTrait;
    use openzeppelin_access::accesscontrol::AccessControlComponent;
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_security::{PausableComponent, ReentrancyGuardComponent};
    use openzeppelin_token::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use openzeppelin_upgrades::upgradeable::UpgradeableComponent;
    use starknet::ContractAddress;
    use trajectfi::components::admin::AdminComponent;
    use trajectfi::components::logics::LogicComponent;
    use trajectfi::components::signing::SigningComponent;
    use trajectfi::interfaces::itrajectfi::ITrajectfi;
    use trajectfi::types::{ADMIN_ROLE, OWNER_ROLE};

    component!(path: AccessControlComponent, storage: accesscontrol, event: AccessControlEvent);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: PausableComponent, storage: pausable, event: PausableEvent);
    component!(
        path: ReentrancyGuardComponent, storage: reentrancyguard, event: ReentrancyGuardEvent,
    );
    component!(path: UpgradeableComponent, storage: upgradable, event: UpgradableEvent);
    component!(path: AdminComponent, storage: admin_storage, event: AdminComponentEvent);

    component!(path: LogicComponent, storage: logics_storage, event: LogicComponentEvent);
    component!(path: SigningComponent, storage: signing_storage, event: SigningComponentEvent);
    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // ERC721 Mixin
    #[abi(embed_v0)]
    impl ERC721MixinImpl = ERC721Component::ERC721MixinImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl AccessControlImpl =
        AccessControlComponent::AccessControlImpl<ContractState>;
    impl AccessControlInternalImpl = AccessControlComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl PausableImpl = PausableComponent::PausableImpl<ContractState>;
    impl PausableInternalImpl = PausableComponent::InternalImpl<ContractState>;

    impl ReentrancyGuardInternalImpl = ReentrancyGuardComponent::InternalImpl<ContractState>;

    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl AdminImpl = AdminComponent::AdminImpl<ContractState>;
    impl AdminInternalImpl = AdminComponent::InternalImpl<ContractState>;

    // Implement the ITrajectfi interface

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        accesscontrol: AccessControlComponent::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        pausable: PausableComponent::Storage,
        #[substorage(v0)]
        reentrancyguard: ReentrancyGuardComponent::Storage,
        #[substorage(v0)]
        upgradable: UpgradeableComponent::Storage,
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        #[substorage(v0)]
        admin_storage: AdminComponent::Storage,
        #[substorage(v0)]
        logics_storage: LogicComponent::Storage,
        #[substorage(v0)]
        signing_storage: SigningComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        AccessControlEvent: AccessControlComponent::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        PausableEvent: PausableComponent::Event,
        #[flat]
        ReentrancyGuardEvent: ReentrancyGuardComponent::Event,
        #[flat]
        UpgradableEvent: UpgradeableComponent::Event,
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        AdminComponentEvent: AdminComponent::Event,
        #[flat]
        LogicComponentEvent: LogicComponent::Event,
        #[flat]
        SigningComponentEvent: SigningComponent::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        // Initialize Ownable component with the deployer as owner
        self.ownable.initializer(owner);

        // Initialize AccessControl
        self.accesscontrol.initializer();
        self.accesscontrol._grant_role(OWNER_ROLE, owner);
        self.accesscontrol._grant_role(ADMIN_ROLE, owner)
    }
    #[abi(embed_v0)]
    impl ITrajectfiImpl of ITrajectfi<ContractState> {
        // Pause function - only callable by owner
        fn pause(ref self: ContractState) {
            // Verify caller is owner
            self.ownable.assert_only_owner();

            // Pause the contract
            self.pausable.pause();
        }

        // Unpause function - only callable by owner
        fn unpause(ref self: ContractState) {
            // Verify caller is owner
            self.ownable.assert_only_owner();

            // Unpause the contract
            self.pausable.unpause();
        }
    }
}
