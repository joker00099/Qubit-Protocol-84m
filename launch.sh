#!/bin/bash

# Axiom Core - Decentralized 84M Launch Script
echo "--------------------------------------------------"
echo "🚀 INITIALIZING AXIOM CORE..."
echo "--------------------------------------------------"

# 1. Clean previous build artifacts
cargo clean

# 2. Build the optimized binary
echo "🛠️  Compiling release binary..."
cargo build --release

if [ $? -eq 0 ]; then
    echo "✅ Build Successful."
    echo "--------------------------------------------------"
    echo "🏛️  STARTING DECENTRALIZED NODE..."
    echo "--------------------------------------------------"
    
    # 3. Execute the binary
    # Prefer `axiom-core` binary but fall back to `axiom` if present
    if [ -x ./target/release/axiom-core ]; then
        exec ./target/release/axiom-core
    elif [ -x ./target/release/axiom ]; then
        exec ./target/release/axiom
    else
        echo "❌ Built binary not found at ./target/release/axiom-core or ./target/release/axiom"
        exit 1
    fi
else
    echo "❌ Build Failed. Check the errors above."
    exit 1
fi
