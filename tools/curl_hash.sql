CREATE EXTENSION IF NOT EXISTS pg_curl;

DROP SCHEMA IF EXISTS testing;

CREATE SCHEMA testing;

DROP TABLE IF EXISTS testing.hashed_data;

CREATE TABLE testing.hashed_data (
    id SERIAL PRIMARY KEY,
    input_data jsonb,
    response jsonb
);

INSERT INTO testing.hashed_data (input_data, response)
SELECT 
    properties AS input_data,
    (SELECT content::jsonb
     FROM http_post(
         'http://localhost:3050/hash',
         properties::text,
         'application/json'
     )) AS response
FROM tokenregistry.metadata;


CREATE OR REPLACE FUNCTION get(url TEXT) RETURNS TEXT LANGUAGE SQL AS $BODY$
    WITH s AS (SELECT
        curl_easy_reset(),
        curl_easy_setopt_url(url),
        curl_easy_perform(),
        curl_easy_getinfo_data_in()
    ) SELECT convert_from(curl_easy_getinfo_data_in, 'utf-8') FROM s;
$BODY$;

SELECT get('http://localhost:3050/hash');

CREATE TABLE file_records (
    id SERIAL PRIMARY KEY,
    filename TEXT NOT NULL
);


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

SELECT post('http://get-hash:3050/hash', '{"hello": "world"}');


-- curl -X POST http://localhost:3050/hash   -H "Content-Type: application/json"   -d '{"input":"hello"}'


WITH data AS (
  SELECT properties::JSON
  FROM tokenregistry.metadata
  WHERE subject = '0057360265b49fea0bb1f116cabf356eaf527f1833f46da9654d1c9e74575254'
)
SELECT post('http://get-hash:3050/hash', properties)
FROM data;