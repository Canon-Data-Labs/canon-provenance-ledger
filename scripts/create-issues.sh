#!/usr/bin/env bash
# Run this after updating GITHUB_TOKEN with issues:write permission
# Usage: bash scripts/create-issues.sh

set -e
REPO="Canon-Data-Labs/canon-provenance-ledger"

# Create labels first
for label_def in \
  "backend:0075ca:Backend / API" \
  "frontend:e4e669:Frontend / UI" \
  "contracts:d93f0b:Stellar Soroban contracts" \
  "security:b60205:Security concern" \
  "feature:a2eeef:New feature" \
  "enhancement:84b6eb:Improvement to existing" \
  "refactor:e99695:Code refactor" \
  "testing:0e8a16:Tests" \
  "reliability:f9d0c4:Reliability / resilience" \
  "performance:fef2c0:Performance" \
  "ux:c5def5:User experience" \
  "accessibility:bfd4f2:Accessibility" \
  "documentation:0075ca:Documentation" \
  "tooling:cfd3d7:Dev tooling / scripts" \
  "integration:d4c5f9:Cross-component integration" \
  "ci:006b75:CI/CD"
do
  name="${label_def%%:*}"; rest="${label_def#*:}"; color="${rest%%:*}"; desc="${rest#*:}"
  gh label create "$name" --color "$color" --description "$desc" -R $REPO 2>/dev/null || true
done

create() { gh issue create -R $REPO --title "$1" --body "$2" --label "$3"; }

# ── BACKEND (20) ──
create "Add rate limiting to POST /api/provenance/register" \
  "Prevent abuse by adding per-IP rate limiting (e.g. express-rate-limit) to the register endpoint." \
  "backend,enhancement"

create "Move secret key signing to client-side XDR submission" \
  "The current architecture sends the raw Stellar secret key to the backend. Refactor so the frontend signs the transaction and submits a signed XDR envelope to the backend instead." \
  "backend,security"

create "Add request body size limit to Express" \
  "Large payloads can cause memory issues. Set a reasonable body size cap via express.json({ limit: '100kb' })." \
  "backend,security"

create "Add CORS origin allowlist via environment variable" \
  "Currently CORS is open to all origins. Add a CORS_ORIGIN env var to restrict allowed origins in production." \
  "backend,security"

create "Add helmet.js for HTTP security headers" \
  "Use the helmet middleware to set Content-Security-Policy, X-Frame-Options, and other security headers." \
  "backend,security"

create "Add structured logging with pino" \
  "Replace console.log/console.error with pino for structured JSON logging with log levels." \
  "backend,enhancement"

create "Add /api/provenance/verify endpoint" \
  "Expose the contract's verify function via a backend route so verified status can be updated through the API." \
  "backend,feature"

create "Add /api/provenance/record/:id endpoint" \
  "Expose a route to fetch a single provenance record by its on-chain ID." \
  "backend,feature"

create "Add pagination to GET /api/provenance/records endpoint" \
  "When a list endpoint is added, support limit/offset query params to paginate results." \
  "backend,feature"

create "Add integration tests for provenance routes" \
  "Write integration tests using vitest or jest + supertest covering register, account lookup, and error cases." \
  "backend,testing"

create "Add input validation with zod to routes" \
  "Replace manual if-checks with zod schemas for consistent, typed request validation across all routes." \
  "backend,enhancement"

create "Add graceful shutdown handling for Express server" \
  "Handle SIGTERM/SIGINT to close the HTTP server cleanly before process exit." \
  "backend,reliability"

create "Add retry logic for Stellar transaction submission" \
  "Transient Horizon errors should be retried with exponential backoff before returning a 500." \
  "backend,reliability"

create "Cache Stellar account sequence number to reduce Horizon calls" \
  "Each register call loads the account from Horizon. Investigate caching the sequence number to reduce latency." \
  "backend,performance"

create "Add fee-bump transaction support for sponsored fees" \
  "Allow a fee account to sponsor transaction fees so end users don't need XLM for gas." \
  "backend,feature"

create "Extract Stellar network config into a dedicated config module" \
  "Centralise STELLAR_HORIZON_URL, STELLAR_NETWORK, and networkPassphrase into src/config.js instead of inline in the service." \
  "backend,refactor"

create "Extend /health to report Horizon connectivity" \
  "Extend GET /health to ping the configured Horizon server and report its status." \
  "backend,enhancement"

create "Add OpenAPI / Swagger documentation for all routes" \
  "Document all API endpoints with request/response schemas using swagger-jsdoc and swagger-ui-express." \
  "backend,documentation"

create "Add .env validation on startup" \
  "Fail fast with a clear error message if required environment variables are missing when the server starts." \
  "backend,reliability"

create "Write unit tests for stellar.js service functions" \
  "Mock the Stellar SDK and test validateSecretKey, submitDataHashTx, and getAccountInfo in isolation." \
  "backend,testing"

# ── FRONTEND (20) ──
create "Replace inline styles with CSS modules or Tailwind" \
  "All styling is currently inline. Migrate to CSS Modules or Tailwind CSS for maintainability and theming." \
  "frontend,refactor"

create "Add client-side Stellar transaction signing" \
  "Sign the transaction in the browser using the Stellar SDK and send only the signed XDR to the backend, removing the need to transmit the secret key." \
  "frontend,security"

create "Add Freighter wallet integration" \
  "Integrate the Freighter browser wallet so users can sign transactions without ever entering their secret key." \
  "frontend,feature"

create "Add form validation feedback for secret key format" \
  "Validate that the entered key starts with 'S' and is 56 characters before submitting, with inline error feedback." \
  "frontend,ux"

create "Add loading spinner component" \
  "Replace the disabled button text with a proper loading spinner component during transaction submission." \
  "frontend,ux"

create "Add toast notification system for success and error states" \
  "Replace inline error/result divs with a toast notification system for better UX." \
  "frontend,ux"

create "Add a provenance record lookup page" \
  "Create a /lookup route where users can enter a record ID or data hash and view the on-chain provenance record." \
  "frontend,feature"

create "Add React Router for multi-page navigation" \
  "Install react-router-dom and add routes for at minimum: / (register), /lookup, /about." \
  "frontend,feature"

create "Add account dashboard showing registered records" \
  "After connecting a wallet or entering a public key, show all provenance records associated with that account." \
  "frontend,feature"

create "Add copy-to-clipboard button for hash and tx hash" \
  "Add a one-click copy button next to the SHA-256 hash and transaction hash in the result panel." \
  "frontend,ux"

create "Add Stellar Explorer deep-link for transaction hash" \
  "Link the displayed tx hash to https://stellar.expert/explorer/testnet/tx/{txHash} so users can verify on-chain." \
  "frontend,ux"

create "Add dark mode support" \
  "Implement a dark/light mode toggle using CSS variables or a theming library." \
  "frontend,enhancement"

create "Add end-to-end tests with Playwright" \
  "Write E2E tests covering the register flow, error states, and result display." \
  "frontend,testing"

create "Add unit tests for provenance API client" \
  "Mock fetch and test registerData error handling and response parsing in provenance.ts." \
  "frontend,testing"

create "Add favicon and Open Graph meta tags" \
  "Add a Canon Protocol favicon and og:title/og:description meta tags for link previews." \
  "frontend,enhancement"

create "Make API base URL configurable via VITE_API_URL env var" \
  "Hard-coded '/api/provenance' base should read from import.meta.env.VITE_API_URL for flexibility across environments." \
  "frontend,enhancement"

create "Audit and fix accessibility: aria-labels and keyboard navigation" \
  "Audit the form and result panel for missing aria-labels, roles, and ensure full keyboard navigability." \
  "frontend,accessibility"

create "Add file upload support for registering binary data" \
  "Allow users to upload a file; hash it client-side with SubtleCrypto and register the hash without sending file contents to the server." \
  "frontend,feature"

create "Add network selector (testnet / mainnet)" \
  "Let users switch between Stellar testnet and mainnet from the UI, passing the selection to the backend." \
  "frontend,feature"

create "Add React error boundary component" \
  "Wrap the app in a React error boundary to catch unexpected render errors and show a fallback UI." \
  "frontend,reliability"

# ── CONTRACTS (20) ──
create "Add admin role for multi-party verification" \
  "Allow a designated admin address (set at deploy time) to verify any record, not just the original creator." \
  "contracts,feature"

create "Add TTL / ledger expiry bump for persistent storage entries" \
  "Persistent storage entries expire on Soroban. Add extend_ttl calls in register and verify to keep records alive." \
  "contracts,bug"

create "Add duplicate hash detection in register" \
  "Before registering, check if the same data_hash already exists for the caller and reject duplicates." \
  "contracts,feature"

create "Add record revocation function" \
  "Allow the original creator to revoke (soft-delete) a record by setting a revoked: bool flag." \
  "contracts,feature"

create "Emit contract events for register and verify" \
  "Use env.events().publish() to emit structured events on register and verify for off-chain indexing." \
  "contracts,feature"

create "Add optional metadata field to ProvenanceRecord" \
  "Allow an optional Bytes metadata field (e.g. MIME type, source label) to be stored alongside the hash." \
  "contracts,feature"

create "Add multi-verifier support" \
  "Allow multiple distinct addresses to co-verify a record, storing a list of verifier addresses." \
  "contracts,feature"

create "Write test for unauthorized verify attempt" \
  "Add a test asserting that calling verify with a non-creator address panics with 'unauthorized'." \
  "contracts,testing"

create "Write test for get on non-existent record ID" \
  "Add a test asserting that get panics with 'not found' when called with an ID that has not been registered." \
  "contracts,testing"

create "Write test for sequential registrations and ID increment" \
  "Register multiple records and assert IDs increment correctly and records are stored independently." \
  "contracts,testing"

create "Add contract upgrade / migration path" \
  "Document and implement a strategy for upgrading the contract using Soroban's update_current_contract_wasm." \
  "contracts,enhancement"

create "Add per-creator record index" \
  "Maintain a list of record IDs per creator address so all records for a given creator can be fetched efficiently." \
  "contracts,feature"

create "Add deploy script using soroban-cli" \
  "Write a shell script (scripts/deploy.sh) that builds the WASM, deploys to testnet, and prints the contract ID." \
  "contracts,tooling"

create "Generate TypeScript bindings from contract ABI" \
  "Use soroban contract bindings typescript to generate a typed client and commit it to frontend/src/contracts/." \
  "contracts,tooling"

create "Add SOROBAN_CONTRACT_ID to backend environment config" \
  "Add SOROBAN_CONTRACT_ID env var and wire the backend to invoke the on-chain contract directly via RPC instead of manageData." \
  "contracts,integration"

create "Replace manageData anchor with direct Soroban contract invocation" \
  "The backend currently uses Horizon manageData as a workaround. Migrate to invoking the deployed Soroban contract via Stellar RPC." \
  "contracts,integration"

create "Add fuzz / property-based tests for register" \
  "Use the arbitrary crate or similar to fuzz register with random Bytes inputs and assert invariants hold." \
  "contracts,testing"

create "Add contract-level pause/unpause access control" \
  "Allow an admin to pause the contract to halt new registrations during an incident." \
  "contracts,feature"

create "Benchmark contract CPU and memory instruction usage" \
  "Run soroban contract invoke with --cost flag and document resource consumption for register, verify, and get." \
  "contracts,performance"

create "Add CI workflow to build and test the Soroban contract" \
  "Create .github/workflows/contracts.yml that runs cargo test on every push." \
  "contracts,ci"

echo "✓ All 60 issues created"
