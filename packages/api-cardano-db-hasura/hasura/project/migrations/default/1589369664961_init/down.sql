DROP SCHEMA IF EXISTS graphql CASCADE;

DROP MATERIALIZED VIEW IF EXISTS 
"Asset" CASCADE;

DROP VIEW IF EXISTS 
"Block",
"AdaPots",
"ActiveStake",
"Cardano",
"CollateralInput",
"CollateralOutput",
"Datum",
"Delegation",
"Epoch",
"ProtocolParams",
"Redeemer",
"RedeemerDatum",
"ReferenceInput",
"Reward",
"Script",
"SlotLeader",
"StakeDeregistration",
"StakePool",
"StakePoolOwner",
"StakeRegistration",
"StakePoolRetirement",
"TokenMint",
"TokenInOutput",
"Transaction",
"TransactionInput",
"TransactionOutput",
"Utxo",
"Withdrawal",
"DelegationVote",
"DrepRegistration" CASCADE;