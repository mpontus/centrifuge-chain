//! Autogenerated weights for pallet_crowdloan_claim
//!
//! THIS FILE WAS AUTO-GENERATED USING THE SUBSTRATE BENCHMARK CLI VERSION 4.0.0-dev
//! DATE: 2022-03-10, STEPS: `50`, REPEAT: 20, LOW RANGE: `[]`, HIGH RANGE: `[]`
//! EXECUTION: Some(Wasm), WASM-EXECUTION: Compiled, CHAIN: Some("development-local"), DB CACHE: 1024

// Executed Command:
// ./target/release/centrifuge-chain
// benchmark
// --chain=development-local
// --steps=50
// --repeat=20
// --pallet=pallet_crowdloan_claim
// --extrinsic=*
// --execution=wasm
// --wasm-execution=compiled
// --heap-pages=4096
// --output=/tmp/runtime/development/src/weights/pallet_crowdloan_claim.rs
// --template=./scripts/runtime-weight-template.hbs

#![allow(unused_parens)]
#![allow(unused_imports)]

use frame_support::{
	traits::Get,
	weights::{constants::RocksDbWeight, Weight},
};
use pallet_crowdloan_claim::weights::WeightInfo;
use sp_std::marker::PhantomData;

/// Weights for pallet_crowdloan_claim using the Substrate node and recommended hardware.
pub struct SubstrateWeight<T>(PhantomData<T>);
impl<T: frame_system::Config> WeightInfo for SubstrateWeight<T> {
	fn claim_reward_ed25519() -> Weight {
		(299_358_000 as Weight)
			.saturating_add(T::DbWeight::get().reads(12 as Weight))
			.saturating_add(T::DbWeight::get().writes(5 as Weight))
	}
	fn claim_reward_sr25519() -> Weight {
		(307_081_000 as Weight)
			.saturating_add(T::DbWeight::get().reads(12 as Weight))
			.saturating_add(T::DbWeight::get().writes(5 as Weight))
	}
	fn claim_reward_ecdsa() -> Weight {
		(481_336_000 as Weight)
			.saturating_add(T::DbWeight::get().reads(12 as Weight))
			.saturating_add(T::DbWeight::get().writes(5 as Weight))
	}
	fn initialize() -> Weight {
		(40_071_000 as Weight)
			.saturating_add(T::DbWeight::get().reads(4 as Weight))
			.saturating_add(T::DbWeight::get().writes(6 as Weight))
	}
	fn set_lease_start() -> Weight {
		(20_773_000 as Weight).saturating_add(T::DbWeight::get().writes(1 as Weight))
	}
	fn set_lease_period() -> Weight {
		(20_782_000 as Weight).saturating_add(T::DbWeight::get().writes(1 as Weight))
	}
	fn set_contributions_root() -> Weight {
		(22_172_000 as Weight).saturating_add(T::DbWeight::get().writes(1 as Weight))
	}
	fn set_locked_at() -> Weight {
		(20_800_000 as Weight).saturating_add(T::DbWeight::get().writes(1 as Weight))
	}
	fn set_crowdloan_trie_index() -> Weight {
		(20_887_000 as Weight).saturating_add(T::DbWeight::get().writes(1 as Weight))
	}
}
