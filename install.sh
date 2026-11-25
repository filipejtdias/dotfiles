#!/bin/bash
#
# Dotfiles installer
#
# One-liner:  bash -c "$(curl -fsSL https://raw.github.com/filipejtdias/dotfiles/main/install.sh)"
# Or locally: ./install.sh [-y] [--profile <name>] [--reconfigure]
#   -y                 skips confirmations (git identity comes from GIT_NAME / GIT_EMAIL)
#   --profile <name>   any directory under profiles/ (default: personal);
#                      saved to ~/.dotfiles-profile and reused on later runs
#   --reconfigure      asks for the git identity again, offering the saved values as defaults
# Via curl with a profile:
#   bash -c "$(curl -fsSL https://raw.github.com/filipejtdias/dotfiles/main/install.sh)" -- --profile work

set -e

if [ "$(uname -s)" != "Darwin" ]; then
    echo "This installer supports macOS only." >&2
    exit 1
fi

# If running via curl (not from a cloned repo), clone first and re-exec
DOTFILES_DIR="$HOME/code/dotfiles"
if [ ! -f "${BASH_SOURCE[0]:-}" ] || [ "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" != "$DOTFILES_DIR" ]; then
    if [ -d "$DOTFILES_DIR/.git" ]; then
        echo "Updating dotfiles..."
        git -C "$DOTFILES_DIR" pull --rebase --quiet
    else
        echo "Cloning dotfiles..."
        git clone https://github.com/filipejtdias/dotfiles.git "$DOTFILES_DIR"
    fi
    exec bash "$DOTFILES_DIR/install.sh" "$@"
fi

BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Parse flags
SKIP_QUESTIONS=false
PROFILE=""
RECONFIGURE=false
while [[ "$1" ]]; do
    case "$1" in
        -y|--yes) SKIP_QUESTIONS=true ;;
        --reconfigure) RECONFIGURE=true ;;
        --profile=*) PROFILE="${1#--profile=}" ;;
        --profile)
            shift
            PROFILE="$1"
            ;;
    esac
    shift
done

print_header()  { printf "${PURPLE}$1${NC}\n"; }
print_success() { printf "${GREEN}  [ok] $1${NC}\n"; }
print_skip()    { printf "${YELLOW}  [skip] $1${NC}\n"; }
print_error()   { printf "${RED}  [error] $1${NC}\n"; }

confirm() {
    if $SKIP_QUESTIONS; then return 0; fi
    printf "${YELLOW}  $1 (y/n) ${NC}"
    read -r -n 1 answer || answer=""
    printf "\n"
    [[ "$answer" =~ ^[Yy]$ ]]
}

# ==============================================================================
# Profile
# ==============================================================================

PROFILE_FILE="$HOME/.dotfiles-profile"

# No flag: reuse the saved profile, otherwise default to personal
if [ -z "$PROFILE" ] && [ -f "$PROFILE_FILE" ]; then
    PROFILE="$(tr -d '[:space:]' < "$PROFILE_FILE")"
fi
# Nothing saved and no flag: short prompt (skipped with -y)
if [ -z "$PROFILE" ] && ! $SKIP_QUESTIONS; then
    printf "  Profile [personal]: "
    read -r PROFILE || printf "\n  No input, using default profile (personal)\n"
fi
PROFILE="${PROFILE:-personal}"

# Validate (also guards against path tricks like ../ in the name)
if [[ ! "$PROFILE" =~ ^[A-Za-z0-9._-]+$ ]] || [[ "$PROFILE" == .* ]] || [ ! -d "$DOTFILES_DIR/profiles/$PROFILE" ]; then
    printf "${RED}  [error] Unknown profile '%s'. Available:${NC}" "$PROFILE"
    for dir in "$DOTFILES_DIR"/profiles/*/; do
        printf " %s" "$(basename "$dir")"
    done
    printf "\n"
    exit 1
fi
PROFILE_DIR="$DOTFILES_DIR/profiles/$PROFILE"

# ==============================================================================
# Architecture detection
# ==============================================================================

ARCH="$(uname -m)"
if [ "$ARCH" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi

print_header "\nDotfiles installer"
echo "  Architecture: $ARCH"
echo "  Homebrew prefix: $HOMEBREW_PREFIX"
echo "  Dotfiles dir: $DOTFILES_DIR"
echo "  Profile: $PROFILE"
echo ""

# ==============================================================================
# Collect all user input upfront
# ==============================================================================

print_header "Configuration"
echo ""

DO_BREWFILE=false
DO_MACOS_DEFAULTS=false
DO_APPS=false
DO_URLS=false
GIT_NAME="${GIT_NAME:-}"
GIT_EMAIL="${GIT_EMAIL:-}"
GITCONFIG_LOCAL="$HOME/.gitconfig.local"

# Reads one git identity value into the variable named by $3. A value already in
# ~/.gitconfig.local is kept without asking, unless --reconfigure (Enter keeps it).
ask_git_value() {
    local label="$1" key="$2" var="$3" current answer
    current="$(git config --file "$GITCONFIG_LOCAL" "$key" 2>/dev/null || true)"
    if [ -n "$current" ] && ! $RECONFIGURE; then
        printf -v "$var" '%s' "$current"
        return
    fi
    printf "  %s%s: " "$label" "${current:+ [$current]}"
    read -r answer || answer=""
    printf -v "$var" '%s' "${answer:-$current}"
}

DOTFILES_XCODE_APP="${DOTFILES_XCODE_APP:-/Applications/Xcode.app}"
XCODE_APP_STORE_ID=497799835

if $SKIP_QUESTIONS; then
    DO_BREWFILE=true
    DO_MACOS_DEFAULTS=true
    DO_APPS=true
else
    confirm "Install Homebrew packages from Brewfile?" && DO_BREWFILE=true
    confirm "Apply macOS defaults (Dock, Finder, Trackpad, Energy, etc.)?" && DO_MACOS_DEFAULTS=true
    confirm "Apply app defaults (SourceTree, Safari, etc.)?" && DO_APPS=true
    confirm "Open download pages for manual installs (urls.txt)?" && DO_URLS=true

    echo ""
    ask_git_value "Git name for the '$PROFILE' profile" user.name GIT_NAME
    ask_git_value "Git email for the '$PROFILE' profile" user.email GIT_EMAIL
fi

# ==============================================================================
# Ask for sudo password upfront (keeps it alive for the rest of the script)
# ==============================================================================

# Always needed: the mandatory Xcode step selects Xcode and accepts its license with sudo
NEEDS_SUDO=true

if $NEEDS_SUDO; then
    echo ""
    print_header "Sudo"
    echo "  Some settings require administrator privileges."
    sudo -v
    # Keep sudo alive in the background. It cannot prompt, so if the credential
    # is reset mid-run (Homebrew or a cask installer can do that) it warns once;
    # refresh_sudo re-authenticates at the steps that need it.
    (
        warned=false
        while true; do
            if sudo -n true 2> /dev/null; then
                warned=false
            elif ! $warned; then
                warned=true
                printf "${YELLOW}  [warn] sudo session expired; you may be asked for your password again${NC}\n" >&2
            fi
            sleep 30
            kill -0 "$$" 2> /dev/null || exit
        done
    ) &
    SUDO_KEEPALIVE_PID=$!
    trap 'kill "$SUDO_KEEPALIVE_PID" 2> /dev/null || true' EXIT
fi

# Re-authenticates only if the cached credential lapsed (no prompt otherwise)
refresh_sudo() {
    if $NEEDS_SUDO; then sudo -v; fi
}

echo ""
print_header "Installing — no more prompts from here on"
echo ""

# ==============================================================================
# Homebrew
# ==============================================================================

print_header "Homebrew"

# Ensure brew is available in this shell session (handles both fresh
# installs and cases where the parent shell hasn't sourced shellenv yet)
if ! command -v brew &> /dev/null; then
    if [ -x "$HOMEBREW_PREFIX/bin/brew" ]; then
        echo "  Homebrew found at $HOMEBREW_PREFIX but not in PATH. Loading..."
        eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
        print_success "Homebrew loaded into current shell"
    else
        echo "  Homebrew not found. Installing..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Load brew into this shell session so subsequent commands work
        eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
        print_success "Homebrew installed and loaded"
    fi
else
    print_skip "Homebrew already installed"
fi

# Verify brew is usable before continuing
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not available. Cannot continue."
    exit 1
fi

# Xcode comes before everything else that needs it (Brewfile tools, Dock, app defaults).
# It is installed from the Mac App Store, which requires being signed in. The Xcode
# license is then accepted on the user's behalf (running the installer means agreeing).
install_xcode() {
    if [ -d "$DOTFILES_XCODE_APP" ]; then
        print_skip "Xcode already installed"
        return 0
    fi
    echo "  Installing Xcode from the Mac App Store (download is over 10 GB, this may take a while)..."
    if ! command -v mas &> /dev/null; then
        brew install mas || true
    fi
    if command -v mas &> /dev/null && mas install "$XCODE_APP_STORE_ID" && [ -d "$DOTFILES_XCODE_APP" ]; then
        print_success "Xcode installed"
        return 0
    fi
    print_error "Xcode could not be installed. Sign in to the App Store (usually the cause), then re-run ./install.sh (it is safe to re-run)."
    print_error "No later steps were run. Xcode is required."
    return 1
}

accept_xcode_license() {
    echo "  Accepting the Xcode license (you agree to Apple's Xcode terms by running this installer)"
    refresh_sudo
    # A fresh Mac only has the Command Line Tools shim; xcodebuild needs the full Xcode selected
    if [ "$(xcode-select -p 2> /dev/null)" != "$DOTFILES_XCODE_APP/Contents/Developer" ]; then
        if sudo xcode-select -s "$DOTFILES_XCODE_APP/Contents/Developer"; then
            print_success "Selected $DOTFILES_XCODE_APP as the active developer directory"
        else
            print_error "Could not select Xcode. Run: sudo xcode-select -s \"$DOTFILES_XCODE_APP/Contents/Developer\" then re-run ./install.sh"
            return 1
        fi
    fi
    if xcodebuild -license check &> /dev/null; then
        print_skip "Xcode license already accepted"
    elif sudo xcodebuild -license accept; then
        print_success "Xcode license accepted"
    else
        print_error "Could not accept the Xcode license. Run: sudo xcodebuild -license accept then re-run ./install.sh"
        return 1
    fi
    if sudo xcodebuild -runFirstLaunch; then
        print_success "Xcode first launch tasks done"
    else
        print_skip "Warning: xcodebuild -runFirstLaunch failed; open Xcode once to finish its setup"
    fi
}

print_header "\nXcode"
install_xcode || exit 1
accept_xcode_license || exit 1

# Newer Homebrew refuses to load formulae/casks from third-party taps until they
# are trusted, which makes `brew bundle` fail. Trust only the taps listed here.
TRUSTED_TAPS=(
    "cameroncooke/axe"
    "getsentry/xcodebuildmcp"
)

if $DO_BREWFILE; then
    if brew commands 2>/dev/null | grep -qx trust; then
        trusted_json="$(brew trust --json=v1 2>/dev/null || true)"
        tapped="$(brew tap 2>/dev/null || true)"
        for tap in "${TRUSTED_TAPS[@]}"; do
            # Tap first (a fresh machine has none yet), then trust, as in Homebrew's Tap-Trust docs
            if ! grep -qxF "$tap" <<< "$tapped"; then
                if brew tap "$tap"; then
                    print_success "Tapped $tap"
                else
                    print_error "Could not tap $tap; brew bundle may fail for it"
                    continue
                fi
            fi
            if grep -qF "\"$tap\"" <<< "$trusted_json"; then
                print_skip "Tap $tap already trusted"
            elif brew trust --tap "$tap"; then
                print_success "Trusted tap $tap"
            else
                print_error "Could not trust tap $tap; brew bundle may fail for it"
            fi
        done
    else
        print_skip "This Homebrew has no 'brew trust'; skipping tap trust"
    fi
    if grep -q '^mas ' "$DOTFILES_DIR/Brewfile" "$PROFILE_DIR/Brewfile" 2> /dev/null; then
        echo "  Mac App Store apps are listed: make sure you're signed in to the App Store first."
    fi
    refresh_sudo
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "Brewfile packages installed"
    if [ -f "$PROFILE_DIR/Brewfile" ]; then
        refresh_sudo
        brew bundle --file="$PROFILE_DIR/Brewfile"
        print_success "Profile '$PROFILE' Brewfile packages installed"
    fi
else
    print_skip "Brewfile"
fi

# Optional: open the URLs listed in urls.txt (base, then profile) for manual
# installs that are not on Homebrew or the Mac App Store
open_urls() {
    local file="$1" url
    [ -f "$file" ] || return 0
    while IFS= read -r url || [ -n "$url" ]; do
        url="${url%%#*}"
        url="$(echo "$url" | tr -d '[:space:]')"
        [ -n "$url" ] || continue
        open "$url"
        print_success "Opened $url"
    done < "$file"
}

if $DO_URLS; then
    open_urls "$DOTFILES_DIR/urls.txt"
    open_urls "$PROFILE_DIR/urls.txt"
else
    print_skip "Manual download URLs"
fi

# ==============================================================================
# Directories
# ==============================================================================

print_header "\nDirectories"

# Creates the directories listed in directories.txt (base, then profile).
# Only paths under $HOME are allowed; paths containing .. are refused.
create_directories() {
    local file="$1" dir
    [ -f "$file" ] || return 0
    while IFS= read -r dir || [ -n "$dir" ]; do
        dir="${dir%%#*}"
        dir="${dir#"${dir%%[![:space:]]*}"}"
        dir="${dir%"${dir##*[![:space:]]}"}"
        [ -n "$dir" ] || continue
        case "$dir" in
            "~") dir="$HOME" ;;
            "~/"*) dir="$HOME/${dir#"~/"}" ;;
        esac
        if [[ "$dir" == *..* ]] || [[ "$dir" != "$HOME"/* ]]; then
            print_error "Refusing $dir (must be under $HOME, no '..')"
            continue
        fi
        if [ -d "$dir" ]; then
            print_skip "$dir (already exists)"
        elif [ -e "$dir" ] || [ -L "$dir" ]; then
            print_error "$dir exists and is not a directory"
        elif mkdir -p "$dir"; then
            print_success "Created $dir"
        else
            print_error "Could not create $dir"
        fi
    done < "$file"
}

create_directories "$DOTFILES_DIR/directories.txt"
create_directories "$PROFILE_DIR/directories.txt"

# ==============================================================================
# Symlinks
# ==============================================================================

print_header "\nSymlinks"

create_symlink() {
    local source="$1"
    local target="$2"

    # Already correctly linked
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        print_skip "$target (already linked)"
        return
    fi

    # Back up existing file
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        print_success "Backed up $target -> $BACKUP_DIR/"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    ln -sf "$source" "$target"
    print_success "$target -> $source"
}

create_symlink "$DOTFILES_DIR/shell/.zshrc"            "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/shell/.zprofile"         "$HOME/.zprofile"
create_symlink "$DOTFILES_DIR/git/.gitconfig"          "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/.gitignore_global"   "$HOME/.gitignore_global"
create_symlink "$DOTFILES_DIR/git/.gitattributes"      "$HOME/.gitattributes"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
create_symlink "$DOTFILES_DIR/ssh/config"              "$HOME/.ssh/config"
create_symlink "$DOTFILES_DIR/shell/.curlrc"           "$HOME/.curlrc"
create_symlink "$DOTFILES_DIR/shell/.inputrc"          "$HOME/.inputrc"

# Profile layer: link the profile's files, or drop a stale link from another profile
link_profile_file() {
    local source="$1"
    local target="$2"

    if [ -f "$source" ]; then
        create_symlink "$source" "$target"
    elif [ -L "$target" ] && [[ "$(readlink "$target")" == "$DOTFILES_DIR/profiles/"* ]]; then
        rm "$target"
        print_success "Removed stale profile link $target"
    fi
}

echo "$PROFILE" > "$PROFILE_FILE"
print_success "Profile '$PROFILE' saved to $PROFILE_FILE"
link_profile_file "$PROFILE_DIR/gitconfig"   "$HOME/.gitconfig.profile"
link_profile_file "$PROFILE_DIR/ssh_config"  "$HOME/.ssh/config.profile"

# Create local aliases file if it doesn't exist (not committed, machine-specific)
if [ ! -f "$DOTFILES_DIR/shell/aliases.local.zsh" ]; then
    cat > "$DOTFILES_DIR/shell/aliases.local.zsh" << 'EOF'
# Local aliases — machine-specific, not committed to git
EOF
    print_success "Created shell/aliases.local.zsh"
else
    print_skip "shell/aliases.local.zsh already exists"
fi

# ==============================================================================
# Git user config
# ==============================================================================

print_header "\nGit identity"

# git config updates existing keys in place and keeps the rest of the file
write_git_identity() {
    [ -n "$GIT_NAME" ] && git config --file "$GITCONFIG_LOCAL" user.name "$GIT_NAME"
    [ -n "$GIT_EMAIL" ] && git config --file "$GITCONFIG_LOCAL" user.email "$GIT_EMAIL"
    if [ -n "$(git config --file "$GITCONFIG_LOCAL" user.name 2>/dev/null)" ] \
        && [ -n "$(git config --file "$GITCONFIG_LOCAL" user.email 2>/dev/null)" ]; then
        print_success "Git identity set in ~/.gitconfig.local"
    else
        print_skip "Warning: git identity is unset. Re-run with --reconfigure, or set GIT_NAME and GIT_EMAIL with -y"
    fi
}
write_git_identity

# ==============================================================================
# macOS defaults
# ==============================================================================

print_header "\nmacOS defaults"

if $DO_MACOS_DEFAULTS; then
    refresh_sudo
    bash "$DOTFILES_DIR/macos/defaults.sh"
    # dock.sh picks up the profile's dock.sh via these variables
    DOTFILES_DIR="$DOTFILES_DIR" DOTFILES_PROFILE="$PROFILE" bash "$DOTFILES_DIR/macos/dock.sh"
    refresh_sudo
    bash "$DOTFILES_DIR/macos/energy.sh"
    print_success "macOS defaults applied"
else
    print_skip "macOS defaults"
fi

# ==============================================================================
# App defaults
# ==============================================================================

print_header "\nApp defaults"

if $DO_APPS; then
    refresh_sudo
    bash "$DOTFILES_DIR/apps/defaults.sh"
    if [ -f "$PROFILE_DIR/defaults.sh" ]; then
        bash "$PROFILE_DIR/defaults.sh"
    fi
    print_success "App defaults applied"
else
    print_skip "App defaults"
fi

# ==============================================================================
# Done
# ==============================================================================

echo ""
print_header "Done!"
if [ -d "$BACKUP_DIR" ]; then
    echo "  Backups saved to: $BACKUP_DIR"
fi
echo "  Open a new terminal to load the new shell config."
echo ""
