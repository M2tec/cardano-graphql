

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


DROP VIEW IF EXISTS token_registry."Asset_m2" CASCADE;

CREATE VIEW token_registry."Asset_m2" AS
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
FROM token_registry."Asset_m2"










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
