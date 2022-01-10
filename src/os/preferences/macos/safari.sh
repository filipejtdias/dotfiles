#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Safari\n\n"

execute "defaults write com.apple.Safari AutoOpenSafeDownloads -bool false" \
    "Disable opening 'safe' files automatically"

execute "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true" \
    "Set backspace key to go to the previous page in history"

execute "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
         defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
         defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true" \
    "Enable the 'Develop' menu and the 'Web Inspector'"

execute "defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false" \
    "Set search type to 'Contains' instead of 'Starts With'"

execute "defaults write com.apple.Safari HomePage -string 'about:blank'" \
    "Set home page to 'about:blank'"

execute "defaults write com.apple.Safari IncludeInternalDebugMenu -bool true" \
    "Enable 'Debug' menu"

execute "defaults write com.apple.Safari ShowFavoritesBar -bool true" \
    "Show bookmarks bar by default"

execute "defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true" \
    "Show the full URL in the address bar"

execute "defaults write -g WebKitDeveloperExtras -bool true" \
    "Add a context menu item for showing the 'Web Inspector' in web views"

execute "defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25" \
    "Disable the standard delay in rendering a web page."

execute "defaults write com.apple.Safari ShowSidebarInTopSites -bool false" \
    "Hide Safari’s sidebar in Top Sites"

execute "defaults write NSGlobalDomain WebKitDeveloperExtras -bool true" \
    "Add a context menu item for showing the Web Inspector in web views"

execute "defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true" \
    "Enable continuous spellchecking"

execute "defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true" \
    "Warn about fraudulent websites"

execute "defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true" \
    "Enable “Do Not Track”"

execute "defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true" \
    "Update extensions automatically"

execute "defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false && \
         defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false" \
    "Block pop-up windows"

execute "defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false && \
         defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false && \
         defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false && \
         defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false" \
    "Disable auto-playing video"

killall "Safari" &> /dev/null
