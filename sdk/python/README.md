# Axiom SDK for Python

Python SDK for interacting with the Axiom blockchain.

## Installation

```bash
pip install axiom-sdk
```

## Quick Start

```python
from axiom_sdk import AxiomClient, Wallet, axm_to_sats, sats_to_axm

# Initialize client
client = AxiomClient("http://localhost:8332")

# Create wallet
wallet = Wallet()  # Or load existing: Wallet(private_key="...")
print(f"Address: {wallet.address}")

# Check balance
balance = client.get_balance(wallet.address)
print(f"Balance: {sats_to_axm(balance)} AXM")

# Send transaction
recipient = "recipient_address_here"
amount = axm_to_sats(1.5)  # Send 1.5 AXM
tx_hash = client.send(wallet, recipient, amount, use_zk=True)
print(f"Transaction sent: {tx_hash}")

# Get chain info
info = client.get_chain_info()
print(f"Chain height: {info['height']}")
```

## Features

- **Wallet Management**: Generate keys, sign transactions
- **Transactions**: Create, sign, and broadcast transactions
- **Queries**: Get blocks, transactions, balances, chain info
- **ZK-SNARKs**: Generate privacy-preserving proofs
- **VDF Verification**: Verify verifiable delay function proofs
- **Neural Guardian**: Query AI threat detection system

## API Reference

### AxiomClient

- `get_balance(address)` - Get balance for an address
- `get_nonce(address)` - Get nonce for an address
- `create_transaction(wallet, recipient, amount, fee, use_zk)` - Create signed transaction
- `broadcast_transaction(tx)` - Broadcast transaction
- `send(wallet, recipient, amount, fee, use_zk)` - Create and broadcast transaction
- `get_transaction(tx_hash)` - Get transaction by hash
- `get_block(block_hash, index)` - Get block by hash or index
- `get_latest_block()` - Get latest block
- `get_chain_info()` - Get blockchain info
- `verify_vdf(output, proof, input, time)` - Verify VDF proof
- `query_neural_guardian(peer_id)` - Query threat detection

### Wallet

- `Wallet()` - Generate new wallet
- `Wallet(private_key)` - Load existing wallet
- `sign(message)` - Sign a message
- `verify(message, signature, public_key)` - Verify signature

## License

MIT
