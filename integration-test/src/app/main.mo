//import MockICRC2Canister "canister:mock-icrc2-canister";
import Principal "mo:base/Principal";
import ICRC2Batch "../../../src";
import ICRC2Interface "../../../src/ICRC2Interface";
import { principalFromText } "../../../test/TestUtils";

actor {
  let icrc2Actor = ICRC2Batch.ICRC2BatchActor({
    icrc2LedgerCanisterId = Principal.fromActor(MockICRC2Canister);
    batchSize = 100;
  });

  public func getAllICRC2Allowances() : async [ICRC2Interface.Allowance] {
    let allowanceArgs : [ICRC2Interface.AllowanceArgs] = [
      { 
        account = { owner = principalFromText("owner"); subaccount = null };
        spender = { owner = principalFromText("spender1"); subaccount = null };
      },
      { 
        account = { owner = principalFromText("owner"); subaccount = null };
        spender = { owner = principalFromText("spender2"); subaccount = null };
      },
      { 
        account = { owner = principalFromText("owner"); subaccount = null };
        spender = { owner = principalFromText("spender3"); subaccount = null };
      }
    ];

    let result = await* icrc2Actor.icrc2_allowance_batch(allowanceArgs);
    //result;
    [{ allowance = 100; expires_at = null }]
  };

}