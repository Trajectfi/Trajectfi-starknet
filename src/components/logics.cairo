use core::integer::u256;

#[starknet::component]
pub mod LogicComponent {
    #[storage]
    pub struct Storage {}

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {}
}

/// Computes the admin fee from interest using basis points (bps).
/// admin_fee = (interest * admin_fee_bps) / 10_000
/// Handles zero values and uses safe u256 math.
pub fn compute_admin_fee(interest: u256, admin_fee_bps: u256) -> u256 {
    if interest == 0_u256 || admin_fee_bps == 0_u256 {
        return 0_u256;
    }
    let product = interest * admin_fee_bps;
    let fee = product / 10_000_u256;
    fee
}
