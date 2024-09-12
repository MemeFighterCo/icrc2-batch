import Principal "mo:base/Principal";
import ICRC2Interface "ICRC2Interface";
import Buffer "mo:base/Buffer";
import { print } "mo:base/Debug";
import ICRCCall "../internal/ICRCCall";
import { BATCH_SIZE_LIMIT } "../internal/Constants";

module {
  /// Class capable of batching ICRC2 transactions to ICRC2 actor canisters
  public class ICRC2BatchActor({
    icrc2LedgerCanisterId: Principal;
    batchSize: Nat;
  }) {
    // limit of 100 at a time
    var limitedBatchSize = if (batchSize > BATCH_SIZE_LIMIT) {
      print("You passed in a batch size of " # debug_show(batchSize) # ", but the current max batch size is " # debug_show(BATCH_SIZE_LIMIT) # ". Defaulting to a batch size of " # debug_show(BATCH_SIZE_LIMIT) # ".");
      BATCH_SIZE_LIMIT;
    } else { batchSize };
    let icrc2Actor = actor(Principal.toText(icrc2LedgerCanisterId)) : ICRC2Interface.ICRC2Actor;

    /// Get the ICRC2 actor canister ID
    public func getICRC2ActorCanisterId() : Principal {
      return icrc2LedgerCanisterId;
    };

    /// Get the current batch size
    public func getBatchSize() : Nat {
      return limitedBatchSize;
    };

    /// Set the batch size
    public func setBatchSize(newBatchSize: Nat) : () {
      limitedBatchSize := if (newBatchSize > 100) {
        print("You passed in a batch size of " # debug_show(newBatchSize) # ", but the current max batch size is 100. Defaulting to a batch size of 100.");
        100;
      } else { newBatchSize };
    };

    /// Get the allowance for a spender on an account
    public func icrc2_allowance(args: ICRC2Interface.AllowanceArgs) : async* ICRC2Interface.Allowance {
      await* ICRCCall.icrc2_allowance(icrc2Actor, args);
    };

    /// Approve a spender to spend a certain amount on behalf of the owner
    public func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async* { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
      await* ICRCCall.icrc2_approve(icrc2Actor, args);
    };

    /// Transfer an approved amount from one account to another
    public func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async* { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
      await* ICRCCall.icrc2_transfer_from(icrc2Actor, args);
    };

    /// Batch get allowances provided a list of allowance arguments
    /// Note: If one call fails, the entire batch will fail
    public func icrc2_allowance_batch(allowances: [ICRC2Interface.AllowanceArgs]) : async* [ICRC2Interface.Allowance] {
      await* ICRCCall.wrapped_icrc2_allowance_batch(
        icrc2Actor,
        limitedBatchSize,
        allowances,
      );
    };

    /// Batch approval provided a list of approval arguments
    /// Note: If one call traps, the entire batch will fail (expected errors handled gracefully by the variant type) 
    public func icrc2_approve_batch(approvals: [ICRC2Interface.ApproveArgs]) : async* [{ #Ok : Nat; #Err : ICRC2Interface.ApproveError }] {
      await* ICRCCall.wrapped_icrc2_approve_batch(
        icrc2Actor,
        limitedBatchSize,
        approvals,
      );
    };

    /// Batch transfer_from provided a list of transfer_from arguments
    /// Note: If one call traps, the entire batch will fail (expected errors handled gracefully by the variant type) 
    public func icrc2_transfer_from_batch(transfers: [ICRC2Interface.TransferFromArgs]) : async* [{ #Ok : Nat; #Err : ICRC2Interface.TransferFromError }] {
      await* ICRCCall.wrapped_icrc2_transfer_from_batch(
        icrc2Actor,
        limitedBatchSize,
        transfers,
      );
    };
  };
}