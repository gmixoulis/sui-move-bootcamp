module package_upgrade::hero;

use std::string::String;

use sui::dynamic_field as df;
use sui::dynamic_object_field as dof;
use sui::package;

use package_upgrade::blacksmith::{Shield, Sword};
use package_upgrade::version::Version;

const EAlreadyEquipedShield: u64 = 0;
const EAlreadyEquipedSword: u64 = 1;

public struct HERO() has drop;

/// Hero NFT
public struct Hero has key, store {
    id: UID,
    health: u64,
    stamina: u64,
    // Task: Add power field
}

fun init(otw: HERO, ctx: &mut TxContext) {
    package::claim_and_keep(otw, ctx);
}

/// Anyone can mint a hero.
/// Hero starts with 100 heath and 10 stamina.
public fun mint_hero(version: &Version, ctx: &mut TxContext): Hero {
    version.check_is_valid();
    Hero {
        id: object::new(ctx),
        health: 100,
        stamina: 10
    }
}

// Task: Implement mint_hero_v2 that accepts payment
// public fun mint_hero_v2(version: &Version, payment: Coin<SUI>, ctx: &mut TxContext): Hero {
// }

/// Hero can equip a single sword.
/// Equiping a sword increases the `Hero`'s power by its attack.
public fun equip_sword(self: &mut Hero, version: &Version, sword: Sword) {
    version.check_is_valid();
    // Task: Use SwordKey instead of string
    if (df::exists_(&self.id, b"sword".to_string())) {
        abort(EAlreadyEquipedSword)
    };
    // Task: Update power
    self.add_dof(b"sword".to_string(), sword)
}

/// Hero can equip a single shield.
/// Equiping a shield increases the `Hero`'s power by its defence.
public fun equip_shield(self: &mut Hero, version: &Version, shield: Shield) {
    version.check_is_valid();
    // Task: Use ShieldKey instead of string
    if (df::exists_(&self.id, b"shield".to_string())) {
        abort(EAlreadyEquipedShield)
    };
    // Task: Update power
    self.add_dof(b"shield".to_string(), shield)
}

public fun health(self: &Hero): u64 {
    self.health
}

public fun stamina(self: &Hero): u64 {
    self.stamina
}

// Task: Add power getter
// public fun power(self: &Hero): u64 {
//     0
// }

/// Returns the sword the hero has equipped.
/// Aborts if it does not exists
public fun sword(self: &Hero): &Sword {
    // Task: Use SwordKey instead of string
    dof::borrow(&self.id, b"sword")
}

/// Returns the shield the hero has equipped.
/// Aborts if it does not exists
public fun shield(self: &Hero): &Shield {
    // Task: Use ShieldKey instead of string
    dof::borrow(&self.id, b"shield")
}

/// Generic add dynamic object field to the hero.
fun add_dof<T: key + store>(self: &mut Hero, name: String, value: T) {
    dof::add(&mut self.id, name, value)
}

#[test_only]
public fun init_for_testing(ctx: &mut TxContext) {
    init(HERO(), ctx);
}

#[test_only]
public fun uid_mut_for_testing(self: &mut Hero): &mut UID {
    &mut self.id
}

