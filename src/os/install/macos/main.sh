#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

execute "sudo spctl --master-disable" \
	"Disable Open Apps from Unidentified Developers"
	
./xcode.sh
./homebrew.sh
./rvm.sh

execute 'while read url; do open -a Safari "$url"; done < urls.txt' \
    "Open URLs in Safari to install software that can't be automated"
