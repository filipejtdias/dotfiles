#!/bin/bash
#
# Work profile: app-specific preferences via defaults write.
# Runs after apps/defaults.sh.

set -e

# ==============================================================================
# Outlook
# ==============================================================================

echo "Applying Outlook defaults..."

# Quit Outlook first so changes aren't overwritten on exit
osascript -e 'tell application "Microsoft Outlook" to quit' 2>/dev/null || true
sleep 1

# Calendar view: Work Week
defaults write com.microsoft.Outlook "viewIndividualPrefs.Calendar Grid View" -dict \
    OLViewPrefCalendarViewTypeKey "OLViewPrefCalendarViewTypeWorkWeekValue"

# Hide My Day panel in all views (0 = mail, 1 = calendar)
defaults write com.microsoft.Outlook "MyDay_Visibility_0" -bool false
defaults write com.microsoft.Outlook "MyDay_Visibility_1" -bool false

# Remove My Day button from the toolbar
defaults write com.microsoft.Outlook "ToolbarCustomization_MainTrailingToolView_Preference" -array

# Hide What's New popups
defaults write com.microsoft.Outlook "OUIShouldEstablishWhatsNewBaseline" -bool true
defaults write com.microsoft.Outlook "UserPreference_WhatsNew_DuplicateEvent" -int 0
defaults write com.microsoft.Outlook "UserPreference_WhatsNew_ImageThemes" -int 0
defaults write com.microsoft.Outlook "UserPreference_WhatsNew_RecallMessage" -int 0
defaults write com.microsoft.Outlook "UserPreference_WhatsNew_ReplyWithChat" -int 0

# ==============================================================================
# Microsoft Defender
# ==============================================================================

echo "Applying Defender defaults..."

# Hide menu bar icon
defaults write com.microsoft.wdav userInterface -dict-add hideStatusMenuIcon -bool true

# ==============================================================================
# Zoom
# ==============================================================================

echo "Applying Zoom defaults..."

# Default meeting view: 0 = Speaker, 1 = Gallery, 2 = Multi-speaker
defaults write us.zoom.xos ZDefaultViewMode -int 2

# NOTE: Zoom's menu bar icon can only be hidden within the app:
# Settings > General > uncheck "Add Zoom to macOS menu bar"

