#!/bin/bash
#
# macOS defaults — safe to re-run. Restarts Dock, Finder and SystemUIServer at the end.

set -e

echo "Applying macOS defaults..."

# ==============================================================================
# Dock
# ==============================================================================

# Icon size
defaults write com.apple.dock tilesize -int 52

# Scale effect for minimize
defaults write com.apple.dock mineffect -string 'scale'

# Minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Make icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# NOTE: expose-animation-duration and expose-group-by-app are no-ops on Ventura+.
# Mission Control animations are now controlled by the system.

# Enable App Expose gesture (swipe down with 3/4 fingers to show app windows)
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Automatically rearrange spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool true

# Enable opening application animations
defaults write com.apple.dock launchanim -bool true

# Hot corners
# Top left -> Put display to sleep
defaults write com.apple.dock wvous-tl-corner -int 10
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right -> Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left -> Mission Control
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right -> Show application windows
defaults write com.apple.dock wvous-br-corner -int 3
defaults write com.apple.dock wvous-br-modifier -int 0

# ==============================================================================
# Finder
# ==============================================================================

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string 'clmv'

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current directory by default
defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'

# Disable warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Open new Finder windows in the home folder
defaults write com.apple.finder NewWindowTarget -string 'PfHm'
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show external drives on the Desktop, hide internal drives
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# NOTE: _FXShowPosixPathInTitle no longer works on Ventura+.
# Apple redesigned the Finder title bar.

# ==============================================================================
# Window Manager
# ==============================================================================

# Hide Desktop items
defaults write com.apple.WindowManager HideDesktop -bool true

# Disable margins around tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Group windows by application in Mission Control
defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1

# ==============================================================================
# Trackpad
# ==============================================================================

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1

# Two-finger secondary click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1

# Three-finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1

# Full gesture suite
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHandResting -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad USBMouseStopsTrackpad -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad UserPreferences -int 1

# ==============================================================================
# Mouse
# ==============================================================================

# Two-button mode
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string 'TwoButton'
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string 'TwoButton'
defaults write com.apple.AppleMultitouchMouse MouseHorizontalScroll -int 1
defaults write com.apple.AppleMultitouchMouse MouseMomentumScroll -int 1
defaults write com.apple.AppleMultitouchMouse MouseOneFingerDoubleTapGesture -int 0
defaults write com.apple.AppleMultitouchMouse MouseTwoFingerDoubleTapGesture -int 3
defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchMouse MouseVerticalScroll -int 1
defaults write com.apple.AppleMultitouchMouse UserPreferences -int 1

# Mouse tracking speed
defaults write -g com.apple.mouse.scaling 2

# ==============================================================================
# Keyboard
# ==============================================================================

# Enable full keyboard access for all controls
defaults write -g AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Fast key repeat
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 25

# Enable press-and-hold
defaults write -g ApplePressAndHoldEnabled -bool true

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable automatic correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Disable automatic period substitution
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# ==============================================================================
# Battery
# ==============================================================================

# Show battery percentage in menu bar
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# ==============================================================================
# Screenshots
# ==============================================================================

# Save screenshots to the Desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string 'png'

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Don't show thumbnail after taking screenshot
defaults write com.apple.screencapture show-thumbnail -bool false

# ==============================================================================
# UI & UX
# ==============================================================================

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Always show scrollbars
defaults write -g AppleShowScrollBars -string 'Always'

# Disable "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Make crash reports appear as notifications
defaults write com.apple.CrashReporter UseUNC 1

# Automatically quit the printer app once print jobs complete
defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true

# Set sidebar icon size to medium
defaults write -g NSTableViewDefaultSizeMode -int 2

# Disable the focus ring animation
defaults write -g NSUseAnimatedFocusRing -bool false

# ==============================================================================
# Sound
# ==============================================================================

# Play feedback when volume is changed
defaults write NSGlobalDomain "com.apple.sound.beep.feedback" -bool true

# ==============================================================================
# Language & Region
# ==============================================================================

# Metric units
defaults write -g AppleMeasurementUnits -string 'Centimeters'
defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Celsius
defaults write -g AppleTemperatureUnit -string 'Celsius'

# 24-hour time format
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Start week on Monday (gregorian calendar: 1=Sun, 2=Mon, …, 7=Sat)
defaults write NSGlobalDomain AppleFirstWeekday -dict gregorian -int 2

# Set timezone to London
sudo systemsetup -settimezone "Europe/London" 2>/dev/null || true

# Menu bar clock: 24h, show day of week, hide date
defaults write com.apple.menuextra.clock ShowAMPM -bool false
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0

# ==============================================================================
# Keyboard Shortcuts
# ==============================================================================

# Cmd+§ to move focus to next window of same application
# Key 27 = "Move focus to next window" in System Settings > Keyboard > Shortcuts
# § key: ASCII 167 (0xA7), keycode 10, Cmd modifier = 1048576
/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:27" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27 dict" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:enabled bool true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value dict" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:type string standard" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters:0 integer 167" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters:1 integer 10" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters:2 integer 1048576" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# ==============================================================================
# Screensaver
# ==============================================================================

# NOTE: screensaver idleTime may not work on Ventura+.
# Configure via System Settings > Lock Screen if needed.
defaults write com.apple.screensaver idleTime -int 0

# ==============================================================================
# Apply changes
# ==============================================================================

echo "Restarting affected applications..."
killall "Dock" &> /dev/null || true
killall "Finder" &> /dev/null || true
killall "SystemUIServer" &> /dev/null || true
killall "cfprefsd" &> /dev/null || true

echo "macOS defaults applied."
