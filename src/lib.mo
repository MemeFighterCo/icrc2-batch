import ICRC2Actor "ICRC2Actor";
import ICRC2Interface "ICRC2Interface";
import WrappedIcrc2Actor "../internal/WrappedICRC2Actor";

module {
	/// Class capable of batching ICRC2 transactions to ICRC2 actor canisters
	public let ICRC2BatchActor = ICRC2Actor.ICRC2BatchActor;

	/// Get the allowance for a spender on an account
	public func icrc2_allowance(icrc2Actor: ICRC2Interface.ICRC2Actor, args: ICRC2Interface.AllowanceArgs) : async* ICRC2Interface.Allowance {
		return await* WrappedIcrc2Actor.icrc2_allowance(icrc2Actor, args);
	};

	/// Approve a spender to spend a certain amount on behalf of the owner
	public func icrc2_approve(icrc2Actor: ICRC2Interface.ICRC2Actor, args: ICRC2Interface.ApproveArgs) : async* { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
		return await* WrappedIcrc2Actor.icrc2_approve(icrc2Actor, args);
	};

	/// Transfer an approved amount from one account to another
	public func icrc2_transfer_from(icrc2Actor: ICRC2Interface.ICRC2Actor, args: ICRC2Interface.TransferFromArgs) : async* { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
		return await* WrappedIcrc2Actor.icrc2_transfer_from(icrc2Actor, args);
	};

	/// Batch get allowances provided a list of allowance arguments
	/// Note: If one call fails, the entire batch will fail
	public func icrc2_allowance_batch(
		icrc2Actor: ICRC2Interface.ICRC2Actor,
		batchSize: Nat,
		allowances: [ICRC2Interface.AllowanceArgs]
	) : async* [ICRC2Interface.Allowance] {
		return await* WrappedIcrc2Actor.wrapped_icrc2_allowance_batch(
			icrc2Actor,
			batchSize,
			allowances,
			WrappedIcrc2Actor.icrc2_allowance
		);
	};

	/// Batch approval provided a list of approval arguments
	/// Note: If one call fails, the entire batch will fail
	public func icrc2_approve_batch(
		icrc2Actor: ICRC2Interface.ICRC2Actor,
		batchSize: Nat,
		approvals: [ICRC2Interface.ApproveArgs]
	) : async* [{ #Ok : Nat; #Err : ICRC2Interface.ApproveError }] {
		return await* WrappedIcrc2Actor.wrapped_icrc2_approve_batch(
			icrc2Actor,
			batchSize,
			approvals,
			WrappedIcrc2Actor.icrc2_approve
		);
	};

	/// Batch transfer provided a list of transfer arguments
	/// Note: If one call fails, the entire batch will fail
	public func icrc2_transfer_from_batch(
		icrc2Actor: ICRC2Interface.ICRC2Actor,
		batchSize: Nat,
		transfers: [ICRC2Interface.TransferFromArgs]
	) : async* [{ #Ok : Nat; #Err : ICRC2Interface.TransferFromError }] {
		return await* WrappedIcrc2Actor.wrapped_icrc2_transfer_from_batch(
			icrc2Actor,
			batchSize,
			transfers,
			WrappedIcrc2Actor.icrc2_transfer_from
		);
	};
};