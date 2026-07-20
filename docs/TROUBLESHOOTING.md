# Troubleshooting

## `sdl-freerdp` not found

```bash
brew install freerdp
command -v sdl-freerdp
sdl-freerdp /version
```

## Keychain item not found

Confirm that `KEYCHAIN_ACCOUNT` and `KEYCHAIN_SERVICE` in `config.sh` exactly match the saved generic-password item.

Diagnostic command:

```bash
security find-generic-password \
  -a "ACCOUNT" \
  -s "SERVICE"
```

Do not add `-w` while sharing diagnostic output because it prints the secret.

## Clipboard does not work

Confirm that the launcher contains:

```text
/clipboard:direction-to:all
```

For xRDP, also confirm that `cliprdr=true` and that `xrdp-chansrv` is running in the active graphical session.

## Shared folder does not appear

Confirm the configured argument:

```text
/drive:SHARE_NAME,/absolute/local/path
```

On many xRDP desktops, redirected folders appear under a directory such as:

```text
~/thinclient_drives/
```

## Wrong keyboard layout

Set `KEYBOARD_LAYOUT` in `config.sh`. The example uses US English:

```text
0x00000409
```

The remote Linux desktop can separately configure multiple XKB layouts and a switching shortcut.
