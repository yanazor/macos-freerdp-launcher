# Security model

## Password handling

The launcher reads the RDP password from macOS Keychain and sends it to FreeRDP through standard input using `/from-stdin:force`.

The password is not stored in:

- `config.sh`
- the application bundle
- the launcher arguments as `/p:<password>`
- the Git repository

## Certificate validation

The example configuration uses `/cert:tofu` for a practical first-use trust model. A production or high-assurance environment should use a certificate chain trusted by the client or a supported certificate-pinning method.

Avoid `/cert:ignore` except for temporary testing in a controlled environment.

## Folder redirection

Only the configured folder is redirected. Do not redirect the full home directory unless that access is genuinely required.

## Publication checklist

Before publishing:

```bash
grep -RniE 'password|token|private|\.key|10\.|192\.168\.|\.lab|@' . \
  --exclude-dir=.git \
  --exclude='SECURITY.md'
```

Review every match manually. A match is not automatically a secret, but it deserves inspection.
