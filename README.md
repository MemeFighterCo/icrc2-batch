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
let icpLedgerActor : ICRC2Interface.ICRC2Actor  = actor (icpLedgerCanisterId);

let icrc2Actor = ICRC2Batch.

```