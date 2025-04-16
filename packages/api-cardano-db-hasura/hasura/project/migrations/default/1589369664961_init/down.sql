DROP SCHEMA IF EXISTS graphql CASCADE;

DROP TABLE IF EXISTS
"Asset",
"Metadata", 
"MetadataGql" CASCADE;

DROP MATERIALIZED VIEW IF EXISTS 
graphql."metadata_gql" CASCADE;

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