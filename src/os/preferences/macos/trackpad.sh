#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Trackpad\n\n"

execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true && \
         defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1" \
    "Enable 'Tap to click'"

execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true && \
         defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1 && \
         defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0 && \
         defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0 && \
         defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1" \
    "Map 'click or tap with two fingers' to the secondary click"

execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -int 0 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 0 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHandResting -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1 && \
         defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad USBMouseStopsTrackpad -int 0 && \
         defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad UserPreferences -int 1" \
    "Other Trackpad prefs"
