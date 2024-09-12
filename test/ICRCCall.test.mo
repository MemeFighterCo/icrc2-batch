import Option "mo:base/Option";
import { it; its; itsp; describe; Suite } "mo:testing/SuiteState";
import { principalFromText } = "TestUtils";
import ICRC2Interface "../src/ICRC2Interface";
import ICRCCall "../internal/ICRCCall";

let customer1 = principalFromText("customer1");
let customer2 = principalFromText("customer2");

let s = Suite();


await* s.run([
  describe(
    "icrc2_allowance",
    [
      itsp(
        "calls the icrc2_allowance function with the expected args",
        func(state: (), print : (t: Text) -> ()) : async* Bool {
          var areArgsCorrect = false;
          let icrc2Actor : ICRC2Interface.ICRC2Actor = actor {
            public shared func icrc2_allowance({ account; spender }: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
              areArgsCorrect := 
                account.owner == customer1 and Option.isNull(account.subaccount) and
                spender.owner == customer2 and Option.isNull(spender.subaccount);
              return { allowance = 100; expires_at = null };
            };
            public shared func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
              return #Ok(0);
            };
            public shared func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
              return #Ok(0);
            };
          };

          let result = await* ICRCCall.icrc2_allowance(
            icrc2Actor,
            {
              account = { owner = customer1; subaccount = null };
              spender = { owner = customer2; subaccount = null };
            }
          );

          if (result != { allowance = 100; expires_at = null }) {
            print("Expected { allowance = 100; expires_at = null }, got " # debug_show(result));
            return false;
          };

          areArgsCorrect;
        }
      ),
    ],
  ),
  describe(
    "icrc2_approve",
    [
      itsp(
        "calls the icrc2_approve function with the expected args",
        func(state: (), print : (t: Text) -> ()) : async* Bool {
          var areArgsCorrect = false;
          let icrc2Actor : ICRC2Interface.ICRC2Actor = actor {
            public shared func icrc2_allowance({ account; spender }: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
              return { allowance = 100; expires_at = null };
            };
            public shared func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
              areArgsCorrect := 
                args.fee == ?10 and
                args.memo == null and
                args.from_subaccount == null and
                args.amount == 100 and
                args.expected_allowance == ?500 and
                args.expires_at == ?1_000_000 and
                args.spender.owner == customer2 and Option.isNull(args.spender.subaccount);
              return #Ok(0);
            };
            public shared func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
              return #Ok(0);
            };
          };

          let result = await* ICRCCall.icrc2_approve(
            icrc2Actor,
            {
              fee = ?10;
              memo = null;
              from_subaccount = null;
              created_at_time = null;
              amount = 100;
              expected_allowance = ?500;
              expires_at = ?1_000_000;
              spender = { owner = customer2; subaccount = null };
            }
          );

          if (result != #Ok(0)) {
            print("Expected #Ok(0), got " # debug_show(result));
            return false;
          };

          areArgsCorrect;
        }
      )
    ]
  ),
  describe(
    "icrc2_transfer_from",
    [
      itsp(
        "calls the icrc2_transfer_from function with the expected args",
        func(state: (), print : (t: Text) -> ()) : async* Bool {
          var areArgsCorrect = false;
          let icrc2Actor : ICRC2Interface.ICRC2Actor = actor {
            public shared func icrc2_allowance({ account; spender }: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
              return { allowance = 100; expires_at = null };
            };
            public shared func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
              return #Ok(0);
            };
            public shared func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
              areArgsCorrect := 
                args.to.owner == customer1 and Option.isNull(args.to.subaccount) and
                args.fee == ?10 and
                args.spender_subaccount == null and
                args.from.owner == customer2 and Option.isNull(args.from.subaccount) and
                args.memo == null and
                args.created_at_time == ?1_000_000 and
                args.amount == 100;
              return #Ok(0);
            };
          };

          let result = await* ICRCCall.icrc2_transfer_from(
            icrc2Actor,
            {
              to = { owner = customer1; subaccount = null };
              fee = ?10;
              spender_subaccount = null;
              from = { owner = customer2; subaccount = null };
              memo = null;
              created_at_time = ?1_000_000;
              amount = 100;
            }
          );

          if (result != #Ok(0)) {
            print("Expected #Ok(0), got " # debug_show(result));
            return false;
          };

          areArgsCorrect;
        }
      )
    ]
  ),
  describe(
    "wrapped_icrc2_allowance_batch",
    [
      itsp(
        "calls the allowanceFunction multiple times with the expected args",
        func(state: (), print : (t: Text) -> ()) : async* Bool {
          var areFirstCallArgsCorrect = false;
          var areSecondCallArgsCorrect = false;
          let icrc2Actor : ICRC2Interface.ICRC2Actor = actor {
            var i = 0;
            public shared func icrc2_allowance({ account; spender }: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
              // This should never get called
              // each time this is called, increments i
              i += 1;
              if (i == 1) {
                areFirstCallArgsCorrect := 
                  account.owner == customer1 and Option.isNull(account.subaccount) and
                  spender.owner == customer2 and Option.isNull(spender.subaccount);
              } else if (i == 2) {
                areSecondCallArgsCorrect := 
                  account.owner == customer2 and Option.isNull(account.subaccount) and
                  spender.owner == customer1 and Option.isNull(spender.subaccount);
              };
              { allowance = 100 * i; expires_at = null };
            };
            public shared func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
              return #Ok(0);
            };
            public shared func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
              return #Ok(0);
            };
          };

          let allowances = await* ICRCCall.wrapped_icrc2_allowance_batch(
            icrc2Actor,
            2,
            [
              {
                account = { owner = customer1; subaccount = null };
                spender = { owner = customer2; subaccount = null };
              },
              {
                account = { owner = customer2; subaccount = null };
                spender = { owner = customer1; subaccount = null };
              }
            ],
            //allowanceFunction
          );

          if (allowances != [{ allowance = 100; expires_at = null }, { allowance = 200; expires_at = null }]) {
            print("Expected [{ allowance = 100; expires_at = null }, { allowance = 200; expires_at = null }], got " # debug_show(allowances));
            return false;
          };

          areFirstCallArgsCorrect and areSecondCallArgsCorrect;
        }
      )
    ]
  ),
  describe(
    "wrapped_icrc2_approve_batch",
    [
      itsp(
        "calls the approveFunction multiple times with the expected args",
        func(state: (), print : (t: Text) -> ()) : async* Bool {
          var areFirstCallArgsCorrect = false;
          var areSecondCallArgsCorrect = false;
          let icrc2Actor : ICRC2Interface.ICRC2Actor = actor {
            var i = 0;
            public shared func icrc2_allowance({ account; spender }: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
              return { allowance = 100; expires_at = null };
            };
            public shared func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
              // each time this is called, increments i
              i += 1;
              if (i == 1) {
                areFirstCallArgsCorrect := 
                  args.fee == ?10 and
                  args.memo == null and
                  args.from_subaccount == null and
                  args.amount == 100 and
                  args.expected_allowance == ?500 and
                  args.expires_at == ?1_000_000 and
                  args.spender.owner == customer2 and Option.isNull(args.spender.subaccount);
                return #Ok(1);
              } else if (i == 2) {
                areSecondCallArgsCorrect := 
                  args.fee == ?20 and
                  args.memo == null and
                  args.from_subaccount == null and
                  args.amount == 200 and
                  args.expected_allowance == ?600 and
                  args.expires_at == ?2_000_000 and
                  args.spender.owner == customer1 and Option.isNull(args.spender.subaccount);
                return #Err(#TemporarilyUnavailable);
              };
              #Ok(0);
            };
            public shared func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
              return #Ok(0);
            };
          };

          let approvals = await* ICRCCall.wrapped_icrc2_approve_batch(
            icrc2Actor,
            2,
            [
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
                fee = ?20;
                memo = null;
                from_subaccount = null;
                created_at_time = null;
                amount = 200;
                expected_allowance = ?600;
                expires_at = ?2_000_000;
                spender = { owner = customer1; subaccount = null };
              }
            ],
            //approveFunction
          );

          if (approvals != [#Ok(1), #Err(#TemporarilyUnavailable)]) {
            print("Expected [#Ok(1), #Err(#TemporarilyUnavailable)], got " # debug_show(approvals));
            return false;
          };

          areFirstCallArgsCorrect and areSecondCallArgsCorrect;
        }
      )
    ]
  ),
  describe(
    "wrapped_icrc2_transfer_from_batch",
    [
      itsp(
        "calls the transferFunction multiple times with the expected args",
        func(state: (), print : (t: Text) -> ()) : async* Bool {
          var areFirstCallArgsCorrect = false;
          var areSecondCallArgsCorrect = false;
          let icrc2Actor : ICRC2Interface.ICRC2Actor = actor {
            var i = 0;
            public shared func icrc2_allowance({ account; spender }: ICRC2Interface.AllowanceArgs) : async ICRC2Interface.Allowance {
              return { allowance = 100; expires_at = null };
            };
            public shared func icrc2_approve(args: ICRC2Interface.ApproveArgs) : async { #Ok : Nat; #Err : ICRC2Interface.ApproveError } {
              return #Ok(0);
            };
            public shared func icrc2_transfer_from(args: ICRC2Interface.TransferFromArgs) : async { #Ok : Nat; #Err : ICRC2Interface.TransferFromError } {
              // each time this is called, increments i
              i += 1;
              if (i == 1) {
                areFirstCallArgsCorrect := 
                  args.to.owner == customer1 and Option.isNull(args.to.subaccount) and
                  args.fee == ?10 and
                  args.spender_subaccount == null and
                  args.from.owner == customer2 and Option.isNull(args.from.subaccount) and
                  args.memo == null and
                  args.created_at_time == ?1_000_000 and
                  args.amount == 100;
                return #Ok(1);
              } else if (i == 2) {
                areSecondCallArgsCorrect := 
                  args.to.owner == customer2 and Option.isNull(args.to.subaccount) and
                  args.fee == ?20 and
                  args.spender_subaccount == null and
                  args.from.owner == customer1 and Option.isNull(args.from.subaccount) and
                  args.memo == null and
                  args.created_at_time == ?2_000_000 and
                  args.amount == 200;
                return #Err(#InsufficientAllowance({ allowance = 100 }))
              };
              #Ok(0);
            };
          };

          let transfers = await* ICRCCall.wrapped_icrc2_transfer_from_batch(
            icrc2Actor,
            2,
            [
              {
                to = { owner = customer1; subaccount = null };
                fee = ?10;
                spender_subaccount = null;
                from = { owner = customer2; subaccount = null };
                memo = null;
                created_at_time = ?1_000_000;
                amount = 100;
              },
              {
                to = { owner = customer2; subaccount = null };
                fee = ?20;
                spender_subaccount = null;
                from = { owner = customer1; subaccount = null };
                memo = null;
                created_at_time = ?2_000_000;
                amount = 200;
              }
            ],
            //transferFunction
          );

          if (transfers != [#Ok(1), #Err(#InsufficientAllowance({ allowance = 100 }))]) {
            print("Expected [#Ok(1), #Err(#InsufficientAllowance({ allowance = 100 }))], got " # debug_show(transfers));
            return false;
          };

          areFirstCallArgsCorrect and areSecondCallArgsCorrect;
        }
      )
    ]
  )
]);