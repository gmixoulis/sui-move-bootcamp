## Sui & Move Bootcamp <> Integrating an Indexer in a Dapp

This is an exercise showcasing how we can integrate a custom Sui indexer in a Dapp. We are going to use the `indexer-js` we built in the previous `J1` exercise, and build a simple UI to fetch and display the Hero NFTs that are stored in the DB.

The app will have a simple view, listing the Hero NFTs, as they are returned by the REST API of the exercise `J1`.

### Instructions

#### Start and test the REST API

First of all, let's validate that the `indexer-js` and the REST API of the previous exercise are running:

1. Cd into the [J1/indexer-js/hero-js-indexer](../J1/indexer-js/hero-js-indexer/) directory, and in addition to the previous steps, run the following command to start the development server of the REST API locally:

```
pnpm run api:dev
```

2. Navigate to the url `http://localhost:3000/events/hero/hero-event` using a web browser, and you should be getting a response similar to this one:

```
[
    {
        "dbId": "e50b6a2c-38d5-4313-a7be-db31ff3e3e3f",
        "hero_id": "0x25b0540f86969c956de612d319661373726e225c6c68eb895ecc563cbefeec6c",
        "hero_name": "Hero 1",
        "owner": "0xe3a3cb104aca24a96af7c384d98a5bf185d03309d747830e70fd650817d55c00",
        "timestamp": "1745418441505"
    },
    {
        "dbId": "72d9eb6b-2176-45a1-b68f-0c92393ac448",
        "hero_id": "0x0308f768c0f2007ce9f024623783b8d9d4dd5b6aaadb3ae02a2736cd32ac0b1e",
        "hero_name": "Hero 1",
        "owner": "0xe3a3cb104aca24a96af7c384d98a5bf185d03309d747830e70fd650817d55c00",
        "timestamp": "1745418569269"
    }
]
```

#### Build the UI

Now, we should be ready to build a simple UI, to fetch and display this data.

1. In an approach similar to the section E2, we will be using the [@mysten/create-dapp](https://sdk.mystenlabs.com/dapp-kit/create-dapp) CLI tool to bootstrap a new React app with Vite, and integrate the [Sui dApp Kit](https://sdk.mystenlabs.com/dapp-kit) package.

   1. `pnpm create @mysten/create-dapp`
   2. `cd <app-name>`
   3. `pnpm i`
   4. `pnpm run dev`

2. Create a `<HeroesList />` component and import it in the `App.tsx` file. We can render it just under the `<WalletStatus />` component

3. Update the `<HeroesList />` component to make a simple HTTP request to the `hero-event` endpoint, parse and display the response
