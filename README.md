# icrc2-batch

## Install
```
mops add icrc2-batch
```

## Usage
```motoko
import ICRC2Batch "mo:icrc2-batch";
import ICRC2Interface "mo:icrc2-batch/IRCR2Interface"

// example...
let icpLedgerCanisterId = "ryjl3-tyaaa-aaaaa-aaaba-cai"; 

let icrc2Actor = ICRC2Batch.ICRC2BatchActor({
  icrc2LedgerCanisterId = icpLedgerCanisterId;
  batchSize = 100;
});

let allowanceArgs : [ICRC2Interface.AllowanceArgs] = [
  { 
    account = { owner = <ownerPrincipal>; subaccount = null };
    spender = { owner = <spenderPrincipal>; subaccount = null };
  },
  ...
];

await* icrc2Actor.icrc2_allowance_batch(allowanceArgs);
```

Similarly applies to `icrc2_approve_batch` and `icrc2_transfer_from_batch` APIs.