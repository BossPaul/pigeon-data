#!/bin/bash
# n8n pigeon data storage helper
# Called by n8n Execute Command node
# Input: JSON data from stdin
# Output: Appends to JSONL file

DATA_FILE="/Users/ai/.openclaw/workspace/memory/pigeon-logs/_n8n-data.jsonl"

# Read stdin, append to file
cat >> "$DATA_FILE"

echo '{"success":true}'
