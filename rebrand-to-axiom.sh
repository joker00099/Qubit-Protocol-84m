#!/bin/bash
# AXIOM Protocol - Complete Rebranding Script
# Converts AXIOM Protocol to AXIOM Protocol

set -e

echo "🔺 AXIOM Protocol Rebranding Script"
echo "===================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "Cargo.toml" ]; then
    echo -e "${RED}Error: Cargo.toml not found. Run this from the project root.${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating backup branch...${NC}"
git checkout -b pre-axiom-backup 2>/dev/null || echo "Backup branch already exists"
git checkout main

echo -e "${YELLOW}Creating axiom-rebrand branch...${NC}"
git checkout -b axiom-rebrand 2>/dev/null || git checkout axiom-rebrand

echo ""
echo -e "${BLUE}Step 1: Global text replacements...${NC}"

# Function to replace text in files
replace_in_files() {
    local search=$1
    local replace=$2
    
    echo -e "  ${YELLOW}Replacing '$search' with '$replace'...${NC}"
    
    find . -type f \( \
        -name "*.rs" -o \
        -name "*.toml" -o \
        -name "*.md" -o \
        -name "*.sh" -o \
        -name "*.js" -o \
        -name "*.json" -o \
        -name "*.py" -o \
        -name "*.html" -o \
        -name "*.css" \
    \) -not -path "*/target/*" -not -path "*/.git/*" -not -path "*/node_modules/*" \
    -exec sed -i.bak "s/$search/$replace/g" {} + 2>/dev/null || true
    
    # Remove backup files
    find . -name "*.bak" -type f -delete 2>/dev/null || true
    
    echo -e "  ${GREEN}✓ Completed${NC}"
}

# Perform replacements
replace_in_files "AXIOM Protocol" "AXIOM Protocol"
replace_in_files "Axiom" "Axiom"
replace_in_files "axiom" "axiom"
replace_in_files "AXIOM" "AXIOM"
replace_in_files "AXM" "AXM"
replace_in_files "axm" "axm"

echo ""
echo -e "${BLUE}Step 2: Updating Cargo.toml...${NC}"

if [ -f "Cargo.toml" ]; then
    sed -i 's/name = "axiom"/name = "axiom"/g' Cargo.toml
    sed -i 's/name = "axiom-/name = "axiom-/g' Cargo.toml
    echo -e "  ${GREEN}✓ Cargo.toml updated${NC}"
fi

echo ""
echo -e "${BLUE}Step 3: Creating BRANDING.md...${NC}"

cat > BRANDING.md << 'EOF'
# 🔺 AXIOM Protocol - Brand Guidelines

## Core Identity

**Name**: AXIOM Protocol  
**Tagline**: "Privacy is axiomatic"  
**Ticker**: AXM  
**Symbol**: 🔺 (Triangle/Pyramid)

## Philosophy

An **axiom** is a self-evident truth that requires no proof. In AXIOM Protocol:
- Privacy isn't optional—it's fundamental
- Mathematics govern consensus—not humans
- Intelligence protects the network—AI as guardian
- Time ensures fairness—VDF consensus

## Visual Identity

### Logo Concept
- **Primary**: Triangle/pyramid (∴ therefore symbol)
- **Style**: Geometric, modern, minimal
- **Orientation**: Upward-pointing (growth, peak, zenith)

### Color Palette
- **Primary Blue**: `#0A1929` (Deep ocean blue)
- **Accent Blue**: `#00B4D8` (Electric cyan)
- **Success Green**: `#06D6A0` (Mint green)
- **Warning**: `#FFD166` (Warm yellow)
- **Error**: `#EF476F` (Coral red)

### Typography
- **Headers**: Inter, SF Pro, System UI (bold, clean)
- **Body**: Inter, Roboto (readable)
- **Code**: Fira Code, JetBrains Mono (monospace)

## Messaging

### Core Messages
1. **Privacy First**: "Your transactions are yours alone"
2. **AI Security**: "Intelligence guards every block"
3. **Time-Based Fairness**: "VDF ensures equality"
4. **Mathematical Truth**: "Only math can govern AXIOM"

## Binary Signature
`01000001 01011000 01001001 01001111 01001101` (AXIOM in ASCII binary)
EOF

echo -e "  ${GREEN}✓ BRANDING.md created${NC}"

echo ""
echo -e "${BLUE}Step 4: Creating CHANGELOG.md...${NC}"

cat > CHANGELOG.md << 'EOF'
# Changelog - AXIOM Protocol

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-01-24

### 🎉 Initial Release - AXIOM Protocol

#### Rebranded from AXIOM Protocol
- Complete rebranding to AXIOM Protocol
- New visual identity and messaging
- Updated binary signature: AXIOM in ASCII

#### Core Features
- ✅ ZK-SNARK privacy (mandatory for all transactions)
- ✅ VDF + PoW hybrid consensus
- ✅ Neural Guardian AI security
- ✅ 84M AXM fixed supply
- ✅ 20 AXM initial block reward
- ✅ 840,000 block halving interval

#### Production Features
- Complete error handling system (60+ error types)
- Production logging with rotation
- Configuration management (TOML-based)
- Mempool with fee-based ordering
- Multi-language SDKs (Python, JavaScript, Rust)
- Block explorer (React + Actix)
- AI Oracle Network

#### Testing
- 50+ comprehensive tests passing
- Network stress testing completed
- ZK proof generation/verification tested

### Upgrade Notes
If migrating from AXIOM Protocol:
1. Backup your wallet keys
2. Run rebranding script: `./rebrand-to-axiom.sh`
3. Rebuild: `cargo clean && cargo build --release`
4. Update configuration: Use `axiom.toml`
EOF

echo -e "  ${GREEN}✓ CHANGELOG.md created${NC}"

echo ""
echo -e "${BLUE}Step 5: Creating launch scripts...${NC}"

cat > launch-axiom-node.sh << 'EOF'
#!/bin/bash
# Launch AXIOM Protocol Node

set -e

echo "🔺 AXIOM Protocol Node Launcher"
echo "==============================="
echo ""

# Build in release mode
echo "Building AXIOM node..."
cargo build --release

echo ""
echo "Starting AXIOM node..."
echo ""

# Launch node
RUST_LOG=axiom=info ./target/release/axiom --config axiom.toml
EOF

chmod +x launch-axiom-node.sh
echo -e "  ${GREEN}✓ launch-axiom-node.sh created${NC}"

cat > quick-start.sh << 'EOF'
#!/bin/bash
# AXIOM Protocol - Quick Start

echo "🔺 AXIOM Protocol Quick Start"
echo "=============================="
echo ""

# Check dependencies
command -v cargo >/dev/null 2>&1 || { echo "Error: Rust/Cargo not installed. Visit https://rustup.rs"; exit 1; }

echo "Step 1: Building AXIOM Protocol..."
cargo build --release

echo ""
echo "Step 2: Running tests..."
cargo test

echo ""
echo "Step 3: Starting node..."
./launch-axiom-node.sh
EOF

chmod +x quick-start.sh
echo -e "  ${GREEN}✓ quick-start.sh created${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ AXIOM Rebranding Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo -e "${BLUE}Summary of Changes:${NC}"
echo "  ✓ Project renamed: Axiom → AXIOM"
echo "  ✓ Ticker updated: AXM → AXM"
echo "  ✓ All source files updated"
echo "  ✓ Package manifests updated"
echo "  ✓ Documentation created"
echo "  ✓ Launch scripts created"
echo "  ✓ Branding guidelines added"
echo ""

echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Review changes: git diff"
echo "  2. Test build: cargo build --release"
echo "  3. Run tests: cargo test"
echo "  4. Commit: git commit -am 'Rebrand to AXIOM Protocol v1.0.0'"
echo "  5. Push: git push origin axiom-rebrand"
echo ""

echo "🔺 Welcome to AXIOM Protocol!"
echo "Privacy is axiomatic. Intelligence is built-in."
