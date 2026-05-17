#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0
DRY_RUN=0
INSTALL_ALL=0
SELECTED_COMPONENTS=""

COMPONENTS=(
    brew-cli
    brew-dev
    shell-tools
    omz
    zsh-plugins
    starship-bin
    kubernetes
    zshrc
    zshrc-local
    vimrc
    starship-config
    ghostty-config
    raycast-notes
)

usage() {
    cat <<'EOF'
Usage:
  bash init.sh
  bash init.sh --all --yes
  bash init.sh --components zshrc,starship-config --yes
  bash init.sh --components zshrc,starship-config --dry-run

Options:
  --all                 Install every component.
  --components LIST     Comma-separated component list.
  --yes                 Do not prompt for confirmation.
  --dry-run             Print actions without changing the machine.
  --list                List available components.
  -h, --help            Show this help.

Components:
  brew-cli              Common CLI tools via Homebrew.
  brew-dev              Development runtimes via Homebrew.
  shell-tools           Shell helper commands via Homebrew.
  omz                   Oh My Zsh via the official installer.
  zsh-plugins           zsh-autosuggestions and zsh-syntax-highlighting from GitHub.
  starship-bin          Starship via the official installer.
  kubernetes            Optional Kubernetes workflow tools via Homebrew.
  zshrc                 Install repository .zshrc template to ~/.zshrc.
  zshrc-local           Create ~/.zshrc.local from .zshrc.local.example if missing.
  vimrc                 Install repository .vimrc template to ~/.vimrc.
  starship-config       Install starship.toml to ~/.config/starship.toml.
  ghostty-config        Install config.ghostty to Ghostty Application Support.
  raycast-notes         Print Raycast import/review guidance.
EOF
}

list_components() {
    printf '%s\n' "${COMPONENTS[@]}"
}

log() {
    printf '%s\n' "$*"
}

run() {
    local cmd=("$@")

    if [[ "$DRY_RUN" == "1" ]]; then
        printf '[dry-run]'
        printf ' %q' "${cmd[@]}"
        printf '\n'
    else
        "${cmd[@]}"
    fi
}

confirm() {
    local prompt="$1"

    if [[ "$YES" == "1" ]]; then
        return 0
    fi

    read -r -p "$prompt [y/N] " reply
    case "$reply" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}

has_component() {
    local needle="$1"
    local component
    local selected=()

    if [[ "$INSTALL_ALL" == "1" ]]; then
        return 0
    fi

    IFS=',' read -r -a selected <<< "$SELECTED_COMPONENTS"
    for component in "${selected[@]}"; do
        if [[ "$component" == "$needle" ]]; then
            return 0
        fi
    done

    return 1
}

validate_component() {
    local needle="$1"
    local component

    for component in "${COMPONENTS[@]}"; do
        if [[ "$component" == "$needle" ]]; then
            return 0
        fi
    done

    log "Unknown component: $needle"
    return 1
}

backup_path() {
    local target="$1"
    local backup

    if [[ ! -e "$target" && ! -L "$target" ]]; then
        return 0
    fi

    backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    run mv "$target" "$backup"
    if [[ "$DRY_RUN" == "1" ]]; then
        log "Would back up $target to $backup"
    else
        log "Backed up $target to $backup"
    fi
}

install_template() {
    local source="$1"
    local target="$2"
    local mode="${3:-replace}"

    if [[ "$mode" == "create-only" && ( -e "$target" || -L "$target" ) ]]; then
        log "Skipped existing $target"
        return 0
    fi

    run mkdir -p "$(dirname "$target")"

    if [[ "$mode" == "replace" ]]; then
        backup_path "$target"
    fi

    run cp "$source" "$target"
    if [[ "$DRY_RUN" == "1" ]]; then
        log "Would install $target"
    else
        log "Installed $target"
    fi
}

install_brew_packages() {
    local description="$1"
    shift

    if ! command -v brew >/dev/null 2>&1; then
        log "Homebrew is not installed. Skipping $description."
        return 0
    fi

    run brew install "$@"
}

install_brew_cli() {
    install_brew_packages "common CLI tools" \
        wget curl git git-lfs unzip zip trzsz tmux vim neovim kubectl kubectx helm
}

install_brew_dev() {
    install_brew_packages "development runtimes" \
        "python@3.13" go "temurin@21" "node@22"
}

install_shell_tools() {
    install_brew_packages "shell helper tools" thefuck jump
}

install_omz() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "Oh My Zsh already exists. Skipping."
        return 0
    fi

    run sh -c 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
}

install_zsh_plugins() {
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    run mkdir -p "$zsh_custom/plugins"

    if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        run git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    else
        log "zsh-autosuggestions already exists. Skipping."
    fi

    if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        run git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
    else
        log "zsh-syntax-highlighting already exists. Skipping."
    fi
}

install_starship_bin() {
    if command -v starship >/dev/null 2>&1; then
        log "Starship already exists. Skipping."
        return 0
    fi

    run sh -c 'curl -sS https://starship.rs/install.sh | sh -s -- -y'
}

install_kubernetes() {
    install_brew_packages "optional Kubernetes workflow tools" kubevpn
}

install_zshrc() {
    install_template "$ROOT_DIR/.zshrc" "$HOME/.zshrc" replace
}

install_zshrc_local() {
    install_template "$ROOT_DIR/.zshrc.local.example" "$HOME/.zshrc.local" create-only
}

install_vimrc() {
    install_template "$ROOT_DIR/.vimrc" "$HOME/.vimrc" replace
}

install_starship_config() {
    install_template "$ROOT_DIR/starship.toml" "$HOME/.config/starship.toml" replace
}

install_ghostty_config() {
    install_template "$ROOT_DIR/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" replace
}

install_raycast_notes() {
    log "Raycast is intentionally not imported automatically."
    log "Review raycast.template.md and raycast_cong.rayconfig before importing in Raycast."
}

install_component() {
    local component="$1"

    case "$component" in
        brew-cli) install_brew_cli ;;
        brew-dev) install_brew_dev ;;
        shell-tools) install_shell_tools ;;
        omz) install_omz ;;
        zsh-plugins) install_zsh_plugins ;;
        starship-bin) install_starship_bin ;;
        kubernetes) install_kubernetes ;;
        zshrc) install_zshrc ;;
        zshrc-local) install_zshrc_local ;;
        vimrc) install_vimrc ;;
        starship-config) install_starship_config ;;
        ghostty-config) install_ghostty_config ;;
        raycast-notes) install_raycast_notes ;;
        *) validate_component "$component" ;;
    esac
}

prompt_components() {
    local component
    local chosen=()

    for component in "${COMPONENTS[@]}"; do
        if confirm "Install $component?"; then
            chosen+=("$component")
        fi
    done

    SELECTED_COMPONENTS="$(IFS=','; echo "${chosen[*]}")"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            INSTALL_ALL=1
            shift
            ;;
        --components)
            if [[ $# -lt 2 ]]; then
                log "--components requires a comma-separated list"
                exit 1
            fi
            SELECTED_COMPONENTS="$2"
            shift 2
            ;;
        --components=*)
            SELECTED_COMPONENTS="${1#*=}"
            shift
            ;;
        --yes|-y)
            YES=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --list)
            list_components
            exit 0
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            log "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ "$INSTALL_ALL" != "1" && -z "$SELECTED_COMPONENTS" ]]; then
    prompt_components
fi

if [[ "$INSTALL_ALL" != "1" && -z "$SELECTED_COMPONENTS" ]]; then
    log "No components selected."
    exit 0
fi

if [[ -n "$SELECTED_COMPONENTS" ]]; then
    IFS=',' read -r -a selected <<< "$SELECTED_COMPONENTS"
    for component in "${selected[@]}"; do
        validate_component "$component"
    done
fi

for component in "${COMPONENTS[@]}"; do
    if has_component "$component"; then
        log "==> $component"
        install_component "$component"
    fi
done
