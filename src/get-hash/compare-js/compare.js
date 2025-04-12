const fs = require('fs');
const path = require('path');
const { diffJson } = require('diff');

const baseDir = 'cf-data';
const compareDir = 'data';

function readJson(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (err) {
    console.error(`Error reading/parsing ${filePath}:`, err.message);
    return null;
  }
}

function showDiff(baseJson, compareJson) {
  const differences = diffJson(baseJson, compareJson);
  differences.forEach(part => {
    if (part.added) {
      console.log('\x1b[32m+ ' + part.value.trim() + '\x1b[0m');
    } else if (part.removed) {
      console.log('\x1b[31m- ' + part.value.trim() + '\x1b[0m');
    }
  });
}

function compareFolders(baseDir, compareDir) {
  const baseFiles = fs.readdirSync(baseDir).filter(file => file.endsWith('.json'));

  baseFiles.forEach(file => {
    const basePath = path.join(baseDir, file);
    const comparePath = path.join(compareDir, file);

    if (!fs.existsSync(comparePath)) {
      console.log(`\x1b[33m[MISSING]\x1b[0m ${file} not found in ${compareDir}`);
      return;
    }

    const baseJson = readJson(basePath);
    const compareJson = readJson(comparePath);

    if (!baseJson || !compareJson) return;

    const baseStr = JSON.stringify(baseJson, null, 2);
    const compareStr = JSON.stringify(compareJson, null, 2);

    if (baseStr === compareStr) {
      console.log(`\x1b[32m[MATCH]\x1b[0m ${file}`);
    } else {
      console.log(`\x1b[31m[DIFFERENT]\x1b[0m ${file}`);
      showDiff(baseJson, compareJson);
    }
  });
}

compareFolders(baseDir, compareDir);
