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
pub fn compute_admin_fee(interest: U256, admin_fee_bps: U256) -> U256 {
    if interest == u256_zero() || admin_fee_bps == u256_zero() {
        return u256_zero();
    }
    let (product, _) = u256_mul(interest, admin_fee_bps);
    let (fee, _) = u256_div(product, U256::from_u32(10_000));
    fee
}
