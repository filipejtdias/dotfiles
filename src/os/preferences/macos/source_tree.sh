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

execute "defaults write com.torusknot.SourceTreeNotMAS DidShowGettingStarted -bool true" \
	"Disable Getting Started Screen"

execute "defaults write com.torusknot.SourceTreeNotMAS defaultFolder -string '~/code/'" \
	"Set default folder"

execute "defaults write com.torusknot.SourceTreeNotMAS pushWhenCommiting -bool true" \
	"Push when commiting"

execute "defaults write com.torusknot.SourceTreeNotMAS gitRebaseTrackingBranches -bool true" \
	"Use Rebase instead of merge by default for tracked branches"

execute "defaults write com.torusknot.SourceTreeNotMAS gitPerformSubmoduleActionsRecursively -bool true" \
	"Git perform submodules actions recursively"
