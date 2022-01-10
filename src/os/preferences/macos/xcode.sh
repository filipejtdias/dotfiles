#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Xcode\n\n"

execute "defaults write com.apple.dt.Xcode ShowBuildOperationDuration -string 'YES'" \
    "Xcode Show Build Times in Toolbar"

execute "defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true" \
    "Xcode Show Line Numbers"

execute "defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool true" \
    "Xcode Show Code Folding Ribbons"
