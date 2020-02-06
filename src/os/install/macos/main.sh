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
