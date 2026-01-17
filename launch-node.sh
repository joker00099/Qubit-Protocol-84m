#!/bin/bash
# Qubit Protocol Network Launch Script
# Run this to start your node and join the network

echo "🚀 Qubit Protocol Network Launch"
echo "================================="

# Check if already running
if pgrep -f "qubit" > /dev/null; then
    echo "❌ Node already running! Use './network-status.sh' to check status."
    exit 1
fi

echo "✅ Starting Qubit Protocol Node..."
echo "📊 Monitor network activity in real-time"
echo "🌐 Look for peer connections in the logs"
echo "⛓️  Mining will start automatically after genesis"
echo ""
echo "Press Ctrl+C to stop the node"
echo "================================="
echo ""

# Start the node
./target/release/qubit