#!/bin/bash
# Store pigeon data helper - called by me when recording pigeon data
# Usage: echo '{"totalBirds":35,...}' | ./_pigeon-store.sh
DATA_FILE="/Users/ai/.openclaw/workspace/memory/pigeon-logs/_n8n-data.jsonl"
TP_TIME=$(python3 -c "from datetime import datetime, timezone, timedelta; t=datetime.now(timezone.utc)+timedelta(hours=8); print(t.strftime('%Y-%m-%dT%H:%M:%S'))")

# Read stdin and add timestamp
INPUT=$(cat)
RECORD=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.loads(sys.stdin.read())
d['_date'] = '$TP_TIME'.split('T')[0]
d['_time'] = '$TP_TIME'.split('T')[1][:8]
print(json.dumps(d, ensure_ascii=False))
")

# Append to JSONL
echo "$RECORD" >> "$DATA_FILE"

# Also POST to webhook for n8n logging
curl -s -X POST "http://localhost:5678/webhook/pigeon-log" \
  -H "Content-Type: application/json" \
  -d "$RECORD" > /dev/null 2>&1

echo "Stored: $RECORD"
