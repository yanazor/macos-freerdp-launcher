#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SOURCE="$PROJECT_DIR/config.sh"

if [[ ! -f "$CONFIG_SOURCE" ]]; then
  echo "config.sh not found; refusing to guess install paths."
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_SOURCE"

APP_PATH="$APP_INSTALL_DIR/$APP_NAME.app"

rm -rf "$APP_PATH"
rm -rf "$SUPPORT_DIR"
rm -f "$HOME/Desktop/$APP_NAME.app"
rm -f "$HOME/Desktop/$SHARE_NAME"

cat <<SUMMARY
Removed:
  $APP_PATH
  $SUPPORT_DIR
  Desktop shortcuts

Preserved intentionally:
  $SHARE_DIR
  macOS Keychain entry
SUMMARY
