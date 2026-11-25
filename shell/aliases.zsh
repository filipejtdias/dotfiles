# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cd..="cd .."

# Listing
alias l="ls -la"
alias ll="ls -l"

# General
alias k="clear"
alias q="exit"
alias :q="exit"
alias g="git"
alias o="open"
alias subl='open -a "Sublime Text"'
alias path='printf "%b\n" "${PATH//:/\\n}"'

# Homebrew
alias brewd="brew doctor"
alias brewi="brew install"
alias brewr="brew uninstall"
alias brews="brew search"
alias brewu="brew update && brew upgrade && brew cleanup"

# Shell
alias reload="source ~/.zshrc"
alias aliases="subl ~/code/dotfiles/shell/aliases.zsh"

# Folders
alias desktop="cd ~/Desktop"
alias code="cd ~/code"

# IP
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local-ip="ipconfig getifaddr en0"
alias public-ip="dig +short myip.opendns.com @resolver1.opendns.com"

# DNS
alias dns-clear-cache="sudo dscacheutil -flushcache; \
                       sudo killall -HUP mDNSResponder"

# Desktop icons
alias hide-desktop-icons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias show-desktop-icons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Xcode
alias clear-deriveddata='rm -rf ~/Library/Developer/Xcode/DerivedData/'
alias xcodeclean='rm -frd ~/Library/Developer/Xcode/DerivedData/* && rm -frd ~/Library/Caches/com.apple.dt.Xcode/*; open -a Xcode'

# Utilities
alias map="xargs -n1"
alias http-server="python3 -m http.server 8000"
alias empty-trash="sudo rm -frv /Volumes/*/.Trashes; \
                   sudo rm -frv ~/.Trash; \
                   sudo rm -frv /private/var/log/asl/*.asl; \
                   sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
alias show-connected-devices='arp -i bridge100 -a'

# Claude
alias c="claude --dangerously-skip-permissions"