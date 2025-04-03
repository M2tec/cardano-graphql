DROP SCHEMA IF EXISTS token_registry CASCADE;

CREATE SCHEMA token_registry;

CREATE TABLE token_registry.metadata (
    -- id SERIAL PRIMARY KEY,
    subject VARCHAR(255),
    -- sequence_number TEXT,
    policy VARCHAR(255),
    name VARCHAR(255),
    ticker VARCHAR(32),
    url VARCHAR(255),
    description TEXT,
    decimals INTEGER,
    updated TEXT,
    updated_by VARCHAR(255),
    properties JSONB,
    textsearch TSVECTOR
);

CREATE TABLE token_registry.logo (
    -- id SERIAL PRIMARY KEY,
    subject VARCHAR(255),
    -- sequence_number TEXT,
    logo TEXT
);

copy token_registry.metadata (
    subject, 
    -- sequence_number,
    policy, 
    name, 
    ticker, 
    url, 
    description, 
    decimals, 
    updated, 
    updated_by, 
    properties, 
    textsearch) 
from '/mydata/cip-26-metadata.csv'
with
(
 format 'csv',
 header 'true',
 delimiter ','
);

copy token_registry.logo (
    subject, 
    -- sequence_number,
    logo) 
from '/mydata/cip-26-logodata.csv'
with
(
 format 'csv',
 header 'true',
 delimiter ','
);

SELECT * 
FROM token_registry.metadata
