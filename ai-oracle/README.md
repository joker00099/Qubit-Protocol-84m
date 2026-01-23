# Axiom AI Oracle Network

A decentralized oracle network for integrating AI/LLM services into the Axiom blockchain.

## Overview

The AI Oracle Network allows smart contracts and users to query external AI models (GPT-4, Claude, Llama, etc.) in a trustless, decentralized manner. Multiple oracle providers submit responses, and consensus is reached through stake-weighted voting.

## Architecture

### Components

1. **Oracle Request System**: Users submit queries with stake
2. **Provider Network**: Multiple independent providers respond to queries
3. **Consensus Mechanism**: Stake-weighted voting determines final answer
4. **Reputation System**: Tracks provider accuracy and reliability
5. **Smart Contract Integration**: On-chain verification of oracle responses

### Key Features

- **Multi-Provider Consensus**: Aggregates responses from multiple AI providers
- **Stake-Weighted Voting**: Providers with higher stake have more influence
- **Cryptographic Verification**: All responses are signed and hashed
- **Reputation Scoring**: Tracks provider accuracy over time
- **Model Flexibility**: Supports GPT-4, Claude, Llama, Mistral, and more
- **Economic Security**: Providers stake AXM tokens to participate

## API Reference

### Submit Oracle Request

```bash
POST /api/request
```

Request body:
```json
{
  "request_id": "req-001",
  "query": "What is the price of Bitcoin?",
  "model": "gpt-4",
  "requester": "contract_address",
  "timestamp": 1234567890,
  "stake": 1000000000
}
```

### Submit Provider Response

```bash
POST /api/response
```

Request body:
```json
{
  "request_id": "req-001",
  "provider_id": "provider-001",
  "answer": "$45,234.56",
  "signature": "0x...",
  "stake_weight": 100000000000,
  "submitted_at": 1234567890
}
```

### Get Oracle Response

```bash
GET /api/response/{request_id}
```

Response:
```json
{
  "request_id": "req-001",
  "answer": "$45,234.56",
  "confidence": 0.95,
  "providers": [...],
  "consensus_hash": "0x...",
  "finalized_at": 1234567890
}
```

### Register Oracle Provider

```bash
POST /api/provider/register
```

Request body:
```json
{
  "provider_id": "my-provider",
  "endpoint": "https://my-api.com",
  "models": ["gpt-4", "claude-3"],
  "stake": 100000000000,
  "reputation_score": 1.0,
  "total_requests": 0,
  "successful_requests": 0
}
```

### List Providers

```bash
GET /api/providers
```

### Network Statistics

```bash
GET /api/stats
```

## Usage Examples

### JavaScript

```javascript
const axios = require('axios');

// Submit a query
async function queryOracle(query, model = 'gpt-4') {
  const request = {
    request_id: generateId(),
    query: query,
    model: model,
    requester: 'my_address',
    timestamp: Date.now(),
    stake: 1000000000
  };
  
  const response = await axios.post('http://localhost:8081/api/request', request);
  return response.data.request_id;
}

// Check response
async function getOracleResponse(requestId) {
  const response = await axios.get(`http://localhost:8081/api/response/${requestId}`);
  return response.data;
}
```

### Python

```python
import requests
import time

def query_oracle(query, model='gpt-4'):
    request = {
        'request_id': generate_id(),
        'query': query,
        'model': model,
        'requester': 'my_address',
        'timestamp': int(time.time()),
        'stake': 1000000000
    }
    
    response = requests.post('http://localhost:8081/api/request', json=request)
    return response.json()['request_id']

def get_oracle_response(request_id):
    response = requests.get(f'http://localhost:8081/api/response/{request_id}')
    return response.json()
```

### Rust

```rust
use reqwest;
use serde_json::json;

async fn query_oracle(query: &str, model: &str) -> Result<String, Box<dyn std::error::Error>> {
    let client = reqwest::Client::new();
    let request = json!({
        "request_id": generate_id(),
        "query": query,
        "model": model,
        "requester": "my_address",
        "timestamp": chrono::Utc::now().timestamp(),
        "stake": 1000000000u64
    });
    
    let res = client.post("http://localhost:8081/api/request")
        .json(&request)
        .send()
        .await?;
    
    let response: serde_json::Value = res.json().await?;
    Ok(response["request_id"].as_str().unwrap().to_string())
}
```

## Consensus Mechanism

### Stake-Weighted Voting

1. Multiple providers submit responses to the same query
2. Each response is weighted by the provider's stake
3. The answer with the highest cumulative stake is selected
4. Confidence score = winning_stake / total_stake

### Example

- Provider A (100 AXM stake): "Yes"
- Provider B (100 AXM stake): "Yes"  
- Provider C (50 AXM stake): "No"

Result: "Yes" with confidence 0.80 (200/250)

### Finalization

- Minimum 3 responses required for consensus
- Responses aggregated within 30-second window
- Consensus hash computed for verification
- Result posted on-chain with proof

## Economic Model

### Stake Requirements

- Minimum stake: 50 AXM
- Higher stake = higher influence
- Stake locked during active requests

### Rewards

- Correct responses: Earn portion of request fee
- Majority providers: Split 90% of fee
- Minority providers: Forfeit fee, lose reputation

### Penalties

- Incorrect responses: Reputation decrease
- Persistent failures: Stake slashing
- Collusion detection: Permanent ban

## Security

### Cryptographic Verification

- All responses are signed with provider's private key
- Consensus hash prevents tampering
- On-chain verification ensures integrity

### Sybil Resistance

- High stake requirements
- Reputation-based weighting
- Collusion detection algorithms

### Anti-Gaming

- Randomized provider selection
- Time-locked responses
- Outlier detection

## Provider Setup

### Requirements

- 50+ AXM for staking
- Reliable API access to AI models
- Stable internet connection
- Monitoring infrastructure

### Registration

1. Stake AXM tokens on-chain
2. Register provider via API
3. Configure endpoint and models
4. Start responding to requests

### Best Practices

- Respond to requests quickly (< 10s)
- Use multiple AI models for redundancy
- Monitor reputation score
- Keep stake topped up
- Report suspicious activity

## Integration

### Smart Contracts

```solidity
// Request oracle data
function requestAIOracle(string memory query) external payable {
    require(msg.value >= minStake, "Insufficient stake");
    
    bytes32 requestId = keccak256(abi.encodePacked(query, block.timestamp));
    oracleRequests[requestId] = OracleRequest({
        query: query,
        requester: msg.sender,
        stake: msg.value,
        timestamp: block.timestamp
    });
    
    emit OracleRequested(requestId, query);
}

// Callback with oracle result
function __callback(bytes32 requestId, string memory answer, bytes32 consensusHash) external {
    require(msg.sender == oracleAddress, "Only oracle can call");
    // Process oracle response
}
```

## Monitoring

### Metrics

- Total requests processed
- Average response time
- Consensus rate
- Provider uptime
- Stake distribution

### Dashboard

Access real-time metrics at: `http://localhost:8081/api/stats`

## Running the Oracle

### Development

```bash
cd ai-oracle
cargo run
```

### Production

```bash
cargo build --release
./target/release/axiom-ai-oracle
```

### Docker

```bash
docker build -t axiom-ai-oracle .
docker run -p 8081:8081 axiom-ai-oracle
```

## Testing

```bash
cargo test
```

Test coverage includes:
- Consensus algorithms
- Stake weighting
- Request/response flow
- Provider management
- Serialization

## License

MIT

## Support

- Documentation: https://docs.axiomprotocol.io/oracle
- Discord: https://discord.gg/axiom
- GitHub: https://github.com/axiom-protocol/ai-oracle
