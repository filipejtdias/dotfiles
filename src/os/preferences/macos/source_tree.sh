#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Source Tree\n\n"

execute "defaults write com.torusknot.SourceTreeNotMAS allowForcePush -int 1" \
	"Allow Force Push"

execute "defaults write com.torusknot.SourceTreeNotMAS gitFetchPrune -int 1" \
	"Prunce tracking branches no longer present on remotes"

execute "defaults write com.torusknot.SourceTreeNotMAS useFixedWithCommitFont -int 1" \
	"Use fixed-width font for commit messages"
