#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Dock\n\n"

execute "defaults write com.apple.dock autohide -bool false" \
    "Automatically hide/show the Dock"

execute "defaults write com.apple.dock autohide-delay -float 0" \
    "Disable the hide Dock delay"

execute "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true" \
    "Enable spring loading for all Dock items"

execute "defaults write com.apple.dock expose-animation-duration -float 0.1" \
    "Make all Mission Control related animations faster."

execute "defaults write com.apple.dock expose-group-by-app -bool true" \
    "Group windows by application in Mission Control"

execute "defaults write com.apple.dock launchanim -bool true" \
    "Enable the opening of an application from the Dock animations."

execute "defaults write com.apple.dock mineffect -string 'scale'" \
    "Change minimize/maximize window effect"

execute "defaults write com.apple.dock minimize-to-application -bool true" \
    "Reduce clutter by minimizing windows into their application icons"

execute "defaults write com.apple.dock mru-spaces -bool true" \
    "Automatically rearrange spaces based on most recent use"

execute "defaults write com.apple.dock persistent-apps -array && \
         defaults write com.apple.dock persistent-others -array " \
    "Wipe all app icons"

execute "defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type=\"spacer-tile\";}'" \
    "Add a spacer to the left side of the Dock (where the applications are)"

execute "defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type=\"spacer-tile\";}'" \
    "Add a spacer to the right side of the Dock (where the Trash is)"

execute "defaults write com.apple.dock show-process-indicators -bool true" \
    "Show indicator lights for open applications"

execute "defaults write com.apple.dock show-recents -bool false" \
    "Do not show recent applications in Dock"

execute "defaults write com.apple.dock showhidden -bool true" \
    "Make icons of hidden applications translucent"

execute "defaults write com.apple.dock tilesize -int 52" \
    "Set icon size"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

execute "defaults write com.apple.dock wvous-tl-corner -int 10 && \
         defaults write com.apple.dock wvous-tl-modifier -int 0" \
    "Top left screen corner → Put display to sleep"

execute "defaults write com.apple.dock wvous-tr-corner -int 4 && \
         defaults write com.apple.dock wvous-tr-modifier -int 0" \
    "Top right screen corner → Desktop"

execute "defaults write com.apple.dock wvous-bl-corner -int 2 && \
         defaults write com.apple.dock wvous-bl-modifier -int 0" \
    "Bottom left screen corner → Mission Control"

execute "defaults write com.apple.dock wvous-br-corner -int 3 && \
         defaults write com.apple.dock wvous-br-modifier -int 0" \
    "Bottom right screen corner → Show application windows"

killall "Dock" &> /dev/null
