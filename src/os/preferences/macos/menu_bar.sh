#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   MenuBar\n\n"

execute "defaults write com.apple.systemuiserver menuExtras -array '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' '/System/Library/CoreServices/Menu Extras/AirPort.menu' '/System/Library/CoreServices/Menu Extras/Battery.menu' '/System/Library/CoreServices/Menu Extras/Clock.menu'" \
    "Set Menu Bar"

execute "defaults write com.apple.menuextra.battery ShowPercent -string 'YES'" \
    "Show battery percentage from the menu bar"

execute "defaults write com.apple.menuextra.battery ShowTime -string 'YES'" \
    "Show remaining battery time"

execute "killall 'SystemUIServer' &> /dev/null" \
    "Apply changes by restarting UI"
