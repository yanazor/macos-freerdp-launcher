# Security Policy

## Supported Versions

Security fixes are applied to the latest version of the project available on
the default branch.

Older commits, forks, and locally modified copies are not actively supported.

## Reporting a Vulnerability

Do not disclose a suspected vulnerability in a public issue, discussion, pull
request, log, or screenshot.

Use GitHub private vulnerability reporting if the repository provides the
"Report a vulnerability" option.

If private vulnerability reporting is unavailable, open a public issue titled:

    [Security] Request for private reporting channel

Do not include vulnerability details in that issue. The maintainer will provide
an appropriate private communication method.

A useful private report should contain:

- a concise description of the vulnerability;
- the affected project version or commit;
- the affected macOS and FreeRDP versions;
- the expected and actual behaviour;
- minimal reproduction steps;
- the potential security impact;
- sanitized logs or screenshots, where necessary;
- suggested remediation, if known.

Never include real passwords, private keys, Keychain contents, tokens, internal
hostnames, private infrastructure addresses, or personal filesystem paths.

## Response Process

This is a small independently maintained project without a guaranteed service
level agreement.

The maintainer will make a reasonable effort to:

1. acknowledge a complete report;
2. reproduce and assess the issue;
3. determine whether the issue belongs to this project or an upstream
   dependency;
4. prepare a fix or mitigation where appropriate;
5. coordinate disclosure after a fix is available.

Complex issues or vulnerabilities in upstream projects may require additional
time.

## Security Model

### Password Handling

The launcher reads the RDP password from macOS Keychain and sends it to
FreeRDP through standard input using `/from-stdin:force`.

The password is not stored in:

- `config.sh`;
- the application bundle;
- launcher arguments as `/p:<password>`;
- the Git repository.

Changes that place the password in process arguments, configuration files,
logs, or command history are not acceptable.

### Certificate Validation

The example configuration uses `/cert:tofu` as a practical trust-on-first-use
model.

Production or high-assurance environments should use a certificate chain
trusted by the client or a supported certificate-pinning method.

Avoid `/cert:ignore` except for temporary testing in a controlled environment.

### Folder Redirection

Only the explicitly configured folder should be redirected.

Do not redirect the complete home directory unless that access is genuinely
required and the security consequences are understood.

### Local Configuration

Configuration files may contain usernames, hostnames, addresses, paths, and
other environment-specific information.

Review configuration files before sharing them. Do not commit real credentials
or private infrastructure information.

## Upstream Vulnerabilities

Vulnerabilities in FreeRDP, XQuartz, Homebrew, macOS, or another third-party
component should normally be reported to the relevant upstream project.

Report the issue here only when it is caused or materially worsened by the
launcher itself.

## Publication Checklist

Before publishing changes, inspect the repository for potentially sensitive
information:

    grep -RniE 'password|token|private|\.key|10\.|192\.168\.|\.lab|@' . \
      --exclude-dir=.git \
      --exclude='SECURITY.md'

Review every match manually.

A match is not automatically a secret, but it requires inspection before
publication.
