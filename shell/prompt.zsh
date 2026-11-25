# Prompt colors (Solarized-inspired)
#
# username (orange) @ hostname (yellow) : directory (green) on branch (cyan)

autoload -Uz vcs_info

# Configure vcs_info for git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:git:*' formats ' %F{white}on %F{cyan}%b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{white}on %F{cyan}%b|%a%u%c%f'

precmd() {
    vcs_info
}

# Allow prompt substitution
setopt PROMPT_SUBST

# PS1: bold orange user @ yellow host : green dir (git info) newline $
PROMPT='%B%F{166}%n%f%F{white}@%f%F{136}%m%f%F{white}: %f%F{green}%~%f${vcs_info_msg_0_}%b
%F{white}$ %f'

# PS2: continuation prompt
PROMPT2='> '
