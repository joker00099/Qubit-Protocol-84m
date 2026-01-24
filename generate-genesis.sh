#!/bin/bash
# AXIOM Protocol - Genesis Block Generator
# Creates the genesis block for mainnet launch

set -e

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║            AXIOM Protocol - Genesis Block Creation                   ║"
echo "║                      Mainnet Launch                                   ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Genesis parameters
CHAIN_ID=84000
NETWORK_ID=1
GENESIS_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
INITIAL_SUPPLY=0  # No pre-mine
TOTAL_SUPPLY=124000000  # 124M AXM cap

echo -e "${YELLOW}Genesis Block Configuration:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Chain ID: $CHAIN_ID"
echo "Network ID: $NETWORK_ID"
echo "Genesis Time: $GENESIS_TIME"
echo "Initial Supply: $INITIAL_SUPPLY AXM (no pre-mine)"
echo "Total Supply Cap: $TOTAL_SUPPLY AXM"
echo ""

# Collect validator addresses
echo -e "${YELLOW}Enter validator addresses (one per line, press Enter twice when done):${NC}"
VALIDATOR_ADDRESSES=()
while true; do
    read -p "Validator address (or press Enter to finish): " addr
    if [ -z "$addr" ]; then
        break
    fi
    VALIDATOR_ADDRESSES+=("$addr")
    echo -e "${GREEN}✓ Added validator: $addr${NC}"
done

if [ ${#VALIDATOR_ADDRESSES[@]} -lt 5 ]; then
    echo -e "${RED}✗ Need at least 5 validators for Byzantine consensus${NC}"
    echo "You have: ${#VALIDATOR_ADDRESSES[@]}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Collected ${#VALIDATOR_ADDRESSES[@]} validator addresses${NC}"
echo ""

# Generate genesis block
echo -e "${YELLOW}Generating genesis block...${NC}"

cat > genesis.json << EOF
{
  "config": {
    "chainId": $CHAIN_ID,
    "networkId": $NETWORK_ID,
    "consensus": "hybrid-pow-vdf-byzantine",
    "byzantineThreshold": {
      "total": ${#VALIDATOR_ADDRESSES[@]},
      "required": 3,
      "type": "3-of-5-multisig"
    },
    "vdf": {
      "steps": 3600000,
      "timeProof": "1-hour",
      "enforceStrictTiming": true
    },
    "pow": {
      "algorithm": "SHA256d",
      "initialDifficulty": 1000,
      "adjustmentInterval": 2016,
      "targetBlockTime": 3600
    },
    "economics": {
      "totalSupply": "$TOTAL_SUPPLY",
      "supplyUnit": "AXM",
      "decimals": 8,
      "initialBlockReward": "50.00000000",
      "mobileReward": "1.00000000",
      "halvingInterval": 2100000,
      "minTransactionFee": "0.00000100"
    }
  },
  "timestamp": "$GENESIS_TIME",
  "nonce": "0x0000000000000000",
  "difficulty": "0x3E8",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "number": "0x0",
  "gasLimit": "0xF4240",
  "alloc": {
    "genesis": {
      "balance": "0",
      "code": "",
      "storage": {}
    }
  },
  "validators": [
EOF

# Add validators
for i in "${!VALIDATOR_ADDRESSES[@]}"; do
    addr="${VALIDATOR_ADDRESSES[$i]}"
    if [ $i -eq $((${#VALIDATOR_ADDRESSES[@]} - 1)) ]; then
        # Last validator (no comma)
        cat >> genesis.json << EOF
    {
      "address": "$addr",
      "stake": "100000.00000000",
      "power": 1,
      "index": $i
    }
EOF
    else
        cat >> genesis.json << EOF
    {
      "address": "$addr",
      "stake": "100000.00000000",
      "power": 1,
      "index": $i
    },
EOF
    fi
done

cat >> genesis.json << 'EOF'
  ],
  "bootstrap": {
    "nodes": [],
    "initialPeers": 5,
    "discoveryEnabled": true
  },
  "features": {
    "privacy": {
      "zkSnarksEnabled": true,
      "mandatoryPrivacy": true,
      "viewKeysEnabled": true
    },
    "sustainability": {
      "energyTracking": true,
      "carbonReporting": true,
      "targetEnergyPerTx": "10J"
    },
    "mobile": {
      "enabled": true,
      "minIntensity": 1,
      "maxIntensity": 100,
      "rewardPerBlock": "1.00000000"
    }
  }
}
EOF

echo -e "${GREEN}✓ Genesis block created: genesis.json${NC}"
echo ""

# Calculate genesis hash
GENESIS_HASH=$(sha256sum genesis.json | awk '{print $1}')
echo -e "${YELLOW}Genesis Hash:${NC}"
echo "$GENESIS_HASH"
echo ""

# Create chainspec file
cat > chainspec.toml << EOF
# AXIOM Protocol Chain Specification
# Generated: $GENESIS_TIME

[chain]
name = "AXIOM"
chain_id = $CHAIN_ID
network_id = $NETWORK_ID
genesis_hash = "$GENESIS_HASH"
genesis_time = "$GENESIS_TIME"

[consensus]
type = "hybrid"
pow_enabled = true
vdf_enabled = true
byzantine_enabled = true
validator_count = ${#VALIDATOR_ADDRESSES[@]}
quorum = 3

[supply]
total = $TOTAL_SUPPLY
unit = "AXM"
decimals = 8
initial_circulation = $INITIAL_SUPPLY

[rewards]
block_reward = "50.00000000"
mobile_reward = "1.00000000"
halving_blocks = 2100000
EOF

for i in "${!VALIDATOR_ADDRESSES[@]}"; do
    echo "validator_$i = \"${VALIDATOR_ADDRESSES[$i]}\"" >> chainspec.toml
done

echo -e "${GREEN}✓ Chain specification created: chainspec.toml${NC}"
echo ""

# Create validator initialization script
cat > initialize-validators.sh << 'EOF'
#!/bin/bash
# Initialize validators with genesis block

set -e

if [ ! -f "genesis.json" ]; then
    echo "✗ genesis.json not found"
    exit 1
fi

echo "Initializing validators with genesis block..."

# Copy genesis to each validator
for i in {1..5}; do
    if [ -d "validator-$i" ]; then
        cp genesis.json "validator-$i/"
        cp chainspec.toml "validator-$i/"
        echo "✓ Initialized validator-$i"
    fi
done

echo ""
echo "✓ All validators initialized"
echo ""
echo "Next step: Start validators with:"
echo "  ./control-validators.sh start"
EOF

chmod +x initialize-validators.sh

echo -e "${GREEN}✓ Validator initialization script created${NC}"
echo ""

# Create network launch checklist
cat > launch-checklist.md << EOF
# AXIOM Mainnet Launch Checklist

## Genesis Block Created ✅

- **Genesis Time**: $GENESIS_TIME
- **Genesis Hash**: $GENESIS_HASH
- **Chain ID**: $CHAIN_ID
- **Validators**: ${#VALIDATOR_ADDRESSES[@]}

---

## Pre-Launch Steps

- [ ] All validators have genesis.json
- [ ] All validators synced to same genesis
- [ ] Bootstrap nodes configured
- [ ] Network connectivity verified
- [ ] Monitoring stack deployed
- [ ] Block explorer ready
- [ ] RPC endpoints configured
- [ ] Security audit completed

## Launch Sequence

1. **T-24h**: Final validator check
   \`\`\`bash
   ./check-validator.sh
   \`\`\`

2. **T-4h**: Initialize all validators
   \`\`\`bash
   ./initialize-validators.sh
   \`\`\`

3. **T-1h**: Start monitoring
   \`\`\`bash
   cd monitoring && docker-compose up -d
   \`\`\`

4. **T-30min**: Validator coordination call

5. **T-15min**: Pre-launch checks
   - All validators online
   - Peer connections established
   - Clock synchronization verified

6. **T-0**: Launch validators
   \`\`\`bash
   ./control-validators.sh start
   \`\`\`

7. **T+5min**: Verify first block produced

8. **T+1h**: Public announcement

---

## Post-Launch Monitoring

- Block production rate: 1 block per 30 minutes
- Validator participation: 5/5 active
- Network hash rate: Growing
- Transaction throughput: As expected
- Energy consumption: ~10 J/tx

---

## Emergency Contacts

- Technical Lead: validators@axiom.network
- Infrastructure: ops@axiom.network
- Security: security@axiom.network

---

**Genesis Hash**: $GENESIS_HASH
**Launch Time**: $GENESIS_TIME
EOF

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ GENESIS BLOCK READY                             ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Files Created:${NC}"
echo "  ✓ genesis.json        - Genesis block definition"
echo "  ✓ chainspec.toml      - Chain specification"
echo "  ✓ initialize-validators.sh - Validator init script"
echo "  ✓ launch-checklist.md - Launch procedures"
echo ""
echo -e "${YELLOW}Genesis Hash:${NC} $GENESIS_HASH"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Distribute genesis.json to all ${#VALIDATOR_ADDRESSES[@]} validators"
echo "  2. Run: ./initialize-validators.sh"
echo "  3. Coordinate launch time with all validators"
echo "  4. Launch: ./control-validators.sh start"
echo ""
echo -e "${GREEN}✨ Ready for mainnet launch!${NC}"
echo ""
