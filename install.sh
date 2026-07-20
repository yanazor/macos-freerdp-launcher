#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SOURCE="$PROJECT_DIR/config.sh"

if [[ ! -f "$CONFIG_SOURCE" ]]; then
  echo "config.sh not found."
  echo "Run: cp config.example config.sh"
  echo "Then edit config.sh and run ./install.sh again."
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_SOURCE"

: "${APP_NAME:?APP_NAME is required}"
: "${APP_BUNDLE_ID:?APP_BUNDLE_ID is required}"
: "${SUPPORT_DIR:?SUPPORT_DIR is required}"
: "${APP_INSTALL_DIR:?APP_INSTALL_DIR is required}"
: "${SHARE_DIR:?SHARE_DIR is required}"

if ! command -v sdl-freerdp >/dev/null 2>&1; then
  echo "sdl-freerdp was not found. Install FreeRDP first:"
  echo "  brew install freerdp"
  exit 1
fi

APP_PATH="$APP_INSTALL_DIR/$APP_NAME.app"

mkdir -p "$SUPPORT_DIR" "$APP_INSTALL_DIR" "$SHARE_DIR"
install -m 0700 "$PROJECT_DIR/src/launcher.sh" "$SUPPORT_DIR/launcher.sh"
install -m 0600 "$CONFIG_SOURCE" "$SUPPORT_DIR/config.sh"

rm -rf "$APP_PATH"
mkdir -p "$APP_PATH/Contents/MacOS" "$APP_PATH/Contents/Resources"
install -m 0755 "$PROJECT_DIR/src/app-entrypoint.sh" \
  "$APP_PATH/Contents/MacOS/FreeRDPLauncher"

cat > "$APP_PATH/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
  <key>CFBundleDisplayName</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$APP_BUNDLE_ID</string>
  <key>CFBundleExecutable</key>
  <string>FreeRDPLauncher</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleVersion</key>
  <string>1.0.0</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0.0</string>
  <key>CFBundleIconFile</key>
  <string>FreeRDPLauncher.icns</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

for icon in \
  "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns" \
  "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericComputerIcon.icns" \
  "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns"
do
  if [[ -f "$icon" ]]; then
    cp "$icon" "$APP_PATH/Contents/Resources/FreeRDPLauncher.icns"
    break
  fi
done

plutil -lint "$APP_PATH/Contents/Info.plist" >/dev/null

to_bool() {
  [[ "${1,,}" == "true" || "$1" == "1" || "${1,,}" == "yes" ]]
}

if to_bool "${CREATE_DESKTOP_APP_SHORTCUT:-false}"; then
  rm -f "$HOME/Desktop/$APP_NAME.app"
  ln -s "$APP_PATH" "$HOME/Desktop/$APP_NAME.app"
fi

if to_bool "${CREATE_DESKTOP_SHARE_SHORTCUT:-false}"; then
  rm -f "$HOME/Desktop/$SHARE_NAME"
  ln -s "$SHARE_DIR" "$HOME/Desktop/$SHARE_NAME"
fi

cat <<SUMMARY
Installed successfully.

Application:
  $APP_PATH

Launcher:
  $SUPPORT_DIR/launcher.sh

Configuration:
  $SUPPORT_DIR/config.sh

Shared folder:
  $SHARE_DIR

The RDP password must exist in macOS Keychain as:
  account: $KEYCHAIN_ACCOUNT
  service: $KEYCHAIN_SERVICE
SUMMARY
