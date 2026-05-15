# Canon Protocol

> The official provenance ledger — distinguishing verified human data from synthetic noise.

## Architecture

```
canon-provenance-ledger/
├── contracts/        # Stellar Soroban smart contracts (Rust)
├── backend/          # Node.js/Express API
├── frontend/         # React/Vite app
└── docker-compose.yml
```

## Stack

- **Smart Contracts**: Stellar Soroban (Rust)
- **Backend**: Node.js, Express, Stellar SDK
- **Frontend**: React, Vite, TypeScript

## Quick Start

```bash
# Start all services
docker-compose up

# Contracts
cd contracts && cargo build

# Backend
cd backend && npm install && npm run dev

# Frontend
cd frontend && npm install && npm run dev
```
