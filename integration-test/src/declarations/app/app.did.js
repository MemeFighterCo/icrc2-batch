export const idlFactory = ({ IDL }) => {
  const Allowance = IDL.Record({
    'allowance' : IDL.Nat,
    'expires_at' : IDL.Opt(IDL.Nat64),
  });
  return IDL.Service({
    'getAllICRC2Allowances' : IDL.Func([], [IDL.Vec(Allowance)], []),
  });
};
export const init = ({ IDL }) => { return []; };
