// Advanced Integration Tests
use qubit_core::block::Block;
use qubit_core::state::State;
use qubit_core::transaction::Transaction;
use qubit_core::vdf;
use rug::Integer;

#[test]
fn test_fork_detection() {
    let genesis_hash = [0u8; 32];
    
    let block_a = Block::new(genesis_hash, 1, [1u8; 32], vec![], [10u8; 32], vec![1u8; 64], 100);
    let block_b = Block::new(genesis_hash, 1, [2u8; 32], vec![], [20u8; 32], vec![2u8; 64], 200);
    
    assert_eq!(block_a.parent, block_b.parent);
    assert_ne!(block_a.hash(), block_b.hash());
    assert_eq!(block_a.slot, block_b.slot);
}

#[test]
fn test_simple_reorg() {
    let mut state = State::new();
    let from = [1u8; 32];
    let to = [2u8; 32];
    
    state.credit(from, 1000);
    let initial_balance = state.balance(&from);
    
    let tx = Transaction::new(from, to, 100, 10, 0, vec![1u8; 128], vec![1u8; 64]);
    
    assert!(state.apply_tx(&tx).is_ok());
    assert_eq!(state.balance(&from), initial_balance - 110);
    assert_eq!(state.balance(&to), 100);
    
    state.credit(from, 110);
    assert!(state.debit(to, 100).is_ok());
    
    assert_eq!(state.balance(&from), initial_balance);
    assert_eq!(state.balance(&to), 0);
}

#[test]
fn test_double_spend_prevention() {
    let mut state = State::new();
    let from = [1u8; 32];
    let to1 = [2u8; 32];
    let to2 = [3u8; 32];
    
    state.credit(from, 150);
    
    let tx1 = Transaction::new(from, to1, 100, 10, 0, vec![1u8; 128], vec![1u8; 64]);
    let tx2 = Transaction::new(from, to2, 100, 10, 0, vec![2u8; 128], vec![2u8; 64]);
    
    assert!(state.apply_tx(&tx1).is_ok());
    assert_eq!(state.balance(&from), 40);
    assert_eq!(state.balance(&to1), 100);
    
    assert!(state.apply_tx(&tx2).is_err());
    assert_eq!(state.balance(&to2), 0);
}

#[test]
fn test_many_transactions() {
    let mut state = State::new();
    let num_txs = 100;
    
    let addresses: Vec<[u8; 32]> = (0..num_txs).map(|i| {
        let mut addr = [0u8; 32];
        addr[0] = (i % 256) as u8;
        addr[1] = (i / 256) as u8;
        addr
    }).collect();
    
    // Fund all addresses except the last one
    for i in 0..num_txs - 1 {
        state.credit(addresses[i], 110);
    }
    
    let start = std::time::Instant::now();
    
    for i in 0..num_txs - 1 {
        let nonce = state.nonce(&addresses[i]);
        let tx = Transaction::new(
            addresses[i],
            addresses[i + 1],
            100,
            10,
            nonce,
            vec![1u8; 128],
            vec![1u8; 64],
        );
        
        assert!(state.apply_tx(&tx).is_ok());
    }
    
    let duration = start.elapsed();
    println!("Processed {} transactions in {:?}", num_txs - 1, duration);
    println!("Throughput: {:.2} tx/sec", (num_txs - 1) as f64 / duration.as_secs_f64());
    
    assert_eq!(state.balance(&addresses[num_txs - 1]), 100);
}

#[test]
fn test_vdf_determinism() {
    let n = vdf::wesolowski_setup(2048);
    let g = Integer::from(2);
    let t = 10u32;
    
    let (y1, _) = vdf::wesolowski_prove(&g, t, &n);
    let (y2, _) = vdf::wesolowski_prove(&g, t, &n);
    
    assert_eq!(y1, y2);
}

#[test]
fn test_zero_balance_transaction() {
    let mut state = State::new();
    let from = [1u8; 32];
    let to = [2u8; 32];
    
    assert_eq!(state.balance(&from), 0);
    
    let tx = Transaction::new(from, to, 100, 10, 0, vec![1u8; 128], vec![1u8; 64]);
    
    assert!(state.apply_tx(&tx).is_err());
}

#[test]
fn test_exact_balance_transaction() {
    let mut state = State::new();
    let from = [1u8; 32];
    let to = [2u8; 32];
    
    state.credit(from, 110);
    
    let tx = Transaction::new(from, to, 100, 10, 0, vec![1u8; 128], vec![1u8; 64]);
    
    assert!(state.apply_tx(&tx).is_ok());
    assert_eq!(state.balance(&from), 0);
    assert_eq!(state.balance(&to), 100);
}

#[test]
fn test_mining_reward_decreases() {
    let reward0 = Block::mining_reward(0);
    let reward1 = Block::mining_reward(840_000);
    let reward2 = Block::mining_reward(1_680_000);
    
    assert_eq!(reward0, 50_000_000);
    assert_eq!(reward1, 25_000_000);
    assert_eq!(reward2, 12_500_000);
    
    assert!(reward0 > reward1);
    assert!(reward1 > reward2);
}
