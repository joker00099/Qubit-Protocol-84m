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
