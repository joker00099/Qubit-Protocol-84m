#!/bin/bash
# Network Troubleshooting Script for AXIOM Protocol
# This script helps diagnose common network connectivity issues

echo "🔍 AXIOM NETWORK DIAGNOSTICS"
echo "=============================="
echo ""

# Check if node is running
echo "1️⃣  Checking if Axiom node is running..."
if pgrep -f "axiom" > /dev/null; then
    echo "   ✅ Axiom node is running"
    echo "   Process ID(s): $(pgrep -f 'axiom')"
else
    echo "   ❌ Axiom node is NOT running"
    echo "   Run: cargo run --release or ./launch.sh"
    exit 1
fi
echo ""

# Check port bindings
echo "2️⃣  Checking port bindings (6000-6010)..."
for port in {6000..6010}; do
    if netstat -tuln 2>/dev/null | grep -q ":$port " || ss -tuln 2>/dev/null | grep -q ":$port "; then
        echo "   ✅ Port $port is bound"
        listening_process=$(lsof -i :$port -t 2>/dev/null || fuser $port/tcp 2>/dev/null | awk '{print $1}')
        if [ ! -z "$listening_process" ]; then
            echo "      └─ Process: $listening_process"
        fi
    fi
done
echo ""

# Check firewall status
echo "3️⃣  Checking firewall status..."
if command -v ufw &> /dev/null; then
    if sudo ufw status 2>/dev/null | grep -q "Status: active"; then
        echo "   ⚠️  UFW firewall is active"
        if sudo ufw status 2>/dev/null | grep -q "6000:6010/tcp"; then
            echo "   ✅ Ports 6000-6010 are allowed"
        else
            echo "   ❌ Ports 6000-6010 are NOT allowed"
            echo "   Fix: sudo ufw allow 6000:6010/tcp"
        fi
    else
        echo "   ✅ UFW firewall is inactive"
    fi
elif command -v firewall-cmd &> /dev/null; then
    if sudo firewall-cmd --state 2>/dev/null | grep -q "running"; then
        echo "   ⚠️  Firewalld is active"
        echo "   Check: sudo firewall-cmd --list-ports"
    else
        echo "   ✅ Firewalld is inactive"
    fi
else
    echo "   ℹ️  No common firewall tool detected (ufw/firewalld)"
fi
echo ""

# Check network interfaces
echo "4️⃣  Network interfaces and IP addresses..."
if command -v ip &> /dev/null; then
    ip addr show | grep -E "^[0-9]+:|inet " | grep -v "127.0.0.1" | grep -v "::1/128"
elif command -v ifconfig &> /dev/null; then
    ifconfig | grep -E "^[a-z]|inet " | grep -v "127.0.0.1"
else
    echo "   ⚠️  Unable to determine network interfaces"
fi
echo ""

# Check Internet connectivity
echo "5️⃣  Checking internet connectivity..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo "   ✅ Internet connection is working"
else
    echo "   ❌ No internet connection detected"
    echo "   Check your network connection"
fi
echo ""

# Check if behind NAT
echo "6️⃣  Checking NAT/Router configuration..."
local_ip=$(hostname -I 2>/dev/null | awk '{print $1}' || ip route get 1 2>/dev/null | awk '{print $7; exit}')
if [[ $local_ip =~ ^10\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^192\.168\. ]]; then
    echo "   ⚠️  You are behind NAT (private IP: $local_ip)"
    echo "   For external connections, you need to:"
    echo "   1. Forward ports 6000-6010 on your router"
    echo "   2. Find your public IP: curl ifconfig.me"
    echo "   3. Share: <PUBLIC_IP>:<PORT>/p2p/<PEER_ID>"
else
    echo "   ✅ You have a public IP: $local_ip"
    echo "   Other nodes can connect directly to you"
fi
echo ""

# Check for bootstrap configuration
echo "7️⃣  Checking bootstrap peer configuration..."
if [ ! -z "$AXIOM_BOOTSTRAP_PEER" ]; then
    echo "   ✅ AXIOM_BOOTSTRAP_PEER is set:"
    echo "      $AXIOM_BOOTSTRAP_PEER"
else
    echo "   ℹ️  AXIOM_BOOTSTRAP_PEER not set (using mDNS only)"
    echo "   To connect to specific peer, set:"
    echo "   export AXIOM_BOOTSTRAP_PEER=\"<PEER_ID>@<ADDRESS>\""
fi
echo ""

# Show recent connection attempts from logs
echo "8️⃣  Recent network events (if logs available)..."
if [ -f "axiom.log" ]; then
    echo "   Last 5 connection events:"
    grep -E "Peer connected|Peer disconnected|discovered|Dialing" axiom.log 2>/dev/null | tail -5
elif [ -f "nohup.out" ]; then
    echo "   Last 5 connection events:"
    grep -E "Peer connected|Peer disconnected|discovered|Dialing" nohup.out 2>/dev/null | tail -5
else
    echo "   ℹ️  No log file found"
    echo "   Run with: cargo run --release 2>&1 | tee axiom.log"
fi
echo ""

# Recommendations
echo "📋 TROUBLESHOOTING RECOMMENDATIONS"
echo "===================================="
echo ""
echo "If peers = 0:"
echo "  1. Make sure both nodes are actually running"
echo "  2. If on same network: mDNS should discover automatically"
echo "  3. If on different networks:"
echo "     a) Get PeerId and address from first node startup logs"
echo "     b) Set AXIOM_BOOTSTRAP_PEER on second node"
echo "     c) Ensure ports 6000-6010 are open/forwarded"
echo "  4. Check firewall: sudo ufw allow 6000:6010/tcp"
echo "  5. Check logs for connection errors"
echo ""
echo "For more help, see README.md section on 'Connecting Nodes'"
echo ""
