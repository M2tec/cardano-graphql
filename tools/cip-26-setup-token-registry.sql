DROP SCHEMA IF EXISTS token_registry CASCADE;

CREATE SCHEMA token_registry;

CREATE TABLE token_registry.metadata (
    subject VARCHAR(255) PRIMARY KEY,
    policy VARCHAR(255),
    name VARCHAR(255),
    ticker VARCHAR(32),
    url VARCHAR(255),
    description VARCHAR,
    decimals INTEGER,
    updated TEXT,
    updated_by VARCHAR(255),
    properties JSONB,
    textsearch TSVECTOR,
	logo TEXT,
    "metadataHash" CHAR(40)
);

CREATE TABLE token_registry.logo (
    subject VARCHAR(255) PRIMARY KEY,
    logo TEXT
);

COPY token_registry.metadata (
    subject, 
    policy, 
    name, 
    ticker, 
    url, 
    description, 
    decimals, 
    updated, 
    updated_by, 
    properties, 
    textsearch,
	logo) 
FROM '/token-data/cip-26-metadata.csv'
WITH
(
 format 'csv',
 header 'true',
 delimiter ','
);

COPY token_registry.logo (
    subject, 
    -- sequence_number,
    logo) 
FROM '/token-data/cip-26-logodata.csv'
WITH
(
 format 'csv',
 header 'true',
 delimiter ','
);

-- Create multi_asset with firstAppearedInSlot
DROP VIEW IF EXISTS token_registry.multi_asset CASCADE;

CREATE VIEW token_registry.multi_asset AS
SELECT 
    multi_asset.policy || multi_asset.name AS "assetId",
	multi_asset.policy,	
	multi_asset.name,
	multi_asset.fingerprint,
    block.slot_no AS "firstAppearedInSlot"
FROM 
    public.multi_asset
JOIN 
    public.ma_tx_mint 
ON 
    multi_asset.id = ma_tx_mint.ident
JOIN 
    public.tx 
ON 
    ma_tx_mint.tx_id = tx.id
JOIN 
    public.block 
ON 
    tx.block_id = block.id;

SELECT * 
FROM token_registry.metadata

