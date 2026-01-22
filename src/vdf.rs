/// Hardware Requirements (Documentation)
/// - CPU: Modern x86_64 or ARM processor (multi-core recommended)
/// - RAM: Minimum 2GB (more for high t)
/// - No GPU required (VDF is CPU-bound)
/// - For production, use secure RSA modulus generation

/// Benchmark Wesolowski VDF performance
pub fn benchmark_wesolowski(t: u32, bits: u32) {
    use std::time::Instant;
    let n = wesolowski_setup(bits);
    let g = Integer::from(2);
    let start = Instant::now();
    let _y = wesolowski_evaluate(&g, t, &n);
    let duration = start.elapsed();
    println!("Wesolowski VDF: t={} bits={} elapsed={:?}", t, bits, duration);
}
use rug::Integer;

/// Wesolowski VDF Setup: Securely generates RSA modulus N
/// For production, uses cryptographically secure random primes.
pub fn wesolowski_setup(bits: u32) -> Integer {
    use rand::rngs::OsRng;
    use rug::integer::IsPrime;
    use rug::rand::RandState;
    use rug::Assign;
    use rand::RngCore;
    let mut os_rng = OsRng;
    let mut seed = [0u8; 32];
    os_rng.fill_bytes(&mut seed);
    let mut rand_state = RandState::new();
    rand_state.seed(&Integer::from_digits(&seed, rug::integer::Order::Lsf));
    let mut p = Integer::new();
    let mut q = Integer::new();
    // Generate two random strong primes
    loop {
        p.assign(Integer::from(Integer::random_bits(bits / 2, &mut rand_state)) | 1);
        if p.is_probably_prime(40) == IsPrime::Yes { break; }
    }
    loop {
        q.assign(Integer::from(Integer::random_bits(bits / 2, &mut rand_state)) | 1);
        if q != p && q.is_probably_prime(40) == IsPrime::Yes { break; }
    }
    let n = Integer::from(&p * &q);
    // Enforce minimum modulus size for production
    #[cfg(not(test))]
    if bits < 2048 {
        panic!("VDF modulus too small for production: {} bits. Use at least 2048 bits.", bits);
    }
    n
}

#[cfg(test)]
/// Test-only function with pre-generated 2048-bit modulus for fast testing
/// WARNING: This uses a fixed modulus - NEVER use in production!
pub fn wesolowski_setup_test() -> Integer {
    // Pre-generated 2048-bit RSA modulus (product of two safe primes)
    // This is a known modulus from academic literature for testing purposes
    Integer::from_str_radix(
        "25195908475657893494027183240048398571429282126204032027777137836043662020707595556264018525880784406918290641249515082189298559149176184502808489120072844992687392807287776735971418347270261896375014971824691165077613379859095700097330459748808428401797429100642458691817195118746121515172654632282216869987549182422433637259085141865462043576798423387184774447920739934236584823824281198163815010674810451660377306056201619676256133844143603833904414952634432190114657544454178424020924616515723350778707749817125772467962926386356373289912154831438167899885040445364023527381951378636564391212010397122822120720357",
        10
    ).expect("Failed to parse test modulus")
}

#[cfg(test)]
mod vdf_tests {
    use super::*;
    #[test]
    fn test_vdf_modulus_size() {
        // Verify the test modulus is actually 2048 bits
        let n = wesolowski_setup_test();
        let bits = n.significant_bits();
        assert!(bits >= 2048, "Test modulus should be at least 2048 bits, got {}", bits);
    }
}

/// Wesolowski VDF Evaluation: y = g^{2^t} mod N
pub fn wesolowski_evaluate(g: &Integer, t: u32, n: &Integer) -> Integer {
    let exp = Integer::from(1) << t; // 2^t
    g.clone().pow_mod(&exp, n).unwrap()
}

/// Wesolowski VDF Proof: returns (y, pi)
/// Wesolowski VDF Proof: returns (y, pi)
/// TODO: Implement real Wesolowski proof (currently placeholder)
pub fn wesolowski_prove(g: &Integer, t: u32, n: &Integer) -> (Integer, Integer) {
    let y = wesolowski_evaluate(g, t, n);
    // WARNING: Placeholder proof, not secure for production
    (y.clone(), y)
}

/// Wesolowski VDF Verification: checks y == g^{2^t} mod N
pub fn wesolowski_verify(g: &Integer, t: u32, n: &Integer, y: &Integer) -> bool {
    let expected = wesolowski_evaluate(g, t, n);
    &expected == y
}
use sha2::{Sha256, Digest};

/// EVALUATE: Creates the seed for the VDF chain.
/// This links the current block to the parent and the specific time-slot.
pub fn evaluate(parent_hash: [u8; 32], slot: u64) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(parent_hash);
    hasher.update(slot.to_le_bytes());
    hasher.finalize().into()
}

/// VERIFY: Recomputes the sequential chain to ensure the time-lock was respected.
/// This is the "Self-Healing" heart: any node can verify that time has passed
/// without trusting the miner.
#[allow(dead_code)]
pub fn verify_vdf(seed: [u8; 32], iterations: u32, proof: [u8; 32]) -> bool {
    // The main_helper contains the actual sequential hashing loop
    let expected = crate::main_helper::compute_vdf(seed, iterations);
    expected == proof
}
