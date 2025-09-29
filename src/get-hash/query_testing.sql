SELECT 
	name,
	"assetId",
	"metadataHash"
FROM public."Asset"
where "metadataHash" is not null
ORDER BY 
	"name" ASC, "assetId" ASC
