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
FROM '/mydata/token-registry/cip-26-metadata.csv'
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
FROM '/mydata/token-registry/cip-26-logodata.csv'
WITH
(
 format 'csv',
 header 'true',
 delimiter ','
);

SELECT * 
FROM token_registry.metadata
