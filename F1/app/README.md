## Sui & Move Bootcamp <> End to End Decentralized Application | React App

This exercise is a simple React app that uses the smart contracts and the Typescript integration tests we have built in the previous steps.

The app will have three main views:

- Main view with latest created Heroes
- Create Hero view
- My Heroes view

In an approach similar to the section E2, we will be using the [@mysten/create-dapp](https://sdk.mystenlabs.com/dapp-kit/create-dapp) CLI tool to bootstrap a new React app with Vite, and integrate the [Sui dApp Kit](https://sdk.mystenlabs.com/dapp-kit) package.

## Instructions

### 1. Setup the app
- Run:

```
cd F1/app
npm create @mysten/dapp
cd <app-name>
pnpm i
pnpm run dev
```

#### 1st View: List with Created Heroes

In this view, we will utilise the shared object `HeroRegistry`, which keeps track of all the created Heroes.

1. Let's move on by creating a new React component, called `<HeroesList />`, that:
   - Uses the `useSuiClientQuery` hook with the `getObject` method to fetch the `HeroesRegistry` object
   - Uses the `showContent` option to fetch the fields of the object
   - Renders a link to a sui explorer for each Hero in the `ids` vector

Extension of this view as Homework:

> 2. Let's display the fields of each Hero NFT:
>
> - Add a call to the `multiGetObjects` RPC method, so that we can fetch the data of each Hero
> - Create a simple `<HeroCard />` component, that gets the fields of the Hero as arguments, and not just the id. You should use some simple CSS rules to display these data in a nice way.
>
> You will notice that the latest Heroes are currently displayed in the last positions of the list. Modifying our e2e implementation to display the latest Heroes at first will be implemented in next steps.

#### 2nd View: Create Hero

In this view, we will build the code for signing and executing a transaction that mints a Hero and transfers it to the transaction sender. We will utilize the TS scripts we prepared in the previous exercise `Typescript Integration Tests`.

1. Create a `<CreateHeroForm />` component, with a simple Button that mints the Hero, the Weapon, and equips the Weapon to the Hero:
   - For the inputs of the Transaction (`name` and `stamina` of the `Hero`, `name` and `attack` of the `Weapon`), you can initially use hard-coded values.
   - You shoud use the `mintHeroWithWeapon` TS script we built in the previous exercise to populate your `Transction` with commands.
   - You should use the [useSignAndExecuteTransaction](https://sdk.mystenlabs.com/dapp-kit/wallet-hooks/useSignAndExecuteTransaction) hook that is provided by the [Sui dApp Kit](https://sdk.mystenlabs.com/dapp-kit) to sign and execute the transaction
   - You should refresh the `HeroesList` to display the new Hero in case of successful execution, using `suiClient.waitForTransactioBlock` and `queryClient.invalidateQueries`

Extension of this view as Homework:

> 2.  Add some text and number HTML inputs, so that the user can specify the values of the `name` and `stamina` of the `Hero`, `name` and `attack` of the `Weapon`, instead of using the hard-coded ones.

#### 3rd View: My Heroes

The template app already includes a component that displays the IDs of the owned objects for the connected wallet. We will modify it to display only the Heroes.

1. Modify the existing `<OwnedObjects />` component to display only the Hero NFTs, by adding the `filter: { StructType: ... }` option we had seen in the previous exercises to the `getOwnedObjects` query
2. Modify the `CreateHeroForm`, so that the `<OwnedObjects />` list is also refreshed after minting successfully a Hero

Extension of this view as Homework:

> 3. Add the `showContent` option to the `getOwnedObjects` query of the `<OwnedObjects />` component, so that the fields of each Hero are returned
> 4. Re-use the `<HeroCard />` component that you built in the Homework part of the 1st view to display the details of each Hero, and not just the object id
