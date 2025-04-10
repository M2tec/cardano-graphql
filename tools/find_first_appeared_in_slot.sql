

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


DROP VIEW IF EXISTS token_registry."Asset" CASCADE;

CREATE VIEW token_registry."Asset" AS
SELECT 
	multi."assetId",
	multi.name AS "assetName",
	meta.decimals,
	meta.description,
	multi.fingerprint,
	multi."firstAppearedInSlot",
	meta.logo,
	meta."metadataHash",
	meta.name,
	multi.policy as "policyId",
	meta.ticker,
	meta.url
FROM
	token_registry.multi_asset AS multi
LEFT JOIN
	token_registry.metadata AS meta
ON
	encode(multi."assetId", 'hex') = meta.subject;


SELECT * 
FROM token_registry."Asset"


-- Combine

DROP VIEW IF EXISTS testing."Asset" CASCADE;

CREATE VIEW testing."Asset" AS
SELECT 
    ma.policy || ma.name AS "assetId",
    ma.name AS "assetName",
    meta.decimals,
    meta.description,
    ma.fingerprint,
    block.slot_no AS "firstAppearedInSlot",
    logo.logo,
	NULL::text AS "metadataHash",
    meta.name,
    ma.policy AS "policyId",
    meta.ticker,
    meta.url
FROM 
    public.multi_asset AS ma
JOIN 
    public.ma_tx_mint AS mint
    ON ma.id = mint.ident
JOIN 
    public.tx 
    ON mint.tx_id = tx.id
JOIN 
    public.block 
    ON tx.block_id = block.id
LEFT JOIN 
    tokenregistry.metadata AS meta 
    ON encode(ma.policy || ma.name, 'hex') = meta.subject
LEFT JOIN 
    tokenregistry.logo AS logo 
    ON encode(ma.policy || ma.name, 'hex') = logo.subject;


-- order by ident
select * from ma_tx_mint
order by ident asc


-- rank testing

  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ident ORDER BY id) AS rn
  FROM ma_tx_mint
  order by ident
  limit 1000

-- rank 1 so only first occurence selected

WITH ranked_data AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ident ORDER BY id) AS rn
  FROM ma_tx_mint
)
SELECT *
FROM ranked_data
WHERE ranked_data.rn = 1

-- view version 
CREATE VIEW ma_tx_mint_ranked_first AS
WITH ranked_data AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ident ORDER BY id) AS rn
  FROM ma_tx_mint
)
SELECT *
FROM ranked_data
WHERE rn = 1;


-- create a table of the first mints

CREATE TABLE testing.ma_tx_mint_first AS
WITH ranked_data AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ident ORDER BY id) AS rn
  FROM ma_tx_mint
)
SELECT *
FROM ranked_data
WHERE rn = 1;

-- rank and select first

WITH ranked_data AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ident ORDER BY id) AS rn
  FROM ma_tx_mint
)
SELECT multi.*, ranked.*
FROM multi_asset multi
JOIN ranked_data ranked
  ON multi.id = ranked.ident
WHERE ranked.rn = 1

-- Create table with a list of assets where the first mint tx_id is included

CREATE TABLE testing.assets_with_first_tx AS
SELECT 
    multi.id,
    multi.policy,
	encode(multi.policy, 'hex') as "policyHex",
    multi.name,
	encode(multi.name, 'hex') as "nameHex",
    multi.fingerprint,
	mint.tx_id
FROM multi_asset AS multi
JOIN testing.ma_tx_mint_first as mint
ON multi.id = mint.ident
order by id


select *
from testing.assets_with_first_tx as first
JOIN 
    public.tx 
ON 
    first.tx_id = tx.id
JOIN 
    public.block 
ON 
    tx.block_id = block.id	
LIMIT 50;	


-- DEV stuff

-- Testing the joins
SELECT 
    multi_asset.id,
    multi_asset.policy,
    multi_asset.name,
    multi_asset.fingerprint,
    ma_tx_mint.id AS mint_id,
    ma_tx_mint.quantity,
    ma_tx_mint.tx_id,
    ma_tx_mint.ident,
    tx.id,
    tx.block_id,
	block.slot_no
FROM 
    public.multi_asset
JOIN 
    public.ma_tx_mint 
ON 
    public.multi_asset.id = public.ma_tx_mint.ident
JOIN 
    public.tx 
ON 
    ma_tx_mint.tx_id = tx.id
JOIN 
    public.block 
ON 
    tx.block_id = block.id	
LIMIT 50;

-- Testing the joins
SELECT 
    multi_asset.policy ||  multi_asset.name AS "assetId",
	block.slot_no AS "firstApperaedInSlot"
FROM 
    public.multi_asset
JOIN 
    public.ma_tx_mint 
ON 
    public.multi_asset.id = public.ma_tx_mint.ident
JOIN 
    public.tx 
ON 
    ma_tx_mint.tx_id = tx.id
JOIN 
    public.block 
ON 
    tx.block_id = block.id	
LIMIT 50;

-- Compare firstAppearedInSlot
SELECT 
    public."Asset"."assetId" AS public_assetId,
    token_registry.multi_asset."assetId" AS token_registry_assetId,
    public."Asset"."firstAppearedInSlot" AS public_firstAppearedInSlot,
    token_registry.multi_asset."firstAppearedInSlot" AS token_registry_firstAppearedInSlot
FROM 
    public."Asset"
FULL OUTER JOIN 
    token_registry.multi_asset
ON 
    token_registry.multi_asset."assetId" = public."Asset"."assetId"
WHERE 
    public."Asset"."assetId" IS NULL 
    OR token_registry.multi_asset."assetId" IS NULL
-- LIMIT 50;
