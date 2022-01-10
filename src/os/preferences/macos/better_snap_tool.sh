#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Better Snap Tool\n\n"

execute "defaults write com.hegenberg.BetterSnapTool launchOnStartup -bool true" \
    "Launch on Startup"
