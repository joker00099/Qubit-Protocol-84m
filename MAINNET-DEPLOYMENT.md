# AXIOM Protocol - Mainnet Deployment Guide

## 🚀 Mainnet Launch Checklist

### ✅ Pre-Launch (Completed)
- [x] Core hardening complete
- [x] Tokenomics bug fixed (84M supply)
- [x] Production ZK-SNARKs implemented
- [x] VDF consensus implemented
- [x] AI Oracle network implemented
- [x] All critical tests passing

### 🔧 Phase 1: Infrastructure Setup (Week 1)

#### 1.1 ZK Trusted Setup Ceremony
```bash
# Multi-party computation for ZK proving/verification keys
cd zk-setup
./ceremony.sh --mainnet --participants 10

# Verify ceremony output
cargo run --bin trusted-setup verify ceremony_output.bin

# Distribute keys to all nodes
./distribute-keys.sh
```

**Participants Required:** Minimum 10 independent parties
**Security:** Each participant destroys their secret after contribution
**Output:** `proving_key.bin` (2GB), `verification_key.bin` (1MB)

#### 1.2 VDF Calibration
```bash
# Calibrate for 1-hour blocks on production hardware
cargo test --release -- vdf_calibration --ignored

# Expected output:
# Calibrated time_param: 3,600,000,000 for 1 hour blocks

# Update config
echo "vdf_time_param = 3600000000" >> config/mainnet.toml
```

**Hardware Spec:** 4-core CPU, 8GB RAM
**Target Block Time:** 1 hour (3600 seconds)
**Tolerance:** ±5 minutes acceptable

#### 1.3 AI Oracle Network
```bash
# Deploy 5 initial oracle nodes (geographically distributed)
# Node 1: US-East
export ANTHROPIC_API_KEY="sk-ant-..."
cargo run --bin axiom-oracle --config config/oracle-us-east.toml

# Node 2: US-West
# Node 3: EU
# Node 4: Asia
# Node 5: Australia

# Configure consensus
echo "min_oracles = 3" >> config/mainnet.toml
echo "similarity_threshold = 0.85" >> config/mainnet.toml
```

**Cost Estimate:** $500/month per oracle (Claude API usage)
**Redundancy:** 5 oracles, 3 required for consensus

### 🌐 Phase 2: Network Bootstrap (Week 2)

#### 2.1 Genesis Block Creation
```bash
# Create mainnet genesis block
cargo run --bin axiom genesis \
  --supply 8400000000000000 \
  --initial-reward 5000000000 \
  --halving-interval 840000 \
  --network-id 1 \
  --timestamp 1737590400  # January 23, 2026 00:00 UTC

# Output: genesis.json
```

**Genesis Validators:**
- Validator 1: Foundation (33% stake)
- Validator 2: Community (33% stake)
- Validator 3: Development (34% stake)

#### 2.2 Seed Node Deployment
```bash
# Deploy 3 geographically distributed seed nodes
# Seed 1: US-East (Virginia)
cargo run --bin axiom \
  --config config/mainnet.toml \
  --seed-node \
  --listen /ip4/0.0.0.0/tcp/30333

# Seed 2: EU (Frankfurt)
# Seed 3: Asia (Singapore)

# Add to DNS
seed1.axiom.network -> 1.2.3.4
seed2.axiom.network -> 5.6.7.8
seed3.axiom.network -> 9.10.11.12
```

**Infrastructure:**
- Provider: AWS/GCP/Hetzner
- Instance: 8 vCPU, 32GB RAM, 1TB SSD
- Bandwidth: 1Gbps unmetered
- Cost: ~$200/month per node

#### 2.3 Network Launch
```bash
# Start genesis validators simultaneously
# T-minus 60 seconds to genesis timestamp

# Validator 1
cargo run --release --bin axiom \
  --config config/mainnet.toml \
  --validator \
  --keys validator1.key

# Validator 2
# Validator 3

# Monitor sync
tail -f logs/axiom.log | grep "Block produced"
```

**Launch Coordination:**
- All validators must start within 60 seconds
- Genesis block at exact timestamp
- First VDF proof should complete in ~1 hour

### 🔐 Phase 3: Security Audit (Parallel)

#### 3.1 Smart Contract Audit
```bash
# Audit ZK circuits
slither src/zk/transaction_circuit.rs
mythril -x src/zk/

# Audit VDF implementation
echidna-test src/consensus/vdf.rs

# Audit AI Oracle
oyente src/ai/oracle.rs
```

**Audit Firms:** Trail of Bits, Quantstamp, OpenZeppelin
**Timeline:** 2-4 weeks
**Budget:** $50,000 - $100,000

#### 3.2 Penetration Testing
```bash
# Network-level attacks
# - DDoS resistance
# - Eclipse attacks
# - Sybil attacks

# Consensus attacks
# - Long-range attacks
# - VDF grinding
# - Oracle manipulation
```

**Red Team:** Hired security researchers
**Bounty Program:** $10,000 for critical vulnerabilities

### 📊 Phase 4: Monitoring & Metrics (Day 1+)

#### 4.1 Observability Stack
```bash
# Prometheus + Grafana
docker-compose up -d monitoring

# Metrics exposed at :9615
# - Block height
# - VDF computation time
# - ZK proof verification rate
# - Oracle consensus success rate
# - Network peer count
# - Transaction throughput
```

**Dashboards:**
- Network health
- Consensus metrics
- Oracle performance
- Economic metrics (supply, staking, rewards)

#### 4.2 Alerting
```yaml
# alerts.yaml
- alert: VDFComputationSlow
  expr: vdf_computation_seconds > 4000
  for: 5m
  annotations:
    summary: "VDF taking >1h 6m (target 1h)"

- alert: OracleConsensusFailure
  expr: oracle_consensus_failures > 3
  for: 10m
  annotations:
    summary: "Oracle network not reaching consensus"

- alert: ChainNotProgressing
  expr: rate(block_height[5m]) == 0
  annotations:
    summary: "No blocks produced in 5 minutes"
```

### 🎯 Launch Day Timeline

**T-minus 24 hours:**
- Final security review
- All validators ready
- Seed nodes deployed
- Monitoring active

**T-minus 1 hour:**
- Final validator check-in
- Genesis block verified
- Network IDs confirmed

**T-minus 15 minutes:**
- All services started
- Validators in sync mode
- Countdown announced

**T = 0 (Genesis):**
- Genesis block timestamp reached
- First VDF computation begins
- Network is LIVE! 🚀

**T + 1 hour:**
- First block produced
- VDF verification successful
- Network progressing normally

**T + 24 hours:**
- 24 blocks produced (1 per hour)
- All oracles operational
- Transaction throughput measured
- Exchange listings begin

### 💰 Token Distribution

```
Total Supply: 84,000,000 AXM

Distribution:
- 50% Mining rewards (42M AXM) - Released over ~100 years via halvings
- 20% Foundation (16.8M AXM) - 4-year vesting
- 15% Development (12.6M AXM) - 2-year vesting
- 10% Community (8.4M AXM) - Airdrops, grants
- 5% Advisors (4.2M AXM) - 2-year vesting
```

**Initial Circulating Supply:** ~8.4M AXM (10% community allocation)
**Fully Diluted Valuation:** Based on initial price discovery

### 📈 Post-Launch Milestones

**Week 1:**
- [ ] 168 blocks produced (24/7 operation)
- [ ] Zero critical bugs
- [ ] All validators online
- [ ] Oracle consensus 99%+ success rate

**Month 1:**
- [ ] 720 blocks produced (~30 days)
- [ ] First halving approaching (840K blocks = ~100 years)
- [ ] 1000+ TPS throughput achieved
- [ ] 10+ exchange listings
- [ ] Block Explorer live
- [ ] Mobile Wallet released

**Month 3:**
- [ ] 2,160 blocks produced
- [ ] DEX integration complete
- [ ] 10,000+ active addresses
- [ ] $100M+ market cap
- [ ] Major partnership announcements

### 🛡️ Security Measures

#### Network Security
- DDoS protection via Cloudflare
- Rate limiting on RPC endpoints
- Validator KYC (optional for public validators)
- Multi-signature treasury

#### Smart Contract Security
- ZK circuit formal verification
- VDF implementation audited
- Oracle slashing for malicious behavior
- Emergency pause mechanism

#### Operational Security
- Validator key management (HSM recommended)
- Oracle API key rotation (monthly)
- Encrypted backups (AES-256)
- 24/7 monitoring and incident response

### 📞 Emergency Contacts

**Critical Bug Found:**
1. Contact development team immediately
2. Activate emergency pause if necessary
3. Notify validators and community
4. Deploy hotfix within 4 hours

**Network Degradation:**
1. Check monitoring dashboards
2. Verify validator connectivity
3. Restart affected services
4. Escalate if not resolved in 1 hour

**Oracle Failure:**
1. Check Claude API status
2. Rotate API keys if compromised
3. Deploy backup oracle nodes
4. Investigate consensus failures

### ✅ Pre-Launch Verification

```bash
# Run full test suite
cargo test --all --release

# Expected results:
# - 11/11 economics tests passing
# - 2/2 ZK-SNARK tests passing
# - 3/3 VDF tests passing
# - 3/3 Oracle tests passing

# Verify mainnet config
cargo run --bin axiom config verify config/mainnet.toml

# Expected output:
# ✓ Network ID: 1 (mainnet)
# ✓ Genesis timestamp: valid
# ✓ ZK keys: present and valid
# ✓ VDF calibrated: 3.6B iterations
# ✓ Oracles: 5 configured
# ✓ All checks passed
```

### 🚀 Launch Command

```bash
# The moment of truth! 🎉

# Start mainnet node
cargo run --release --bin axiom \
  --config config/mainnet.toml \
  --genesis genesis.json \
  --validator \
  --keys validator.key \
  --name "AXIOM Genesis Validator" \
  --chain mainnet

# Watch the magic happen
tail -f logs/axiom.log
```

### 🎉 Post-Launch Announcements

**Social Media:**
- Twitter: "@AXIOMProtocol MAINNET IS LIVE! 🚀"
- Discord: Mainnet launch party
- Telegram: Community celebration

**Press Release:**
- "AXIOM Protocol Launches Revolutionary 84M Supply Blockchain"
- "First Blockchain with ZK-SNARKs + VDF + AI Oracle"
- "Production-Ready Privacy and Consensus"

**Community:**
- AMA session with founders
- Technical deep-dive blog posts
- Video tutorials for wallet setup
- Trading competition on DEX

---

## 🌟 Mainnet Launch = AXIOM Goes Live!

No testnet. No delays. Production from Day 1.

**Launch Date:** To be announced  
**Network ID:** 1 (mainnet)  
**Chain ID:** AXIOM-1  
**Genesis Validators:** 3 (expandable)  
**Target TPS:** 1,000+  
**Block Time:** 1 hour (VDF-secured)

**Status:** READY FOR MAINNET DEPLOYMENT ✅
