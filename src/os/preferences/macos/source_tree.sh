#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Source Tree\n\n"

execute "defaults write com.torusknot.SourceTreeNotMAS allowForcePush -int 1" \
	"Allow Force Push"
