# Contributing to macOS FreeRDP Launcher

Thank you for your interest in improving macOS FreeRDP Launcher.

Contributions are welcome, including bug fixes, documentation improvements,
compatibility updates, and small usability enhancements.

## Before You Start

Check the existing issues before opening a new one.

Use the appropriate issue template when reporting a bug or suggesting a
feature. For security vulnerabilities, follow the instructions in
`SECURITY.md` instead of creating a public issue.

## Development Environment

The project is intended for macOS and uses FreeRDP installed through Homebrew.

A typical development environment includes:

- macOS;
- Homebrew;
- FreeRDP;
- XQuartz, where required by the documented configuration;
- ShellCheck for static analysis of shell scripts.

Install the main development tools with:

    brew install freerdp shellcheck

Follow the installation instructions in `README.md` for any additional
requirements.

## Making Changes

1. Fork or clone the repository.
2. Create a separate branch:

       git switch -c fix/short-description

3. Keep each change focused on one problem.
4. Preserve existing behaviour unless the change intentionally modifies it.
5. Update the documentation when changing dependencies, installation steps,
   command-line options, or user-visible behaviour.

Shell scripts should:

- quote variables correctly;
- fail with clear error messages;
- validate required commands and input;
- avoid hard-coded usernames, paths, hosts, and credentials;
- remain readable within the supported macOS environment.

## Testing

Run syntax checks for all shell scripts:

    while IFS= read -r -d '' file; do
        bash -n "$file"
    done < <(find . -type f -name '*.sh' -print0)

Run ShellCheck:

    while IFS= read -r -d '' file; do
        shellcheck "$file"
    done < <(find . -type f -name '*.sh' -print0)

Also perform a manual test on macOS and verify that:

- the launcher starts correctly;
- FreeRDP is detected or a useful error is displayed;
- the connection command is formed correctly;
- features affected by the change still work;
- credentials and private environment details are not printed unexpectedly.

## Sensitive Information

Never commit or include in issues, logs, screenshots, or pull requests:

- passwords or access tokens;
- private keys;
- Keychain contents;
- real internal hostnames;
- private infrastructure addresses;
- personal usernames and filesystem paths;
- connection files containing credentials;
- screenshots containing personal or infrastructure data.

Use fictional example values such as:

    rdp.example.test
    192.0.2.10
    example-user

## Pull Requests

A pull request should:

- explain what was changed and why;
- describe how the change was tested;
- remain limited to one logical change;
- include documentation updates where necessary;
- pass the repository's automated checks;
- contain no secrets or private infrastructure information.

Small and focused pull requests are easier to review than large unrelated
changes.

## Commit Messages

Use concise, descriptive commit messages, for example:

    Fix clipboard option handling
    Improve missing dependency error
    Document XQuartz setup

## License

By submitting a contribution, you agree that it may be distributed under the
license used by this repository.
