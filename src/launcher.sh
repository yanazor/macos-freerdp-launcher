#!/bin/bash
set -euo pipefail

CONFIG_FILE="$HOME/Library/Application Support/FreeRDP Launcher/config.sh"

show_error() {
  local message="$1"
  /usr/bin/osascript -e \
    "display alert \"FreeRDP Launcher\" message \"${message//\"/\\\"}\" as critical" \
    >/dev/null 2>&1 || true
  printf 'ERROR: %s\n' "$message" >&2
}

if [[ ! -r "$CONFIG_FILE" ]]; then
  show_error "Configuration file not found: $CONFIG_FILE"
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

required_vars=(
  RDP_HOST RDP_PORT RDP_USER
  KEYCHAIN_ACCOUNT KEYCHAIN_SERVICE
  SHARE_DIR SHARE_NAME KEYBOARD_LAYOUT
  CERTIFICATE_ARGUMENT
)

for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    show_error "Required setting is empty: $var_name"
    exit 1
  fi
done

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

FREERDP_BIN="$(command -v sdl-freerdp 2>/dev/null || true)"
if [[ -z "$FREERDP_BIN" ]]; then
  show_error "sdl-freerdp was not found. Install FreeRDP with Homebrew."
  exit 1
fi

mkdir -p "$SHARE_DIR"

RDP_PASSWORD="$(
  /usr/bin/security find-generic-password \
    -a "$KEYCHAIN_ACCOUNT" \
    -s "$KEYCHAIN_SERVICE" \
    -w 2>/dev/null
)" || {
  show_error "The configured RDP password was not found in macOS Keychain."
  exit 1
}

cleanup() {
  unset RDP_PASSWORD
}
trap cleanup EXIT INT TERM

args=(
  "/v:${RDP_HOST}:${RDP_PORT}"
  "/u:${RDP_USER}"
  "/from-stdin:force"
  "$CERTIFICATE_ARGUMENT"
  "/kbd:layout:${KEYBOARD_LAYOUT}"
  "/drive:${SHARE_NAME},${SHARE_DIR}"
)

if declare -p EXTRA_FREERDP_ARGS >/dev/null 2>&1; then
  args+=("${EXTRA_FREERDP_ARGS[@]}")
fi

# The password is supplied through stdin rather than as /p:<password>.
printf '%s\n' "$RDP_PASSWORD" | "$FREERDP_BIN" "${args[@]}"
