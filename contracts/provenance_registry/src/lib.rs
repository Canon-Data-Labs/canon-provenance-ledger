#![no_std]
use soroban_sdk::{contract, contractimpl, contracttype, Address, Bytes, Env, Symbol, symbol_short};

/// A provenance record anchoring a data hash to its creator.
#[contracttype]
#[derive(Clone)]
pub struct ProvenanceRecord {
    pub creator: Address,
    pub data_hash: Bytes,
    pub timestamp: u64,
    pub verified: bool,
}

const RECORDS: Symbol = symbol_short!("RECORDS");

#[contract]
pub struct ProvenanceRegistry;

#[contractimpl]
impl ProvenanceRegistry {
    /// Register a new data hash. Caller must authenticate.
    pub fn register(env: Env, creator: Address, data_hash: Bytes) -> u64 {
        creator.require_auth();

        let id: u64 = env.storage().instance().get(&RECORDS).unwrap_or(0) + 1;

        let record = ProvenanceRecord {
            creator,
            data_hash,
            timestamp: env.ledger().timestamp(),
            verified: false,
        };

        env.storage().persistent().set(&id, &record);
        env.storage().instance().set(&RECORDS, &id);
        id
    }

    /// Verify a record (admin only — caller must be the original creator for now).
    pub fn verify(env: Env, id: u64, caller: Address) {
        caller.require_auth();
        let mut record: ProvenanceRecord = env.storage().persistent().get(&id).expect("not found");
        assert!(record.creator == caller, "unauthorized");
        record.verified = true;
        env.storage().persistent().set(&id, &record);
    }

    /// Fetch a record by ID.
    pub fn get(env: Env, id: u64) -> ProvenanceRecord {
        env.storage().persistent().get(&id).expect("not found")
    }

    /// Total records registered.
    pub fn count(env: Env) -> u64 {
        env.storage().instance().get(&RECORDS).unwrap_or(0)
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use soroban_sdk::{testutils::{Address as _, Ledger}, Bytes, Env};

    #[test]
    fn test_register_and_get() {
        let env = Env::default();
        env.mock_all_auths();
        let contract_id = env.register_contract(None, ProvenanceRegistry);
        let client = ProvenanceRegistryClient::new(&env, &contract_id);

        let creator = Address::generate(&env);
        let hash = Bytes::from_slice(&env, b"sha256:abc123");

        let id = client.register(&creator, &hash);
        assert_eq!(id, 1);

        let record = client.get(&id);
        assert_eq!(record.creator, creator);
        assert!(!record.verified);
        assert_eq!(client.count(), 1);
    }

    #[test]
    fn test_verify() {
        let env = Env::default();
        env.mock_all_auths();
        let contract_id = env.register_contract(None, ProvenanceRegistry);
        let client = ProvenanceRegistryClient::new(&env, &contract_id);

        let creator = Address::generate(&env);
        let hash = Bytes::from_slice(&env, b"sha256:xyz789");
        let id = client.register(&creator, &hash);

        client.verify(&id, &creator);
        assert!(client.get(&id).verified);
    }
}
