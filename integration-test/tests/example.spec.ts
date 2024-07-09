import { describe, beforeEach, afterEach, it, expect, inject } from 'vitest';
// Import generated types for your canister
import { resolve } from 'path';
import { idlFactory as MockICRC2CanisterIDL } from "../src/declarations/mock-icrc2-canister/mock-icrc2-canister.did.js";
import { _SERVICE as MockICRC2CanisterService } from '../src/declarations/mock-icrc2-canister/mock-icrc2-canister.did.js';
import { idlFactory as AppIDL } from '../src/declarations/app/app.did.js';
import { _SERVICE as AppService } from '../src/declarations/app/app.did.js';
import { Actor, PocketIc } from '@hadronous/pic';
import { Principal } from '@dfinity/principal';


// Define the path to your canister's WASM file
export const MOCK_ICRC2_WASM_PATH = resolve(".dfx", "local", "canisters", "mock-icrc2-canister", "mock-icrc2-canister.wasm");
export const APP_WASM_PATH = resolve(".dfx", "local", "canisters", "app", "app.wasm");

// The `describe` function is used to group tests together
// and is completely optional.
describe('Test suite name', () => {
  // Define variables to hold our PocketIC instance, canister ID,
  // and an actor to interact with our canister.
  let pic: PocketIc;
  let mockICRC2Actor: Actor<MockICRC2CanisterService>;
  let appActor: Actor<AppService>;

  let mockICRC2CanisterId: Principal;
  let appCanisterId: Principal;

  // The `beforeEach` hook runs before each test.
  //
  // This can be replaced with a `beforeAll` hook to persist canister
  // state between tests.
  beforeEach(async () => {
    // create a new PocketIC instance
    pic = await PocketIc.create(inject('PIC_URL'));

    // Setup the canister and actor
    const mockICRC2Fixture = await pic.setupCanister<MockICRC2CanisterService>({
      idlFactory: MockICRC2CanisterIDL,
      wasm: MOCK_ICRC2_WASM_PATH,
    });

    // Save the actor and canister ID for use in tests
    mockICRC2Actor = mockICRC2Fixture.actor;
    mockICRC2CanisterId = mockICRC2Fixture.canisterId;

    // Setup the app canister and actor
    const appFixture = await pic.setupCanister<AppService>({
      idlFactory: AppIDL,
      wasm: APP_WASM_PATH,
    });

    // Save the actor and canister ID for use in tests
    appActor = appFixture.actor;
    appCanisterId = appFixture.canisterId;
  });

  // The `afterEach` hook runs after each test.
  //
  // This should be replaced with an `afterAll` hook if you use
  // a `beforeAll` hook instead of a `beforeEach` hook.
  afterEach(async () => {
    // tear down the PocketIC instance
    await pic.tearDown();
  });

  // The `it` function is used to define individual tests
  it("something", () => {
    expect(1).toEqual(1);
  }) ;

  it('should do something cool', async () => {
    const response = await appActor.getAllICRC2Allowances();
    console.log("response: ", JSON.stringify(response, (_, v) => {
      if (v instanceof Principal) return v.toText();
      if (typeof v === "bigint") return v.toString();
      return v;
    }));
    //const response = await actor.do_something_cool();

    //expect(response).toEqual('cool');
  });
});