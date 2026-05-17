# my-conf

Personal macOS development configuration templates.

## Files

- `.zshrc`: Zsh template based on the current local shell setup.
- `.zshrc.local.example`: Local-only private value template. Copy it to
  `~/.zshrc.local` and fill in machine, account, or company-specific values.
- `.vimrc`: Vim template based on the current local editor setup.
- `starship.toml`: Starship prompt template.
- `config.ghostty`: Ghostty terminal template.
- `init.sh`: Homebrew bootstrap script for common CLI, shell, Kubernetes, and
  development tools.
- `AGENTS.md`: Agent-readable installation guide and safety rules.
- `raycast.template.md`: Non-sensitive Raycast settings template.
- `raycast_cong.rayconfig`: Raycast export backup. Review before sharing or
  replacing it because Raycast exports may include private workflow metadata.

Do not commit tokens, passwords, private keys, emails, internal domains,
hostnames, full kubeconfigs, cloud credentials, or machine-specific private
paths.
