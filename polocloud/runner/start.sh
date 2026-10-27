#!/bin/bash

JAVA="/usr/lib/jvm/java-25-openjdk-amd64/bin/java"
SCREEN_NAME="polocloud-runner"

echo "[INFO] Checking if update is available..."

POLOCLOUD=$(curl -s "https://api.github.com/repos/thePolocloud/polocloud/releases/latest" \
  | grep -oE 'https://[^\"]*polocloud-runner[^\"]*\.jar' | head -n 1)

FILENAME=$(basename "$POLOCLOUD")
if [ -f "$FILENAME" ]; then
    echo "[INFO] Skipping, file is up-to-date"
else
    [ ! -f "$FILENAME" ] && echo "[INFO] No file found, downloading PoloCloud..." || echo "[INFO] Update found, downloading PoloCloud..."
    curl -sS --progress-bar -L -o "$FILENAME" "$POLOCLOUD"
fi

echo "Starting PoloCloud in screen session "$SCREEN_NAME"..."
screen -S "$SCREEN_NAME" "$JAVA" -jar "$FILENAME"
