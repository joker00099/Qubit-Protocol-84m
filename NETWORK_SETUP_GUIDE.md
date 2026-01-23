# AXIOM Protocol - Quick Network Setup Guide

## 🚀 Quick Start

### Single Node (Local Testing)
```bash
cargo run --release --bin axiom
```

### Two Nodes on Same WiFi/LAN
**Node 1:**
```bash
cargo run --release --bin axiom
```

**Node 2 (different device on same network):**
```bash
cargo run --release --bin axiom
```

✅ They should discover each other automatically via mDNS!

---

## 🌐 Connecting Nodes Across Different Networks

### Node 1 (Your Computer)

**1. Start the node:**
```bash
cargo run --release --bin axiom
```

**2. Copy the PeerId from startup output:**
```
🆔 PeerId: 12D3KooWABC123xyz...
🔊 Listening on: /ip4/0.0.0.0/tcp/6000
```

**3. Get your public IP:**
```bash
curl ifconfig.me
# Output: 203.0.113.42
```

**4. Open port 6000 in firewall:**
```bash
# Linux
sudo ufw allow 6000/tcp

# Or open range 6000-6010 for all Axiom ports
sudo ufw allow 6000:6010/tcp
```

**5. Forward port 6000 on your router:**
- Log into router admin (usually http://192.168.1.1)
- Find "Port Forwarding" or "NAT" settings
- Forward TCP port 6000 to your computer's local IP
- Save settings

### Node 2 (Friend's Device/Phone)

**1. Set the bootstrap peer (use Node 1's info):**
```bash
export AXIOM_BOOTSTRAP_PEER="12D3KooWABC123xyz@/ip4/203.0.113.42/tcp/6000"
```

**2. Start the node:**
```bash
cargo run --release --bin axiom
```

**3. Watch for connection:**
```
🔗 Peer connected: 12D3KooWABC123xyz... | Total peers: 1
✅ Block accepted and added to chain
🔁 Synced complete chain from peer. New height: 42
```

---

## 📱 Running on Android/Termux

**1. Install Termux** from F-Droid (not Play Store)

**2. Install Rust and dependencies:**
```bash
pkg update && pkg upgrade
pkg install rust git clang binutils openssl
```

**3. Clone and build:**
```bash
git clone https://github.com/joker00099/Axiom-Protocol-84m.git
cd Axiom-Protocol-84m
cargo build --release
```

**4. Run with bootstrap peer:**
```bash
export AXIOM_BOOTSTRAP_PEER="<PEER_ID>@/ip4/<PUBLIC_IP>/tcp/6000"
cargo run --release --bin axiom
```

---

## 🔍 Troubleshooting

### Check if everything is working:
```bash
./network-troubleshoot.sh
```

### Common Issues:

**❌ Peers = 0 after 5+ minutes**
- ✅ Check firewall: `sudo ufw allow 6000:6010/tcp`
- ✅ Verify port forwarding on router
- ✅ Use public IP (from `curl ifconfig.me`), not local IP
- ✅ Make sure AXIOM_BOOTSTRAP_PEER is set correctly on Node 2
- ✅ Verify Node 1 is actually running

**❌ "Connection refused"**
- ✅ Node 1 is not running or crashed
- ✅ Firewall is blocking the port
- ✅ Port forwarding not configured

**❌ "Connection timeout"**
- ✅ Wrong IP address (use public IP if behind NAT)
- ✅ Router firewall blocking connections
- ✅ ISP blocking P2P traffic (rare)

**❌ mDNS not discovering peers on same network**
- ✅ Firewall blocking mDNS (port 5353 UDP)
- ✅ Router has mDNS/Bonjour disabled
- ✅ Network isolation mode enabled (some routers)

---

## 📊 Understanding the Dashboard

```
--- 🏛️  AXIOM STATUS ---
⛓️  Height: 42 | Diff: 2 | Trend: STABLE ↔️
⏳ Time-Lock: 58m remaining | 🤖 AI Shield: ACTIVE
💰 Mined: 420.00 AXM | Remaining: 83,999,580.00 AXM | 0.50% of max supply
🌐 Network Status:
   ├─ PeerId: 12D3KooWABC123...     ← Your node ID
   ├─ Connected Peers: 2            ← Number of connected peers
   │  ├─ 12D3KooWXYZ789...          ← Connected peer 1
   │  └─ 12D3KooWDEF456...          ← Connected peer 2
   └─ Listen Addresses:
      ├─ /ip4/192.168.1.100/tcp/6000  ← Local network address
      └─ /ip4/0.0.0.0/tcp/6000        ← Listening on all interfaces
```

**Key indicators:**
- **Connected Peers > 0**: ✅ Network is working!
- **Connected Peers = 0**: ❌ No peers (see troubleshooting)
- **Height increasing**: ✅ Chain is syncing
- **Height stuck**: ❌ Not receiving new blocks

---

## 🔧 Advanced Configuration

### Environment Variables

```bash
# Connect to specific bootstrap peer
export AXIOM_BOOTSTRAP_PEER="<PEER_ID>@/ip4/<IP>/tcp/<PORT>"

# Or multiple peers (comma-separated)
export AXIOM_BOOTSTRAP_PEERS="/ip4/1.2.3.4/tcp/6000,/ip4/5.6.7.8/tcp/6000"

# Set wallet address for mining rewards
export AXIOM_WALLET_ADDRESS="AXM1a2b3c4d5e6f7g8h9i0..."

# Configure mining threads
export AXIOM_MINING_THREADS=4

# Custom storage path
export AXIOM_STORAGE_PATH="./data/axiom_chain.dat"
```

### Port Range

Axiom uses ports **6000-6010** (will try 6000 first, then increment if busy).

**Open all Axiom ports:**
```bash
sudo ufw allow 6000:6010/tcp
```

---

## 💡 Tips for Success

1. **Start with local testing**: Run two nodes on same network first
2. **Check logs**: Watch for "Peer connected" messages
3. **Be patient**: Initial peer discovery can take 30-60 seconds
4. **Keep nodes running**: Chain sync happens over time
5. **Use troubleshoot script**: Run `./network-troubleshoot.sh` regularly

---

## 📚 More Information

- Full documentation: [README.md](README.md)
- Network protocol: [NETWORK_PROTOCOL.md](NETWORK_PROTOCOL.md)
- Technical spec: [TECHNICAL_SPEC.md](TECHNICAL_SPEC.md)

---

**Need help?** Check the troubleshooting section in README.md or run `./network-troubleshoot.sh`
