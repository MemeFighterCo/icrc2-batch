import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Allowance {
  'allowance' : bigint,
  'expires_at' : [] | [bigint],
}
export interface _SERVICE {
  'getAllICRC2Allowances' : ActorMethod<[], Array<Allowance>>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
