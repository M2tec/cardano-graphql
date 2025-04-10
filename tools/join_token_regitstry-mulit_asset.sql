DROP VIEW IF EXISTS token_registry."Asset_m2" CASCADE;

CREATE VIEW IF NOT EXISTS token_registry."Asset_m2" (
	-- id SERIAL PRIMARY KEY,
    assetId BYTEA PRIMARY KEY,
    assetName BYTEA,
    decimals INTEGER,
    description VARCHAR,
    fingerprint CHAR(44),
	firstApprearedInSlot INTEGER, 
    logo VARCHAR,
	metadataHash CHAR (40),
	name VARCHAR,
	policyId BYTEA,
    ticker VARCHAR(9),
    url VARCHAR
);


INSERT INTO token_registry."Asset_m2" (
    assetId,
    assetName,
    decimals,
    description,
    fingerprint,
    logo,
	name,
	policyId,
    ticker,
    url
)
SELECT 
    ma.policy || ma.name AS "assetId",
    ma.name AS "assetName",
    trm.decimals,
    trm.description,
    ma.fingerprint,
    trm.logo,
	trm.name,
	ma.policy,
    trm.ticker,
    trm.url
FROM 
    (SELECT 
        id,
        name,
        policy,
        encode(policy, 'hex') AS policy_encode,
        encode(name, 'hex') AS name_encode,
        encode(policy, 'hex') || encode(name, 'hex') AS subject,
        fingerprint
    FROM token_registry.multi_asset
    ) AS ma
INNER JOIN token_registry.metadata AS trm
ON ma.subject = trm.subject
ORDER BY trm.ticker ASC;


SELECT * 
FROM token_registry."Asset_m2"



-- Attempt to create a view from the table version
DROP VIEW IF EXISTS token_registry."Asset_m2" CASCADE;

CREATE VIEW token_registry."Asset_m2" AS
SELECT 
    ma.policy || ma.name AS assetId,
    ma.name AS assetName,
    trm.decimals,
    trm.description,
    ma.fingerprint,
    block.slot_no AS firstAppearedInSlot,  -- Fetch slot from block table
    trm.logo,
    trm.metadataHash,
    trm.name,
    ma.policy AS policyId,
    trm.ticker,
    trm.url
FROM 
    (SELECT 
        name,
        policy,
        encode(policy, 'hex') AS policy_encode,
        encode(name, 'hex') AS name_encode,
        encode(policy, 'hex') || encode(name, 'hex') AS subject,
        fingerprint
    FROM token_registry.multi_asset) AS ma
INNER JOIN token_registry.metadata AS trm
ON ma.subject = trm.subject
INNER JOIN public.ma_tx_mint AS mint
ON ma.id = mint.ident
INNER JOIN public.tx AS tx
ON mint.tx_id = tx.id
INNER JOIN public.block AS block
ON tx.block_id = block.id
ORDER BY trm.ticker ASC;