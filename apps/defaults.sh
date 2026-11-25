#!/bin/bash
#
# App-specific preferences via defaults write.

set -e

# ==============================================================================
# SourceTree
# ==============================================================================

echo "Applying SourceTree defaults..."

defaults write com.torusknot.SourceTreeNotMAS allowForcePush -int 1
defaults write com.torusknot.SourceTreeNotMAS gitFetchPrune -int 1
defaults write com.torusknot.SourceTreeNotMAS useFixedWithCommitFont -int 1
defaults write com.torusknot.SourceTreeNotMAS gitRebaseTrackingBranches -bool true
defaults write com.torusknot.SourceTreeNotMAS gitPerformSubmoduleActionsRecursively -bool true
defaults write com.torusknot.SourceTreeNotMAS defaultFolder -string '~/code/'
defaults write com.torusknot.SourceTreeNotMAS pushWhenCommiting -bool true
defaults write com.torusknot.SourceTreeNotMAS gitPushAllTags -bool false

# Disable tips and warnings
defaults write com.torusknot.SourceTreeNotMAS showToolbarTip -bool false
defaults write com.torusknot.SourceTreeNotMAS showStagingTip -bool false
defaults write com.torusknot.SourceTreeNotMAS gitSuppWarnOnAmend -bool true
defaults write com.torusknot.SourceTreeNotMAS warnForcePush -bool false

# Disable Getting Started screen
defaults write com.torusknot.SourceTreeNotMAS DidShowGettingStarted -bool true
defaults write com.torusknot.SourceTreeNotMAS STWelcomeConfiguration -bool true
defaults write com.torusknot.SourceTreeNotMAS SUHasLaunchedBefore -bool true
defaults write com.torusknot.SourceTreeNotMAS STWelcomeStageLicense -bool true

# View preferences
defaults write com.torusknot.SourceTreeNotMAS fileStatusStagingViewMode -int 1
defaults write com.torusknot.SourceTreeNotMAS fileStatusFilterMode -int 1
defaults write com.torusknot.SourceTreeNotMAS fileStatusViewMode2 -int 2

# Enable automatic updates
defaults write com.torusknot.SourceTreeNotMAS SUEnableAutomaticChecks -bool true

# ==============================================================================
# Activity Monitor
# ==============================================================================

echo "Applying Activity Monitor defaults..."

# Show the main window when launching
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string 'CPUUsage'
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ==============================================================================
# Safari
# ==============================================================================

echo "Applying Safari defaults..."

# NOTE: On Ventura+, Safari's container is SIP-protected. Most of these
# settings write to ~/Library/Preferences/com.apple.Safari.plist but Safari
# may not read them. They are kept here for older macOS versions and in case
# Apple restores access in a future update. Configure manually in Safari >
# Settings if they don't take effect.

killall "Safari" &> /dev/null || true
sleep 1

SAFARI_PLIST="$HOME/Library/Preferences/com.apple.Safari.plist"

# Disable opening 'safe' files automatically after downloading
defaults write "$SAFARI_PLIST" AutoOpenSafeDownloads -bool false

# Enable the Develop menu and Web Inspector
defaults write "$SAFARI_PLIST" IncludeDevelopMenu -bool true
defaults write "$SAFARI_PLIST" WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write "$SAFARI_PLIST" com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write -g WebKitDeveloperExtras -bool true

# Show the full URL in the address bar
defaults write "$SAFARI_PLIST" ShowFullURLInSmartSearchField -bool true

# Show bookmarks bar
defaults write "$SAFARI_PLIST" ShowFavoritesBar -bool true

# Set home page to about:blank
defaults write "$SAFARI_PLIST" HomePage -string 'about:blank'

# Enable continuous spellchecking
defaults write "$SAFARI_PLIST" WebContinuousSpellCheckingEnabled -bool true

# Send Do Not Track header
defaults write "$SAFARI_PLIST" SendDoNotTrackHTTPHeader -bool true

# Block pop-up windows
defaults write "$SAFARI_PLIST" WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write "$SAFARI_PLIST" com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Update extensions automatically
defaults write "$SAFARI_PLIST" InstallExtensionUpdatesAutomatically -bool true

# Warn about fraudulent websites
defaults write "$SAFARI_PLIST" WarnAboutFraudulentWebsites -bool true

# Disable backswipe navigation
defaults write "$SAFARI_PLIST" AppleEnableSwipeNavigateWithScrolls -bool false
defaults write -g AppleEnableSwipeNavigateWithScrolls -bool false

# Set search type to 'Contains' instead of 'Starts With'
defaults write "$SAFARI_PLIST" FindOnPageMatchesWordStartsOnly -bool false

# Disable the prompt to save passwords in macOS Keychain
defaults write "$SAFARI_PLIST" AutoFillPasswords -bool false

# ==============================================================================
# Calendar
# ==============================================================================

echo "Applying Calendar defaults..."

# Set first day of the week to Monday (1=Sun, 2=Mon; modern macOS also reads
# AppleFirstWeekday from NSGlobalDomain — see macos/defaults.sh)
defaults write com.apple.iCal 'first day of week' -integer 2

# Enable timezone support
defaults write com.apple.iCal 'TimeZone support enabled' -bool true

# ==============================================================================
# Photos
# ==============================================================================

echo "Applying Photos defaults..."

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# ==============================================================================
# TextEdit
# ==============================================================================

echo "Applying TextEdit defaults..."

# Use plain text mode for new documents
defaults write com.apple.TextEdit RichText 0

# Open and save files as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ==============================================================================
# Xcode
# ==============================================================================

echo "Applying Xcode defaults..."

# Show build duration in toolbar
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -string 'YES'

# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true

# Show code folding ribbon
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool true

# ==============================================================================
# Terminal
# ==============================================================================

echo "Applying Terminal defaults..."

# Enable Secure Keyboard Entry
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Only use UTF-8
defaults write com.apple.terminal StringEncodings -array 4

# Hide line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

# Touch ID for sudo (modern macOS uses /etc/pam.d/sudo_local)
if [ -f /etc/pam.d/sudo_local.template ] && [ ! -f /etc/pam.d/sudo_local ]; then
    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
    echo "  [ok] Enabled Touch ID for sudo via sudo_local"
elif [ -f /etc/pam.d/sudo_local ]; then
    if ! grep -q "pam_tid.so" /etc/pam.d/sudo_local; then
        sudo sh -c 'echo "auth       sufficient     pam_tid.so" >> /etc/pam.d/sudo_local'
        echo "  [ok] Added Touch ID to sudo_local"
    fi
fi

# ==============================================================================
# Chrome
# ==============================================================================

echo "Applying Chrome defaults..."

# Disable backswipe navigation
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Expand print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

# Use system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true

killall "Google Chrome" &> /dev/null || true

# ==============================================================================
# App Store / Software Update
# ==============================================================================

echo "Applying App Store defaults..."

# Enable automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Install system data files and security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# ==============================================================================
# iTerm2
# ==============================================================================

echo "Applying iTerm2 defaults..."

# Load preferences from the dotfiles folder so keybindings, split-pane
# navigation, and the hotkey window travel with the repo. iTerm2 reads these
# two keys from the standard plist on launch and then loads the real prefs
# from ~/code/dotfiles/apps/iterm2/com.googlecode.iterm2.plist. On a fresh
# machine the custom folder may be empty — iTerm2 falls back to defaults
# until the plist is populated (Settings > General > Preferences > Save
# changes: Automatically).
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/code/dotfiles/apps/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Save changes back to the custom folder automatically (suppresses the
# on-quit "save to folder?" dialog). _selection=2 = Automatically.
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2

# ==============================================================================
# BetterSnapTool
# ==============================================================================

echo "Applying BetterSnapTool defaults..."

# Launch on startup
defaults write com.hegenberg.BetterSnapTool launchOnStartup -bool true

# ==============================================================================

echo "App defaults applied."
