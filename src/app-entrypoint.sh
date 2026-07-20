#!/bin/bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

LAUNCHER="$HOME/Library/Application Support/FreeRDP Launcher/launcher.sh"

if [[ ! -x "$LAUNCHER" ]]; then
  /usr/bin/osascript -e \
    'display alert "FreeRDP Launcher" message "The installed launcher is missing or not executable." as critical'
  exit 1
fi

exec "$LAUNCHER"
