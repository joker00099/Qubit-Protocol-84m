#!/bin/bash
# AXIOM Protocol Network Status Checker
# Usage: ./network-status.sh

echo "🌐 AXIOM Protocol Network Status"
echo "================================="

# Check if node is running
if pgrep -f "axiom" > /dev/null; then
    echo "✅ Node Status: RUNNING"
    echo "📊 Process Info:"
    ps aux | grep axiom | grep -v grep | head -1
    echo ""
else
    echo "❌ Node Status: NOT RUNNING"
    echo "💡 Start with: cargo run --bin axiom"
    exit 1
fi

# Check for listening ports (default libp2p ports)
echo "🔌 Network Ports:"
netstat -tlnp 2>/dev/null | grep :0 || echo "No active listeners found"
echo ""

# Check blockchain data
if [ -f "chain.dat" ]; then
    echo "📁 Blockchain Data: PRESENT"
    ls -lh chain.dat
else
    echo "📁 Blockchain Data: NOT FOUND (node may be syncing)"
fi

echo ""
echo "📋 Recent Network Activity (last 10 lines):"
echo "Note: Run 'cargo run --bin axiom' in another terminal to see live logs"
echo "Look for lines containing '🔗 Peer connected', '🌐 Connected Peers', etc."