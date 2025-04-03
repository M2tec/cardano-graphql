
const object_hash_1 = __importDefault(require("object-hash"));

const fetchedMetadata = yield this.metadataFetchClient.sync();

metadataFetchClient.sync() 
const response = yield this.axiosClient.post('metadata/sync', {
    subjects: "",
    properties: ['']
});
return response.data.subjects;


const metadata = fetchedMetadata.find(item => item.subject === assetId);


const metadataHash = (0, object_hash_1.default)(metadata);