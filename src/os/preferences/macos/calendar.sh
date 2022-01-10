#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Calendar\n\n"

execute "defaults write com.apple.iCal 'first day of week' -integer 1" \
    "Set 1st day of week to Monday"

execute "defaults write com.apple.iCal 'TimeZone support enabled' -bool true" \
    "Enable timezone support"
