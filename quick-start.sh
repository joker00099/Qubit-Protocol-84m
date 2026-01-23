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
