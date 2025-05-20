module abilities_events_params::abilities_events_params;

use std::string::String;
use sui::event;
use sui::object::{Self, UID, ID};
use sui::tx_context::TxContext;

// Error Codes
const EMedalOfHonorNotAvailable: u64 = 111;

// Structs

public struct Medal has copy, drop, store {
    name: String,
}

public struct MedalStorage has key {
    id: UID,
    available: vector<Medal>,
}

public struct Hero has key {
    id: UID,
    name: String,
    medals: vector<Medal>, // Added medals field
}

public struct HeroMinted has copy, drop {
    hero: ID,
    owner: address,
}

public struct HeroRegistry has key, store {
    id: UID,
    heroes: vector<ID>,
}

// Initializer
fun init(ctx: &mut TxContext) {
    let registry = HeroRegistry {
        id: object::new(ctx),
        heroes: vector::empty<ID>(),
    };
    transfer::share_object(registry);

    let storage = MedalStorage {
        id: object::new(ctx),
        available: vector::singleton(Medal { name: b"Medal of Honor".to_string() }),
    };
    transfer::share_object(storage);
}

// Mint Hero
public fun mint_hero(registry: &mut HeroRegistry, name: String, ctx: &mut TxContext): Hero {
    let freshHero = Hero {
        id: object::new(ctx),
        name,
        medals: vector::empty<Medal>(), // initialize medals
    };

    let minted = HeroMinted {
        hero: object::id(&freshHero),
        owner: ctx.sender(),
    };

    event::emit(minted);
    vector::push_back(&mut registry.heroes, object::id(&freshHero));
    freshHero
}

public entry fun mint_and_keep_hero(
    registry: &mut HeroRegistry,
    name: String,
    ctx: &mut TxContext,
) {
    let hero = mint_hero(registry, name, ctx);
    transfer::transfer(hero, ctx.sender());
}

public fun award_medal_of_honor(hero: &mut Hero, storage: &mut MedalStorage) {
    let mut i = 0;
    let len = vector::length(&storage.available);
    while (i < len) {
        let medal_ref = &mut storage.available[i];
        if (medal_ref.name == b"Medal of Honor".to_string()) {
            let medal = vector::remove(&mut storage.available, i);
            vector::push_back(&mut hero.medals, medal);
            return;
        };
        i = i + 1;
    };
    abort EMedalOfHonorNotAvailable;
}

/////// Tests ///////

#[test_only]
use sui::test_scenario as ts;
#[test_only]
use sui::test_scenario::{take_shared, return_shared};
#[test_only]
use sui::test_utils::{destroy, assert_eq};

#[test]
fun test_hero_creation(registry: &mut HeroRegistry) {
    let mut test = ts::begin(@USER);
    init(test.ctx());
    test.next_tx(@USER);

    let hero = mint_hero(registry, b"Flash".to_string(), test.ctx());
    assert_eq(hero.name, b"Flash".to_string());

    destroy(hero);
    test.end();
}
#[test]
fun test_event_thrown() {
    let mut test = ts::begin(@USER);

    // Create and share registry, capture its ID
    let registry = HeroRegistry {
        id: object::new(test.ctx()),
        heroes: vector::empty<ID>(),
    };
    let registry_id = object::id(&registry);
    transfer::share_object(registry);

    test.next_tx(@USER);

    // Pass `test` as first argument!
    let mut registry = take_shared<HeroRegistry>(&mut test);
    let hero = mint_hero(&mut registry, b"Storm".to_string(), test.ctx());
    return_shared(registry);

    let events = event::events_by_type<HeroMinted>();
    assert_eq(vector::length(&events), 1);
    assert_eq(events[0].owner, @USER);

    destroy(hero);
    test.end();
}

#[test]
fun test_medal_award() {
    let mut test = ts::begin(@USER);

    let registry = HeroRegistry {
        id: object::new(test.ctx()),
        heroes: vector::empty<ID>(),
    };
    let registry_id = object::id(&registry);
    transfer::share_object(registry);

    let storage = MedalStorage {
        id: object::new(test.ctx()),
        available: vector::singleton(Medal { name: b"Medal of Honor".to_string() }),
    };
    let storage_id = object::id(&storage);
    transfer::share_object(storage);

    test.next_tx(@USER);

    // Pass `test` as first argument!
    let mut registry = take_shared<HeroRegistry>(&mut test);
    let mut storage = take_shared<MedalStorage>(&mut test);

    let mut hero = mint_hero(&mut registry, b"Ironman".to_string(), test.ctx());
    award_medal_of_honor(&mut hero, &mut storage);

    assert_eq(vector::length(&hero.medals), 1);
    assert_eq(hero.medals[0].name, b"Medal of Honor".to_string());

    destroy(hero);
    return_shared(registry);
    return_shared(storage);
    test.end();
}
