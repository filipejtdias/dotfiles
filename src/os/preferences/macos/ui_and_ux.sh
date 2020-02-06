#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   UI & UX\n\n"

execute "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true && \
         defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true" \
   "Avoid creating '.DS_Store' files on network or USB volumes"

execute "sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool false" \
    "Show language menu in the top right corner of the boot screen"

execute "defaults write com.apple.CrashReporter UseUNC 1" \
    "Make crash reports appear as notifications"

execute "defaults write com.apple.LaunchServices LSQuarantine -bool false" \
    "Disable 'Are you sure you want to open this application?' dialog"

execute "defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true" \
    "Automatically quit the printer app once the print jobs are completed"

execute "defaults write -g AppleFontSmoothing -int 2" \
    "Enable subpixel font rendering on non-Apple LCDs"

execute "defaults write -g AppleShowScrollBars -string 'Always'" \
    "Always show scrollbars"

execute "defaults write -g NSAutomaticWindowAnimationsEnabled -bool true" \
    "Enable window opening and closing animations."

execute "defaults write -g NSDisableAutomaticTermination -bool false" \
    "Enable automatic termination of inactive apps"

execute "defaults write -g NSNavPanelExpandedStateForSaveMode -bool true && \
         defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true" \
    "Expand save panel by default"

execute "defaults write -g NSTableViewDefaultSizeMode -int 2" \
    "Set sidebar icon size to medium"

execute "defaults write -g NSUseAnimatedFocusRing -bool false" \
    "Disable the over-the-top focus ring animation"

execute "defaults write -g NSWindowResizeTime -float 0.001" \
    "Accelerated playback when adjusting the window size."

execute "defaults write -g PMPrintingExpandedStateForPrint -bool true && \
         defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true" \
    "Expand print panel by default"

execute "defaults write -g QLPanelAnimationDuration -float 1" \
    "Enable opening a Quick Look window animations."

execute "defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool true" \
    "Enable resume system-wide"

execute "sudo systemsetup -setrestartfreeze on" \
    "Restart automatically if the computer freezes"

execute "sudo defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 1 && \
         sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist && \
         sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist" \
    "Turn Bluetooth on"

execute "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user" \
    "Remove duplicates in the “Open With” menu (also see lscleanup alias)"

execute "sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName" \
    "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"

execute "defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false" \
    "Disable automatic capitalization as it’s annoying when typing code"

execute "defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false" \
    "Disable smart dashes as they’re annoying when typing code"

execute "defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false" \
    "Disable automatic period substitution as it’s annoying when typing code"

execute "sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false" \
    "Disable guest login"

killall "SystemUIServer" &> /dev/null
