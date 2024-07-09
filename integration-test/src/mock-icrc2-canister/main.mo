import ICRC2Interface "../../../src/ICRC2Interface";

actor MockICRC2Actor {
  public query func icrc2_allowance(_: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
    return { allowance = 100; expires_at = null };
  };

  public shared func icrc2_approve(_: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
    return #Ok(100);
  };

  public shared func icrc2_transfer_from(_: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
    return #Ok(100);
  };
}