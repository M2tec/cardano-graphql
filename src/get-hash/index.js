const express = require('express');
const fs = require('fs');
const path = require('path');
const hash = require('object-hash');

const app = express();
const port = process.env.PORT || 3050;

app.use(express.json());

// const dataDir = path.join(__dirname, 'data');

// Ensure /data directory exists
// if (!fs.existsSync(dataDir)) {
//   fs.mkdirSync(dataDir);
// }

app.post('/hash', (req, res) => {
  // console.log("=")
  const data = req.body || {};
 
  if (data.decimals?.value !== undefined) {
    data.decimals.value = parseInt(data.decimals.value, 10);
  }

  function cleanObject(obj) {
    if (Array.isArray(obj)) {
      return obj.map(cleanObject).filter(item => item !== null);
    } else if (obj && typeof obj === 'object') {
      const cleaned = {};
      for (const [key, value] of Object.entries(obj)) {
        if (value === null) continue;
  
        const cleanedValue = cleanObject(value);
  
        const isEmptyObject =
          typeof cleanedValue === 'object' &&
          !Array.isArray(cleanedValue) &&
          Object.keys(cleanedValue).length === 0;
  
        if (!isEmptyObject) {
          cleaned[key] = cleanedValue;
        }
      }
      return cleaned;
    }
    return obj;
  }

  // const keysToKeep = ['subject', 'decimals', 'policy', 'description', 'logo', 'name', 'ticker', 'url'];

  // const filtered = Object.fromEntries(
  //   Object.entries(data).filter(([key]) => keysToKeep.includes(key))
  // );

  // cleaned = cleanObject(filtered)  

  // cleaned["additionalProperties"] = {};

  // console.log(data)
  // console.log(data["name"])
  const metadataHash = hash(data);
  // if (data["name"]["value"] == 'aAADA') {
    // console.log(data.subject)
    // // Write data to a file named after the hash
    // let subj = data.subject
    // const filePath = path.join('/data', `${subj}.json`);
    // console.log(filePath)
    // fs.writeFile(filePath, JSON.stringify(cleaned, null, 2), err => {
    //   if (err) {
    //     console.error('Error writing file:', err);
    //     return res.status(500).send('Failed to write data to file.');
    //   }
    // });


    // console.log(data);
  // }

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