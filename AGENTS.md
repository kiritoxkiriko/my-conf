# Agent Installation Guide

This repository contains macOS development environment templates. Agents should
use this guide to install the environment safely and with human confirmation
when a step changes the user's machine.

## Safety Rules

- Do not commit secrets, emails, internal domains, hostnames, full kubeconfigs,
  cloud credentials, API tokens, cookies, or private keys.
- Do not overwrite files in `$HOME` without first running a dry run and telling
  the human exactly which files will be touched.
- Do not import `raycast_cong.rayconfig` automatically. Ask the human to review
  it first because Raycast exports may contain private workflow metadata.
- Prefer official installers for Zsh-related tooling:
  - Oh My Zsh: official install script.
  - `zsh-autosuggestions`: official GitHub repository.
  - `zsh-syntax-highlighting`: official GitHub repository.
  - Starship: official install script.
- Homebrew is used for general CLI tools, runtimes, and non-Zsh helper tools.

## Script Entry Point

Use `init.sh` for both interactive and automated setup.

List available components:

```sh
bash init.sh --list
```

Run an interactive setup:

```sh
bash init.sh
```

Dry-run a full setup:

```sh
bash init.sh --all --dry-run
```

Dry-run selected components:

```sh
bash init.sh --components zshrc,zshrc-local,starship-config,ghostty-config --dry-run
```

Install selected components after human confirmation:

```sh
bash init.sh --components zshrc,zshrc-local,starship-config,ghostty-config --yes
```

## Components

- `brew-cli`: install common CLI tools with Homebrew.
- `brew-dev`: install development runtimes with Homebrew.
- `shell-tools`: install shell helper commands with Homebrew.
- `omz`: install Oh My Zsh with the official installer.
- `zsh-plugins`: clone official Zsh plugin repositories.
- `starship-bin`: install Starship with the official installer.
- `kubernetes`: install optional Kubernetes workflow tools with Homebrew.
- `zshrc`: copy `.zshrc` to `~/.zshrc`, backing up an existing file first.
- `zshrc-local`: create `~/.zshrc.local` from `.zshrc.local.example` only when
  it does not already exist.
- `vimrc`: copy `.vimrc` to `~/.vimrc`, backing up an existing file first.
- `starship-config`: copy `starship.toml` to `~/.config/starship.toml`, backing
  up an existing file first.
- `ghostty-config`: copy `config.ghostty` to Ghostty's Application Support
  config path, backing up an existing file first.
- `raycast-notes`: print Raycast review/import guidance only.

## Recommended Agent Flow

1. Inspect the repository state:

   ```sh
   git status --short
   bash init.sh --list
   ```

2. Pick components based on the user's request. If the user asks for a full
   setup, start with:

   ```sh
   bash init.sh --all --dry-run
   ```

3. Report the planned package installs and file writes to the human.

4. Ask for confirmation before any command that installs packages, downloads
   from the network, or writes outside this repository.

5. After confirmation, run the selected install command with `--yes`.

6. Validate templates when relevant:

   ```sh
   zsh -n .zshrc
   bash -n init.sh
   STARSHIP_CONFIG="$PWD/starship.toml" starship prompt
   ghostty +validate-config --config-file="$PWD/config.ghostty"
   ```

7. If Ghostty prints `SentryInitFailed` while returning success, treat the
   config validation as successful but mention the warning to the human.

8. Leave private values in `~/.zshrc.local`; never fill them into committed
   templates.
