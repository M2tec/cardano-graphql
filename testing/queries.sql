SELECT
	row_to_json(t) asset
FROM(
SELECT * 
FROM public."Asset"
WHERE fingerprint = 'asset133q5qx3d5cfnm8usueaadzf7f75jshlh65l8hn') t;
