#!/bin/bash
# Weather notification sender - runs daily at 05:05 Taiwan time
# Called by n8n or directly
# Sends weather results to Discord channel

DATA_DIR="/Users/ai/.openclaw/workspace"
PYTHON="/Users/ai/.openclaw/workspace/miniconda/bin/python"
SCRIPT="$DATA_DIR/race_weather.py"
OUTPUT_FILE="$DATA_DIR/memory/pigeon-logs/_weather-last.json"

# Check if we should run (n8n triggered at 05:00)
# Run the weather script
RESULT=$($PYTHON "$SCRIPT" "台北港咖啡店" "平鎮鴿舍" --brief 2>&1)

# Store result
echo "$RESULT" > /tmp/weather_output.txt

# Output for logging
echo "Weather checked at $(date)"
echo "$RESULT" | head -5