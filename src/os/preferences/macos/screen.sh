#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Screen\n\n"

execute "defaults write com.apple.screensaver idleTime -int 0" \
    "System Preferences > Desktop & Screen Saver > Start after: Never"

execute "defaults write com.apple.screencapture location -string '${HOME}/Desktop'" \
    "Save screenshots to the desktop"

execute "defaults write com.apple.screencapture type -string 'png'" \
    "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"

execute "defaults write com.apple.screencapture disable-shadow -bool true" \
    "Disable shadow in screenshots"

execute "defaults write com.apple.screencapture show-thumbnail -bool false" \
    "Do not show thumbnail"