# AXIOM Protocol - Validator Deployment Guide

## Overview

AXIOM Protocol requires **5 validators minimum** for Byzantine fault tolerance (3-of-5 multisig consensus).

**Current Status**: 1/5 validators deployed ✅  
**Needed**: 4 more validators

---

## 🎯 Options for Deploying Additional Validators

### Option 1: Deploy on Same Machine (Development/Testing)

**Use Case**: Local testing, development, proof-of-concept  
**Requirements**: 20GB+ disk, 16GB+ RAM  

```bash
# Deploy validators 2-5 on different ports
VALIDATOR_NAME=axiom-validator-2 RPC_PORT=8547 P2P_PORT=8546 METRICS_PORT=9101 ./deploy-validator.sh
VALIDATOR_NAME=axiom-validator-3 RPC_PORT=8548 P2P_PORT=8547 METRICS_PORT=9102 ./deploy-validator.sh
VALIDATOR_NAME=axiom-validator-4 RPC_PORT=8549 P2P_PORT=8548 METRICS_PORT=9103 ./deploy-validator.sh
VALIDATOR_NAME=axiom-validator-5 RPC_PORT=8550 P2P_PORT=8549 METRICS_PORT=9104 ./deploy-validator.sh
```

**Pros**: ✅ Fast setup, no additional infrastructure  
**Cons**: ❌ Single point of failure, not production-ready

---

### Option 2: Deploy on Cloud Servers (Production Recommended)

**Use Case**: Mainnet production deployment  
**Requirements**: 5 separate servers across different regions/providers

#### Recommended Cloud Providers

| Provider | Region | Specs | Cost/Month |
|----------|--------|-------|------------|
| **AWS** | us-east-1 | t3.large (2 vCPU, 8GB) | ~$60 |
| **Google Cloud** | europe-west1 | n1-standard-2 | ~$50 |
| **Azure** | asia-southeast | Standard_B2s | ~$40 |
| **DigitalOcean** | nyc3 | 8GB/4vCPU | ~$48 |
| **Linode** | ap-south | 8GB/4vCPU | ~$36 |

**Total Cost**: ~$234/month for 5 global validators

#### Deployment Steps per Server:

```bash
# 1. SSH into server
ssh user@validator-server

# 2. Install dependencies
sudo apt update && sudo apt install -y build-essential git curl

# 3. Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# 4. Clone repository
git clone https://github.com/Ghost-84M/Axiom-Protocol.git
cd Axiom-Protocol

# 5. Run deployment script
./deploy-validator.sh

# 6. Install as system service
sudo cp axiom-validator.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable axiom-validator
sudo systemctl start axiom-validator

# 7. Configure firewall
sudo ./validator-firewall.sh

# 8. Verify
./check-validator.sh
```

**Pros**: ✅ Geographic diversity, high availability, production-ready  
**Cons**: ❌ Requires infrastructure management, monthly costs

---

### Option 3: Community Validators (Decentralized)

**Use Case**: True decentralization with community participation  
**Requirements**: Trusted community members or institutional partners

#### Process:

1. **Recruit Validator Operators**
   - Post in community forums/Discord
   - Reach out to blockchain infrastructure providers
   - Partner with existing node operators

2. **Validator Requirements for Operators**
   - Minimum stake: 100,000 AXM (~$X USD)
   - Server: 8GB RAM, 50GB SSD, 10 Mbps
   - Uptime commitment: 99%+
   - Technical expertise: Linux administration

3. **Validator Compensation**
   - Block rewards: Share of 50 AXM per block
   - Transaction fees: Portion of network fees
   - Estimated APY: 8-15% on staked AXM

4. **Provide Setup Package**
   ```bash
   # Share deployment script with validators
   git clone https://github.com/Ghost-84M/Axiom-Protocol.git
   cd Axiom-Protocol
   ./deploy-validator.sh
   ```

**Pros**: ✅ Decentralized, community-driven, cost-shared  
**Cons**: ❌ Requires coordination, trust, governance

---

### Option 4: Validator-as-a-Service Providers

**Use Case**: Delegated validation without infrastructure management

#### Known Providers (2025):

- **Figment Networks** - Enterprise validator services
- **Staked.us** - Institutional staking
- **Blockdaemon** - Managed nodes
- **InfStones** - Multi-chain validators

#### Setup Process:

1. Contact provider with AXIOM Protocol specs
2. Share validator deployment script
3. Configure multisig with their public keys
4. Monitor via their dashboards

**Pros**: ✅ Professional management, high uptime, enterprise SLAs  
**Cons**: ❌ Centralization risk, monthly fees, less control

---

## 🚀 Quick Start: Deploy All 5 Validators Locally

Use the automated script to deploy all validators on one machine:

```bash
./deploy-all-validators.sh
```

This will:
- Deploy 5 validators on different ports
- Configure networking between validators
- Set up monitoring for all nodes
- Create health check dashboard

---

## 🔐 Multisig Configuration

Once all 5 validators are running, configure the 3-of-5 multisig:

```bash
# Collect validator public keys
./collect-validator-keys.sh

# Generate multisig configuration
./configure-multisig.sh

# Each validator must sign to approve
./target/release/qubit multisig-sign --config multisig.json
```

---

## 📊 Monitoring All Validators

### Prometheus Configuration

```yaml
# monitoring/prometheus/all-validators.yml
scrape_configs:
  - job_name: 'axiom-validators'
    static_configs:
      - targets:
        - 'validator1.axiom.network:9100'
        - 'validator2.axiom.network:9100'
        - 'validator3.axiom.network:9100'
        - 'validator4.axiom.network:9100'
        - 'validator5.axiom.network:9100'
```

### Start Monitoring Stack

```bash
cd monitoring
docker-compose up -d
```

Access dashboards:
- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090

---

## 💰 Validator Economics

### Block Rewards Distribution

```
Block Reward: 50 AXM
├─ Validators: 45 AXM (90%)
│  └─ Each validator: 9 AXM per block (45 ÷ 5)
└─ Mobile Miners: 1 AXM (10%)

Per Validator Monthly Estimate:
- Blocks/month: ~1,460 blocks (30-min blocks)
- Revenue: 13,140 AXM/month per validator
- Annual: 157,680 AXM/year
```

### Staking Requirements

- **Minimum Stake**: 100,000 AXM per validator
- **Total Network**: 500,000 AXM (0.4% of supply)
- **Slashing Risk**: 10% for downtime, 30% for malicious behavior
- **Lock Period**: 30 days unbonding

---

## 🛡️ Security Best Practices

### Infrastructure Security

1. **Geographic Distribution**
   - Spread validators across 3+ continents
   - Use different cloud providers
   - Avoid regional concentration

2. **Network Security**
   - Firewall all non-essential ports
   - VPN for administration
   - DDoS protection (Cloudflare, AWS Shield)

3. **Key Management**
   - Hardware wallets for validator keys
   - Separate signing keys from hot wallets
   - Regular key rotation (quarterly)

4. **Monitoring & Alerts**
   - 24/7 uptime monitoring
   - Slack/PagerDuty alerts
   - Automated failover systems

### Operational Security

```bash
# Backup validator keys (CRITICAL)
./backup-validator.sh

# Encrypt backups
gpg --symmetric --cipher-algo AES256 backup.tar.gz

# Store in multiple locations
# - Hardware wallet
# - Encrypted cloud storage
# - Physical safe
```

---

## 📋 Validator Checklist

### Pre-Launch

- [ ] 5 validators deployed and synced
- [ ] Each validator has 100,000+ AXM stake
- [ ] Multisig (3-of-5) configured and tested
- [ ] Firewall rules applied on all servers
- [ ] Monitoring stack operational
- [ ] Backup systems tested
- [ ] Emergency procedures documented

### Post-Launch

- [ ] Monitor block production (99%+ uptime)
- [ ] Track peer connections (10+ peers each)
- [ ] Review logs daily for errors
- [ ] Test failover procedures monthly
- [ ] Update software on maintenance schedule
- [ ] Participate in governance votes

---

## 🆘 Troubleshooting

### Validator Not Syncing

```bash
# Check peer connections
./check-validator.sh

# View recent logs
tail -100 axiom-validator-1.log

# Verify bootstrap nodes
grep "bootstrap" axiom-validator.toml
```

### Consensus Issues

```bash
# Check all validators are online
for i in {1..5}; do
    curl -s http://validator$i.axiom.network:8546 || echo "Validator $i offline"
done

# Verify block heights match
./scripts/check-consensus.sh
```

### High Resource Usage

```bash
# Check disk usage
df -h

# Monitor RAM
free -h

# Check CPU
top -b -n 1 | head -20
```

---

## 📞 Support Resources

- **Technical Documentation**: https://docs.axiom.network
- **Validator Forum**: https://forum.axiom.network/validators
- **Emergency Contact**: validators@axiom.network
- **Discord Channel**: #validators

---

## 🎯 Next Steps

1. **Choose deployment option** (local/cloud/community/service)
2. **Provision infrastructure** (servers, domains, IPs)
3. **Run deployment scripts** on each server
4. **Configure multisig** with all validator keys
5. **Start monitoring** all validators
6. **Register validators** with network governance
7. **Begin block production** and earn rewards

---

**Ready to deploy? Run:**

```bash
# For local testing (all 5 validators)
./deploy-all-validators.sh

# For production (one at a time on separate servers)
./deploy-validator.sh
```

---

*Last Updated: January 20, 2025*  
*Network: Mainnet (ID: 1)*  
*Minimum Validators Required: 5*
