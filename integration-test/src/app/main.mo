import { print } "mo:base/Debug";
import Error "mo:base/Error";
import Principal "mo:base/Principal";
import ICRC2Batch "../../../src";
import ICRC2Interface "../../../src/ICRC2Interface";
import { principalFromText } "../../../test/TestUtils";

actor class App (icrc2LedgerCanisterId: Principal) {
  let icrc2Actor = ICRC2Batch.ICRC2BatchActor({
    icrc2LedgerCanisterId;
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

    await* icrc2Actor.icrc2_allowance_batch(allowanceArgs);
  };

  public func doICRC2Approvals() : async [{ #Ok : Nat; #Err : ICRC2Interface.ApproveError }] {
    let customer1 = principalFromText("customer1");
    let customer2 = principalFromText("customer2");
    let customer3 = principalFromText("customer3");
    let approveArgs : [ICRC2Interface.ApproveArgs] = [
      {
        fee = ?10;
        memo = null;
        from_subaccount = null;
        created_at_time = null;
        amount = 100;
        expected_allowance = ?500;
        expires_at = ?1_000_000;
        spender = { owner = customer1; subaccount = null };
      },
      {
        fee = ?10;
        memo = null;
        from_subaccount = null;
        created_at_time = null;
        amount = 100;
        expected_allowance = ?500;
        expires_at = ?1_000_000;
        spender = { owner = customer2; subaccount = null };
      },
      {
        fee = ?10;
        memo = null;
        from_subaccount = null;
        created_at_time = null;
        amount = 100;
        expected_allowance = ?500;
        expires_at = ?1_000_000;
        spender = { owner = customer3; subaccount = null };
      }
    ];

    await* icrc2Actor.icrc2_approve_batch(approveArgs);
  };

  public func doICRC2TransferFroms() : async [{ #Ok : Nat; #Err : ICRC2Interface.TransferFromError }] {
    let customer1 = principalFromText("customer1");
    let customer2 = principalFromText("customer2");
    let customer3 = principalFromText("customer3");
    let transferFromArgs : [ICRC2Interface.TransferFromArgs] = [
      {
        to = { owner = customer1; subaccount = null };
        fee = ?10;
        spender_subaccount = null;
        from = { owner = principalFromText("owner"); subaccount = null };
        memo = null;
        created_at_time = null;
        amount = 100;
      },
      {
        to = { owner = customer2; subaccount = null };
        fee = ?10;
        spender_subaccount = null;
        from = { owner = principalFromText("owner"); subaccount = null };
        memo = null;
        created_at_time = null;
        amount = 100;
      },
      {
        to = { owner = customer3; subaccount = null };
        fee = ?10;
        spender_subaccount = null;
        from = { owner = principalFromText("owner"); subaccount = null };
        memo = null;
        created_at_time = null;
        amount = 100;
      }
    ];

    await* icrc2Actor.icrc2_transfer_from_batch(transferFromArgs);
  };


}