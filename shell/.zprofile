# Homebrew - detect architecture for correct path
if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
else
    eval "$(/usr/local/bin/brew shellenv zsh)"
fi
