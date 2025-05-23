import { SuiClient, SuiParsedData, SuiTransactionBlockResponse } from '@mysten/sui/client';
import { Transaction } from '@mysten/sui/transactions';
import { Keypair } from '@mysten/sui/cryptography';
import { deriveDynamicFieldID } from '@mysten/sui/utils';
import { bcs } from '@mysten/sui/bcs';
import { PublishSingleton } from './publish';

type KioskListingFields = {
    id: {
        id: string;
    },
    name: {
        type: "0x2::kiosk::Listing";
        fields: {
            id: string;
            is_exclusive: boolean
        };
    },
    value: string;
};
type KioskOwnerCapFields = {
    for: string,
    id: {
        id: string
    }
}
type KioskOwnerCapParsedData = Extract<SuiParsedData, { dataType: 'moveObject' }> & { fields: KioskOwnerCapFields };
type KioskListingParsedData = Extract<SuiParsedData, { dataType: 'moveObject' }> & { fields: KioskListingFields };

export async function createKiosk(client: SuiClient, signer: Keypair): Promise<SuiTransactionBlockResponse> {
    const transaction = new Transaction();

    // Task: Create a Kiosk

    const resp = await client.signAndExecuteTransaction({
        transaction,
        signer,
        options: {
            showEffects: true,
            showObjectChanges: true,
        }
    });
    if (resp.effects?.status.status !== 'success') {
        throw new Error(`Something went wrong creating kiosk:\n${JSON.stringify(resp, null, 2)}`)
    }
    await client.waitForTransaction({ digest: resp.digest });
    return resp;
}

export async function placeAndListInKiosk({ client, signer, kiosk, swordId, price }: {
    client: SuiClient;
    signer: Keypair;
    kiosk?: {
        id: string;
        capId: string;
    };
    swordId: string;
    price: number;
}): Promise<SuiTransactionBlockResponse> {

    // Find owned kiosk if not given
    if (!kiosk) {
        let resp = await client.getOwnedObjects({
            owner: signer.toSuiAddress(),
            filter: {
                StructType: "0x2::kiosk::KioskOwnerCap"
            },
            limit: 1,
            options: {
                showContent: true,
            },
        });
        const data = resp.data.at(0)?.data;
        if (!data) {
            throw new Error(`Could not find a kiosk for ${signer.toSuiAddress()}`);
        }
        const content = data.content as KioskOwnerCapParsedData;
        kiosk = {
            id: content.fields.for,
            capId: data.objectId
        };
    }

    const transaction = new Transaction();

    // Task: Place and list item in kiosk

    const resp = await client.signAndExecuteTransaction({
        transaction,
        signer,
        options: {
            showEffects: true,
            showObjectChanges: true
        }
    });
    if (resp.effects?.status.status !== 'success') {
        throw new Error(`Something went wrong placing and listing:\n${JSON.stringify(resp, null, 2)}`)
    }
    await client.waitForTransaction({ digest: resp.digest });
    return resp;
}

export async function purchase({ client, signer, fromKioskObjectId, swordId, price }: {
    client: SuiClient;
    signer: Keypair;
    fromKioskObjectId: string;
    swordId: string;
    price?: number;
}): Promise<SuiTransactionBlockResponse> {
    // In case price is missing, find the kiosk Listing
    if (!price) {
        const dfKey = bcs.struct(
            '0x2::kiosk::Listing',
            { id: bcs.Address, is_exclusive: bcs.bool() }
        ).serialize({
            id: swordId,
            is_exclusive: false
        }).toBytes();
        const dfId = deriveDynamicFieldID(fromKioskObjectId, '0x2::kiosk::Listing', dfKey);

        const dfResp = await client.getObject({
            id: dfId,
            options: {
                showContent: true
            }
        });
        if (!dfResp.data) {
            throw new Error(`Could not find Listing for item ${swordId} under kiosk ${fromKioskObjectId}`);
        }
        const content = dfResp.data.content as KioskListingParsedData;
        price = parseInt(content.fields.value);
    }

    const transaction = new Transaction();

    // Task: implement the necessary move-calls to purchase the sword

    const resp = await client.signAndExecuteTransaction({
        transaction,
        signer,
        options: {
            showEffects: true,
            showObjectChanges: true,
        },
    });
    if (resp.effects?.status.status !== 'success') {
        throw new Error(`Something went wrong purchasing:\n${JSON.stringify(resp, null, 2)}`)
    }
    await client.waitForTransaction({ digest: resp.digest });
    return resp;
}

