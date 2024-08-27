#!/bin/bash

# Run webui.sh and capture output
./webui.sh 2>&1 | tee output.log | while read -r line; do
  echo "$line"
  if [[ "$line" == *"Model loaded"* ]]; then
    echo "Model loaded detected. Waiting for 20 seconds..."

    # Wait for 20 seconds
    sleep 20

    # Check if the script is still running and output has stopped
    if ! pgrep -f webui.sh > /dev/null; then
      echo "webui.sh has stopped. Exiting..."
      exit 0
    else
      echo "webui.sh is still running. Exiting..."
      pkill -f webui.sh
      exit 0
    fi
  fi
done
