#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Xcode\n\n"

execute "defaults write com.apple.dt.Xcode ShowBuildOperationDuration -string 'YES'" \
    "Display build time"