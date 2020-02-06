#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Magic Mouse\n\n"

execute "defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string 'TwoButton' && \
         defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string 'TwoButton' && \
         defaults write com.apple.AppleMultitouchMouse MouseHorizontalScroll -int 1 && \
         defaults write com.apple.AppleMultitouchMouse MouseMomentumScroll -int 1 && \
         defaults write com.apple.AppleMultitouchMouse MouseOneFingerDoubleTapGesture -int 0 && \
         defaults write com.apple.AppleMultitouchMouse MouseTwoFingerDoubleTapGesture -int 3 && \
         defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -int 2 && \
         defaults write com.apple.AppleMultitouchMouse MouseVerticalScroll -int 1 && \
         defaults write com.apple.AppleMultitouchMouse UserPreferences -int 1" \
    "Magic mouse"

execute "defaults write -g com.apple.mouse.scaling 2" \
    "Mouse speed"

execute "defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 2 && \
         defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 2" \
    "Enable tap to click for this user and for the login screen"
