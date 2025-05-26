## Sui & Move Bootcamp <> End to End Decentralized Application | Typescript Integration Tests

This directory contains a simple Node project with Typescript. We will add here the integration tests for the e2e application.

### Useful Links

- [Programmable Transaction Blocks](https://docs.sui.io/concepts/transactions/prog-txn-blocks)
- [Sui TS SDK | Programmable Transaction Blocks](https://sdk.mystenlabs.com/typescript/transaction-building/basics)
- [Sui TS SDK | Passing inputs to a transaction](https://sdk.mystenlabs.com/typescript/transaction-building/basics#passing-inputs-to-a-transaction)

### Quickstart

- Create a `.env` file in the [typescript](./) directory, following the structure of the [.env.example](./.env.example):

```
SUI_NETWORK=https://rpc.testnet.sui.io:443
PACKAGE_ID=
HEROES_REGISTRY_ID=
USER_SECRET_KEY=
```

In order to find the values these env variables, you can find the publish transaction of the [move](../move/) part in a Sui explorer, and detect:

- The PACKAGE_ID under the `Object Changes` list
- The HEROES_REGISTRY_ID under the `Object Changes` list

For the `USER_SECRET_KEY` variable, any valid secret key (in base64 format), with the corresponding account owning some gas coins, will do the work.

- Run the following commands:

```
cd typescript
npm i
npm run test
```

### Instructions

- Notice that all of the tests in the `e2e.test.ts` test file are failing:

  - `Transaction Status`: Validates that the status of the transfer transaction is "success".
  - `Created Hero`: Validates that a Hero NFT is created.
  - `Hero is equiped with a Weapon`: Validates that except for the Hero NFT, a Weapon NFT was also created, and that this Weapon NFT is wrapped inside a `Hero` NFT
  - `Heroes registry`: Validates that the Heroes registry already contains a few registrered Hero IDs

### 1, Mint the Hero, the Weapon, and Equip it

- Modify the [mintHeroWithWeapon.ts](./src/helpers/mintHeroWithWeapon.ts) function, by adding the implementation:
  - You should use the `tx.moveCall` method for making custom move calls.
  - You should use the `new_hero` and `new_weapon` functions of the [hero](../move/hero/sources/hero.move) module to mint the Hero and the Weapon objects.
  - You should use the `equip_weapon` function of the [hero](../move/hero/sources/hero.move) module to equip the Weapon object to the hero.
  - Last but not least, do not forget to transfer the Hero object to an address, since the Hero object is an actual NFT that does not have the Drop ability, so it must be "consumed" somehow!!

### 2. Parse the IDs of the created objects

- Modify the [parseCreatedObjectsIds.ts](./src/helpers/parseCreatedObjectIds.ts) function, so that you can extract both the Hero's and the Weapon's object ID:
  - You should filter the object changes by `type === "created"`.
  - You can use some smart type assertions to get access to the `objectType` field in a clean way.
  - Filter by the corresponding `objectType` to keep only the objects you are interested in.
- Do you notice anything that you didn't expect? Are both of the objects returned in the created objects array?

### 3. Parse the Weapon that is attached to a specific Hero

- Modify the [getWeaponIdOfHero.ts](./src/helpers/getWeaponIdOfHero.ts) function, so that you can extract the Weapon Id of a Hero:

  - You should use the `suiClient.getObject` method, including the corresponding `option` to get access to the fields of the Hero object.
  - Parse the nested `fields` to get access to the attached Weapon's ID.

### 4. Find all the created Heroes IDs in the HeroesRegistry

- Modify the function [getHeroesRegistry](./src/helpers/getHeroesRegistry.ts), so that you can get access to the contents of the HeroesRegistry object:
  - You should use the `suiClient.getObject` method, including the corresponding `option` to get access to the fields object.
  - Parse the nested `fields` to get access to the `ids` vector, and the `counter`.
