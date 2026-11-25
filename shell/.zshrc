# Dotfiles directory
export DOTFILES="$HOME/code/dotfiles"

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Zsh options
setopt AUTO_CD              # cd into directories by typing the name
setopt CORRECT              # Autocorrect typos in commands
setopt EXTENDED_GLOB        # Extended pattern matching
setopt NO_CASE_GLOB         # Case-insensitive globbing
setopt HIST_IGNORE_DUPS     # Don't store duplicate history entries
setopt APPEND_HISTORY       # Append to history file, don't overwrite

# Source modular config files
for file in "$DOTFILES/shell/"*.zsh; do
    [[ "$file" == *.local.zsh ]] && continue
    [ -r "$file" ] && source "$file"
done
unset file

# Profile layer (profiles/<name>/zsh/*.zsh), loaded after base, before *.local.zsh
DOTFILES_PROFILE="$(cat "$HOME/.dotfiles-profile" 2> /dev/null || echo personal)"
export DOTFILES_PROFILE
for file in "$DOTFILES/profiles/$DOTFILES_PROFILE/zsh/"*.zsh(N); do
    [ -r "$file" ] && source "$file"
done
unset file

# Machine-local overrides
for file in "$DOTFILES/shell/"*.local.zsh(N); do
    [ -r "$file" ] && source "$file"
done
unset file

if [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
fi
