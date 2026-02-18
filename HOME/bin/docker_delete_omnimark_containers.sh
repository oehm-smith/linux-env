#!/bin/bash
BATCH_SIZE=20
TOTAL=$(docker ps -aq --filter "ancestor=bbos/omnimarkdocker:latest" --filter "status=exited" | wc -l)

echo "Found $TOTAL containers to delete"

while [ $(docker ps -aq --filter "ancestor=bbos/omnimarkdocker:latest" --filter "status=exited" | wc -l) -gt 0 ]; do
    echo "Deleting next $BATCH_SIZE containers..."
    docker ps -aq --filter "ancestor=bbos/omnimarkdocker:latest" --filter "status=exited" | head -$BATCH_SIZE | xargs -r docker rm
    sleep 2  # Give Docker a breather
done
