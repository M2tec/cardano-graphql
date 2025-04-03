SELECT 
    id,
    encode(policy, 'hex') || encode(name, 'hex') AS combined_hex,
    fingerprint
FROM public.multi_asset
ORDER BY id ASC;

SELECT 
	id,
	encode(policy, 'hex') AS policy,
	encode(name, 'hex') AS name,
	fingerprint
FROM public.multi_asset
ORDER BY id ASC 
LIMIT 40

-- multi_asset table
SELECT 
    id,
    encode(policy, 'hex') AS policy,
    encode(name, 'hex') AS name,
    encode(policy, 'hex') || encode(name, 'hex') AS subject,
    fingerprint
FROM public.multi_asset
ORDER BY id ASC 
LIMIT 40;

-- Asset table Turns out assetId is the same as subject
SELECT 
	encode("assetId", 'hex') AS "assetId",
	encode("policyId" || "assetName", 'hex') AS "assetId_",
	-- fingerprint,
	encode("assetName", 'hex') AS "assetName",
	encode("policyId", 'hex') AS "policyId"
FROM public."Asset"
ORDER BY "assetId" ASC 
LIMIT 50


DROP SCHEMA IF EXISTS token_metadata CASCADE;

CREATE SCHEMA token_metadata;

CREATE TABLE token_metadata.subjects (
    id SERIAL PRIMARY KEY,
    subject TEXT,
    url TEXT,
    name TEXT,
    ticker TEXT,
    decimals TEXT,
    policy TEXT,
    logo TEXT,
    description TEXT
);


copy token_metadata.subjects (subject, url, name, ticker, decimals, policy, logo, description) 
from '/mydata/metadata.csv'
with
(
 format 'csv',
 header 'true',
 delimiter ','
);


CREATE OR REPLACE FUNCTION get(url TEXT) RETURNS TEXT LANGUAGE SQL AS $BODY$
    WITH s AS (SELECT
        curl_easy_reset(),
        curl_easy_setopt_url(url),
        curl_easy_perform(),
        curl_easy_getinfo_data_in()
    ) SELECT convert_from(curl_easy_getinfo_data_in, 'utf-8') FROM s;
$BODY$;

SELECT get('file:///mydata/filelist.txt');


-- Compare metadata registries
SELECT a.subject AS in_token_registry, b.subject AS in_tokenregistry
FROM token_registry.metadata a
FULL OUTER JOIN tokenregistry.metadata b
ON a.subject = b.subject
WHERE a.subject IS NULL OR b.subject IS NULL;


-- Compare Asset tables
SELECT 
    -- assetId comparison
    a.assetId AS "AssetId_Asset",
    am2."assetId" AS "AssetId_Asset_m2",

    -- assetName comparison
    a.assetName AS "AssetName_Asset",
    am2.assetName AS "AssetName_Asset_m2",

    -- decimals comparison
    a.decimals AS "Decimals_Asset",
    am2.decimals AS "Decimals_Asset_m2",

    -- description comparison
    a.description AS "Description_Asset",
    am2.description AS "Description_Asset_m2",

    -- fingerprint comparison
    a.fingerprint AS "Fingerprint_Asset",
    am2.fingerprint AS "Fingerprint_Asset_m2",

    -- first_appeared_in comparison
    a.first_appeared_in AS "FirstAppearedIn_Asset",
    am2.first_appeared_in AS "FirstAppearedIn_Asset_m2",

    -- logo comparison
    a.logo AS "Logo_Asset",
    am2.logo AS "Logo_Asset_m2",

    -- metadataHash comparison
    a.metadataHash AS "MetadataHash_Asset",
    am2.metadataHash AS "MetadataHash_Asset_m2",

    -- name comparison
    a.name AS "Name_Asset",
    am2.name AS "Name_Asset_m2",

    -- policyId comparison
    a.policyId AS "PolicyId_Asset",
    am2.policyId AS "PolicyId_Asset_m2",

    -- ticker comparison
    a.ticker AS "Ticker_Asset",
    am2.ticker AS "Ticker_Asset_m2",

    -- url comparison
    a.url AS "Url_Asset",
    am2.url AS "Url_Asset_m2"
FROM 
    public."Asset" AS a
INNER JOIN 
    token_registry."Asset_m2" AS am2
ON 
    a.assetId = am2.assetId
ORDER BY 
    a.assetId;