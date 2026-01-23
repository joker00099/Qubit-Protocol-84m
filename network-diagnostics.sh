#!/bin/bash
# AXIOM Protocol Network Diagnostics
# Run this to troubleshoot network connectivity issues

echo "🔍 AXIOM Protocol Network Diagnostics"
echo "====================================="

# Check if node is running
echo "1. Node Status:"
if pgrep -f "axiom" > /dev/null; then
    echo "   ✅ Node is running"
    ps aux | grep axiom | grep -v grep | head -1
else
    echo "   ❌ No node running"
    echo "   💡 Start with: ./target/release/axiom"
fi

echo ""
echo "2. Network Ports:"
echo "   Checking Axiom ports (6000-6010)..."
netstat -tlnp 2>/dev/null | grep -E ":600[0-9]|:6010" || echo "   ❌ No Axiom ports open"

echo ""
echo "3. mDNS Discovery (Port 5353):"
if command -v nmap >/dev/null 2>&1; then
    echo "   Checking mDNS port..."
    nmap -p 5353 localhost 2>/dev/null | grep -E "5353|open|closed" || echo "   ⚠️  nmap not available"
else
    echo "   ⚠️  nmap not installed (recommended for diagnostics)"
fi

echo ""
echo "4. Firewall Check:"
echo "   Linux/Mac:"
echo "   sudo ufw status | grep -E '6000|5353' || echo '   ⚠️  Check firewall rules'"
echo ""
echo "   Windows:"
echo "   • Check Windows Firewall for ports 6000-6010 TCP, 5353 UDP"

echo ""
echo "5. Network Interfaces:"
ip addr show 2>/dev/null | grep -E "inet |state UP" | head -3 || echo "   ⚠️  Could not check interfaces"

echo ""
echo "6. Connectivity Test:"
echo "   Testing internet connectivity..."
ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "   ✅ Internet reachable" || echo "   ❌ No internet connectivity"

echo ""
echo "7. Recommendations:"
echo "   • Ensure firewall allows ports 6000-6010 TCP and 5353 UDP"
echo "   • Try running multiple nodes locally to test peer discovery"
echo "   • Check if you're on the same network as other Axiom nodes"
echo "   • Verify internet connectivity for global peer discovery"

echo ""
echo "8. Quick Test:"
echo "   Run: ./network-status.sh"
echo "   Then check: cat node1.log | grep -E '🔗|🌐|Connected Peers'"