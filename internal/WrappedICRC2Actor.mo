import Principal "mo:base/Principal";
import { BATCH_SIZE_LIMIT } "Constants";
import ICRC2Interface "../src/ICRC2Interface";
import Buffer "mo:base/Buffer";
import { print } "mo:base/Debug";

module {

  /// Get the allowance for a spender on an account
  public func icrc2_allowance(icrc2Actor : ICRC2Interface.ICRC2Actor, args: ICRC2Interface.AllowanceArgs) : async* ICRC2Interface.Allowance {
    return await icrc2Actor.icrc2_allowance(args);
  };

  /// Approve a spender to spend a certain amount on behalf of the owner
  public func icrc2_approve(icrc2Actor : ICRC2Interface.ICRC2Actor, args: ICRC2Interface.ApproveArgs) : async* { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
    return await icrc2Actor.icrc2_approve(args);
  };

  /// Transfer an approved amount from one account to another
  public func icrc2_transfer_from(icrc2Actor : ICRC2Interface.ICRC2Actor, args: ICRC2Interface.TransferFromArgs) : async* { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
    return await icrc2Actor.icrc2_transfer_from(args);
  };

  /// Batch get allowances provided a list of allowance arguments
  public func wrapped_icrc2_allowance_batch(
    icrc2Actor : ICRC2Interface.ICRC2Actor,
    passedBatchSize: Nat,
    allowances: [ICRC2Interface.AllowanceArgs],
    allowanceFunction : (ICRC2Interface.ICRC2Actor, ICRC2Interface.AllowanceArgs) -> async* ICRC2Interface.Allowance
  ) : async* [ICRC2Interface.Allowance] {
    let batchSize = if (passedBatchSize > BATCH_SIZE_LIMIT) {
      print("You passed in a batch size of " # debug_show(passedBatchSize) # ", but the current max batch size is " # debug_show(BATCH_SIZE_LIMIT) # ". Defaulting to a batch size of " # debug_show(BATCH_SIZE_LIMIT) # ".");
      BATCH_SIZE_LIMIT;
    } else { passedBatchSize };
    let allowanceFutures = Buffer.Buffer<async* ICRC2Interface.Allowance>(batchSize);
    let allowanceResults = Buffer.Buffer<ICRC2Interface.Allowance>(allowances.size());

    for (allowanceArgs in allowances.vals()) {
      print("allowanceArgs: " # debug_show(allowanceArgs));
      allowanceFutures.add(allowanceFunction(icrc2Actor, allowanceArgs));
      if (allowanceFutures.size() >= batchSize) {
        for (allowanceFuture in allowanceFutures.vals()) {
          allowanceResults.add(await* allowanceFuture);
        };
        allowanceFutures.clear();
      };
    };

    // Add any remaining results
    for (allowanceFuture in allowanceFutures.vals()) {
      allowanceResults.add(await* allowanceFuture);
    };

    Buffer.toArray(allowanceResults);
  };

  /// Batch approval provided a list of approval arguments
  public func wrapped_icrc2_approve_batch(
    icrc2Actor : ICRC2Interface.ICRC2Actor,
    passedBatchSize: Nat,
    approvals: [ICRC2Interface.ApproveArgs],
    approveFunction : (ICRC2Interface.ICRC2Actor, ICRC2Interface.ApproveArgs) -> async* { #Ok : Nat; #Err : ICRC2Interface.ApproveError }
  ) : async* [{ #Ok : Nat; #Err : ICRC2Interface.ApproveError }] {
    let batchSize = if (passedBatchSize > BATCH_SIZE_LIMIT) {
      print("You passed in a batch size of " # debug_show(passedBatchSize) # ", but the current max batch size is " # debug_show(BATCH_SIZE_LIMIT) # ". Defaulting to a batch size of " # debug_show(BATCH_SIZE_LIMIT) # ".");
      BATCH_SIZE_LIMIT;
    } else { passedBatchSize };
    let approvalFutures = Buffer.Buffer<async* { #Ok : Nat; #Err : ICRC2Interface.ApproveError }>(batchSize);
    let approvalResults = Buffer.Buffer<{ #Ok : Nat; #Err : ICRC2Interface.ApproveError }>(approvals.size());

    for (approvalArgs in approvals.vals()) {
      approvalFutures.add(approveFunction(icrc2Actor, approvalArgs));
      if (approvalFutures.size() >= batchSize) {
        for (approvalFuture in approvalFutures.vals()) {
          approvalResults.add(await* approvalFuture);
        };
        approvalFutures.clear();
      };
    };

    // Add any remaining results
    for (approvalFuture in approvalFutures.vals()) {
      approvalResults.add(await* approvalFuture);
    };

    Buffer.toArray(approvalResults);
  };

  type TransferFromsFunction = [ICRC2Interface.TransferFromArgs] -> async* [{ #Ok : Nat; #Err : ICRC2Interface.TransferFromError }];
  /// Batch transfer_from provided a list of transfer_from arguments
  public func wrapped_icrc2_transfer_from_batch(
    icrc2Actor : ICRC2Interface.ICRC2Actor,
    passedBatchSize : Nat,
    transfers: [ICRC2Interface.TransferFromArgs],
    transferFunction : (ICRC2Interface.ICRC2Actor, ICRC2Interface.TransferFromArgs) -> async* { #Ok : Nat; #Err : ICRC2Interface.TransferFromError }
  ) : async* [{ #Ok : Nat; #Err : ICRC2Interface.TransferFromError }] {
    let batchSize = if (passedBatchSize > BATCH_SIZE_LIMIT) {
      print("You passed in a batch size of " # debug_show(passedBatchSize) # ", but the current max batch size is " # debug_show(BATCH_SIZE_LIMIT) # ". Defaulting to a batch size of " # debug_show(BATCH_SIZE_LIMIT) # ".");
      BATCH_SIZE_LIMIT;
    } else { passedBatchSize };
    let transferFutures = Buffer.Buffer<async* { #Ok : Nat; #Err : ICRC2Interface.TransferFromError }>(batchSize);
    let transferResults = Buffer.Buffer<{ #Ok : Nat; #Err : ICRC2Interface.TransferFromError }>(transfers.size());

    for (transferArgs in transfers.vals()) {
      transferFutures.add(transferFunction(icrc2Actor, transferArgs));
      if (transferFutures.size() >= batchSize) {
        for (transferFuture in transferFutures.vals()) {
          transferResults.add(await* transferFuture);
        };
        transferFutures.clear();
      };
    };

    // Add any remaining results
    for (transferFuture in transferFutures.vals()) {
      transferResults.add(await* transferFuture);
    };

    Buffer.toArray(transferResults);
  };
}