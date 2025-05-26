## Sui & Move Bootcamp <> End to End Decentralized Application | Smart Contracts

This directory contains the smart contracts for the End to End Decentralized Application. We will need just a simple package, containing a single module, named `hero`.

### Quickstart

```
cd move/hero
sui move build
sui move test
```

You will notice multiple warnings (mainly about unused variables) in the [hero.move](./hero/sources/hero.move) file, and multiple errors in the [hero_tests.move](./hero/tests/hero_tests.move) file.
This is expected for now, and the aim of this exercise is to make all of them disappear!

### Project Structure

The source code is organized as follows:

```bash
move/
├── hero/
│ ├── sources/
│ │ ├── hero.move # The source code of the hero module
│ ├── tests/
│ ├── hero_tests.move # The unit tests for the hero module
├── Move.lock
├── Move.toml
├── README.md # Project documentation
```

### Instructions

- After running `sui move test`, you will notice that all of the tests are failing.
- The process is the following: Each function of the [hero.move](./hero/sources/hero.move) file corresponds to 1-2 tests of the [hero_tests.move](./hero/tests/hero_tests.move) file. We will iteratively implement the functions one by one, to make all of the tests pass.

#### 1. `init` function - `test_init` test

- You should add the implementation of the `init` function, following the in-code comments.
- You should make sure that the `test_init` function is the only one that is uncommented for now.
- After implementing the function, run `sui move test`. The `test_init` test should pass.

#### 2. `new_hero` function - `test_new_hero` test

- Same as above, update the `new_hero` function, following the in-code comments.
- Uncomment the `test_new_hero` test.
- You should run `sui move test` and see everything succeeding.

#### 3. `new_weapon` function - `test_new_weapon` test

- Same as above, update the `new_weapon` function following the in-code comments.
- Uncomment the `test_new_weapon` test.
- You should run `sui move test` and see everything succeeding.

#### 4. `equip_weapon` function - `test_equip_weapon` & `test_equip_weapon_already_equiped` tests

- Same as above, update the `equip_weapon` function following the in-code comments.
- Uncomment the `test_equip_weapon` and `test_equip_weapon_already_equiped` tests.
- You should run `sui move test` and see everything succeeding.

#### 5. `unequip_weapon` function - `test_unequip_weapon` & `test_unequip_weapon_not_equiped` tests

- Same as above, update the `unequip_weapon` function following the in-code comments.
- Uncomment the `test_unequip_weapon` and `test_unequip_weapon_not_equiped` test.
- You should run `sui move test` and see everything succeeding.

#### Publish the Package on testnet

Now that all of the Move tests pass, we are finally ready to publish our package on testnet!

- You should run the following commands:

```
sui client switch --env <your-cli-alias-for-testnet>
sui client publish
```

- Keep the `txDigest` of the publish transaction's output in a note, and get ready jump into the Typescript parts of the exercise!
