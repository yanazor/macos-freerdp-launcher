# macOS FreeRDP Launcher

[![macOS checks](https://github.com/yanazor/macos-freerdp-launcher/actions/workflows/checks.yml/badge.svg?branch=main)](https://github.com/yanazor/macos-freerdp-launcher/actions/workflows/checks.yml)


A small macOS application bundle that launches an SDL FreeRDP session to any reachable RDP host while keeping the RDP password in macOS Keychain.

## Features

- Native-looking `.app` launcher without Xcode
- Password retrieved from macOS Keychain at runtime
- Password is not stored in the script or passed as a normal command-line argument
- Bidirectional clipboard redirection
- macOS folder redirection into the remote session
- Explicit keyboard layout
- Config separated from launcher logic
- Local-only installation; GitHub is not required

## Requirements

- macOS
- Homebrew
- FreeRDP with the SDL client (`sdl-freerdp`)
- A reachable RDP/xRDP host

Install FreeRDP:

```bash
brew install freerdp
```

## Quick start

```bash
cp config.example config.sh
```

Edit `config.sh`, then run:

```bash
./install.sh
```

Add the RDP password to macOS Keychain with the same account and service values used in `config.sh`. The preferred method is the macOS Passwords app or Keychain Access.

Launch:

```text
~/Applications/FreeRDP Launcher.app
```

The installer can also place shortcuts on the Desktop.

## Project layout

```text
.
├── README.md
├── README.ru.md
├── LICENSE
├── CHANGELOG.md
├── config.example
├── install.sh
├── uninstall.sh
├── src/
│   ├── launcher.sh
│   └── app-entrypoint.sh
├── docs/
│   ├── SECURITY.md
│   └── TROUBLESHOOTING.md
└── screenshots/
```

## Security note

The example uses `/cert:tofu` rather than `/cert:ignore`. For higher assurance, deploy a trusted certificate or pin the expected certificate according to your FreeRDP version and environment.

Never commit:

- passwords
- private keys
- internal certificates containing private material
- real internal hostnames or IP addresses unless intentionally public
- personal screenshots with identifying information

## Local Git workflow

Nothing leaves your Mac until a remote is added and a push is explicitly performed.

```bash
git init
git status
git add .
git commit -m "Initial release"
```

At this point the repository is still local only.

## License

MIT
