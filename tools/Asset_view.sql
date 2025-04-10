-- Recreating the "Asset table in postgresql statements"

DROP SCHEMA IF EXISTS testing CASCADE;

CREATE EXTENSION IF NOT EXISTS pg_curl;

CREATE OR REPLACE FUNCTION post(url TEXT, request JSON) RETURNS TEXT LANGUAGE SQL AS $BODY$
    WITH s AS (SELECT
        curl_easy_reset(),
        curl_easy_setopt_postfields(convert_to(request::TEXT, 'utf-8')),
        curl_easy_setopt_url(url),
        curl_header_append('Content-Type', 'application/json; charset=utf-8'),
        curl_easy_perform(),
        curl_easy_getinfo_data_in()
    ) SELECT convert_from(curl_easy_getinfo_data_in, 'utf-8') FROM s;
$BODY$;


-- Modified ma_tx_mint table where only first mint is selected

CREATE OR REPLACE VIEW ma_tx_first_mint AS
WITH ranked_data AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ident ORDER BY id) AS rn
  FROM ma_tx_mint
)
SELECT *
FROM ranked_data
WHERE rn = 1;


-- Combine first mint with the block table to get the final first mint block.id

CREATE OR REPLACE VIEW  assets_with_first_tx AS
SELECT 
    multi.policy || multi.name AS "assetId",
    multi.name AS "assetName",
	multi.fingerprint,
	block.id as "firstAppearedInSlot",
    multi.policy as "policyId"
    
FROM 
    multi_asset AS multi
JOIN 
    ma_tx_first_mint as mint
ON 
    multi.id = mint.ident
JOIN 
    public.tx 
ON 
    mint.tx_id = tx.id
JOIN 
    public.block
ON 
    tx.block_id = block.id	
order by multi.id;


-- Join logo data on metadata and select needed rows 
-- Also add the pg_curl command to get the metadataHash from the get-hash service. 

CREATE OR REPLACE VIEW metadata_with_logo AS
SELECT 
	metadata.subject,
	metadata.decimals,
	metadata.description,
	logo.logo,
	post('http://get-hash:3050/hash', metadata.properties::JSON) AS "metadataHash",
	metadata.name,
	metadata.ticker,
	metadata.url
FROM 
    tokenregistry.metadata as metadata
JOIN 
	tokenregistry.logo as logo
ON 
	metadata.subject = logo.subject;


-- Create the final "Asset" table 

CREATE OR REPLACE VIEW "Asset" AS
SELECT 
    multi."assetId",
    multi."assetName",
	metadata.decimals,
    metadata.description,
    multi.fingerprint,
	multi."firstAppearedInSlot",
    metadata.logo,
    metadata."metadataHash",
    metadata.name,
    multi."policyId",
	metadata.ticker,
	metadata.url
FROM 
    assets_with_first_tx as multi
LEFT JOIN 
    metadata_with_logo as metadata
ON
	encode(multi."assetId", 'hex') = metadata.subject;

SELECT * 
FROM "Asset"
where logo is not null
LIMIT 50