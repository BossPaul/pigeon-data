#!/usr/bin/env node
// Pigeon data storage server - receives POST from n8n, appends to JSONL file
const http = require('http');
const fs = require('fs');

const PORT = process.argv[2] || 5757;
const DATA_FILE = '/Users/ai/.openclaw/workspace/memory/pigeon-logs/_n8n-data.jsonl';

const server = http.createServer((req, res) => {
  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }
  
  if (req.method === 'POST' && req.url === '/store') {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const data = JSON.stringify(JSON.parse(body)) + '\n';
        fs.appendFileSync(DATA_FILE, data, 'utf-8');
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ success: true }));
      } catch (e) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ success: false, error: e.message }));
      }
    });
    return;
  }
  
  if (req.method === 'GET' && req.url === '/data') {
    try {
      const data = fs.readFileSync(DATA_FILE, 'utf-8');
      const lines = data.trim().split('\n').filter(Boolean).map(l => JSON.parse(l));
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(lines));
    } catch (e) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end('[]');
    }
    return;
  }
  
  res.writeHead(404);
  res.end('Not Found');
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`Storage server running on http://127.0.0.1:${PORT}`);
});
