const express = require('express');
const hash = require('object-hash');
const app = express();
const port = process.env.PORT || 3050;

app.use(express.json());

app.post('/hash', (req, res) => {

  const metadataHash = hash(data);

  res.send(metadataHash);
});

app.get('/get', (req, res) => {
  res.send({
    message: 'Send a GET request to /get with a JSON body to receive a hash.',
  });
});

app.listen(port, () => {
  console.log(`API running at http://localhost:${port}`);
});


// Example usage
// curl -X POST http://localhost:3050/hash   -H "Content-Type: application/json"   -d '{"data": {"name": { "value" : "tNEWM"}}}'

// get-hash-1  | Subject:  6b1b1cc20a8d37d1d7bea2ca5427335c7f4c586e70692333153ef383444543494d414c533230 	Hash:  5f141f5c5f66625ea28cf44c6e3b05a225d59c7b