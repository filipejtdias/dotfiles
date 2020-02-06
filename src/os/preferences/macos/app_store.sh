#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   App Store\n\n"

execute "defaults write com.apple.appstore ShowDebugMenu -bool true" \
    "Enable debug menu"

execute "defaults write com.apple.commerce AutoUpdate -bool false" \
    "Turn on auto-update"

execute "defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true" \
    "Enable automatic update check"

execute "defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0" \
    "Download newly available updates in background"

execute "defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1" \
    "Install System data files and security updates"

execute "defaults write com.apple.appstore WebKitDeveloperExtras -bool true" \
	"Enable the WebKit Developer Tools in the Mac App Store"

execute "defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1" \
	"Check for software updates daily, not just once per week"

execute "defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1" \
	"Automatically download apps purchased on other Macs"

execute "defaults write com.apple.commerce AutoUpdateRestartRequired -bool false" \
	"Allow the App Store to reboot machine on macOS updates"

killall "App Store" &> /dev/null
