/// Module: hero
module hero::hero;

use std::string::String;

/// Constants.
const EAlreadyEquipedWeapon: u64 = 1;
const ENotEquipedWeapon: u64 = 2;

/// Structs.

/// A Hero should have a name, stamina, and an optional weapon.
public struct Hero has key, store {
    id: UID,
    name: String,
    stamina: u64,
    weapon: Option<Weapon>,
}

/// A Weapon should have a name and an attack value.
public struct Weapon has key, store {
    id: UID,
    name: String,
    attack: u64,
}

/// A shared object that acts as a registry for all the minted Hero objects.
/// Keeps a list with their Object ids, and a counter with the total number of minted Hero objects for convenience.
/// We can use a vector initially, but we should switch to a bag when making the app production-ready.
public struct HeroRegistry has key {
    id: UID,
    ids: vector<ID>,
    counter: u64,
}

/// Init function.

/// Creates a new HeroRegistry and shares it.
fun init(ctx: &mut TxContext) {}

/// Public functions.

/// Receives a name and stamina, creates a new Hero without a Weapon, and returns it.
/// Adds the id of the Hero to the HeroesRegistry object.
/// Increments the counter of the HeroesRegistry object by 1.
public fun new_hero(
    name: String,
    stamina: u64,
    registry: &mut HeroRegistry,
    ctx: &mut TxContext,
) {}

/// Receives a name and attack, creates a new Weapon, and returns it.
public fun new_weapon(name: String, attack: u64, ctx: &mut TxContext) {}

/// Receives a Hero and a Weapon, and equips the Weapon to the Hero.
/// If the Hero already has a Weapon, it should abort with EAlreadyEquipedWeapon.
/// In the scaffold we delete the weapon so that we don't get a build error.
public fun equip_weapon(hero: &mut Hero, weapon: Weapon) {
    let Weapon { id, name: _, attack: _ } = weapon;
    object::delete(id);
}

/// Receives a Hero, unequips the Weapon from the Hero, and returns the Weapon.
/// If the Hero does not have a Weapon, it should abort with ENotEquipedWeapon.
public fun unequip_weapon(hero: &mut Hero) {}

/// Accessors.

/// Receives a Hero and returns its name.
public fun hero_name(hero: &Hero): String {
    hero.name
}

/// Receives a Hero and returns its stamina.
public fun hero_stamina(hero: &Hero): u64 {
    hero.stamina
}

/// Receives a Hero and returns its Weapon.
public fun hero_weapon(hero: &Hero): &Option<Weapon> {
    &hero.weapon
}

/// Receives a Weapon and returns its name.
public fun weapon_name(weapon: &Weapon): String {
    weapon.name
}

/// Receives a Weapon and returns its attack value.
public fun weapon_attack(weapon: &Weapon): u64 {
    weapon.attack
}

/// Receives a HeroRegistry and returns the number of Hero objects minted.
public fun hero_registry_counter(registry: &HeroRegistry): u64 {
    registry.counter
}

public fun hero_registry_ids(registry: &HeroRegistry): vector<ID> {
    registry.ids
}

/// Test functions
#[test_only]
public(package) fun init_for_testing(ctx: &mut TxContext) {
    init(ctx);
}
