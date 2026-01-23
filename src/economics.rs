/// ECONOMICS — CONSENSUS MONETARY POLICY
/// Fixed total supply (forever)

pub const MAX_SUPPLY: u64 = 84_000_000_000_000_000; // 84M AXM, 8 decimals

/// Initial block reward (50 AXM, 8 decimals)
pub const INITIAL_REWARD: u64 = 5_000_000_000;

/// Blocks per halving (Litecoin-like: 840,000 blocks)
/// Math: 50 AXM × 840,000 blocks × 2 (geometric series) = 84,000,000 AXM ✓
pub const HALVING_INTERVAL: u64 = 840_000;

/// Calculate block reward based on height
pub fn block_reward(block_height: u64, already_issued: u64) -> u64 {
    let halvings = block_height / HALVING_INTERVAL;

    let reward = INITIAL_REWARD >> halvings;

    if reward == 0 {
        return 0;
    }

    if already_issued + reward > MAX_SUPPLY {
        MAX_SUPPLY - already_issued
    } else {
        reward
    }
}
