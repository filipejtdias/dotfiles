#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_rvm() {

    if ! cmd_exists "rvm"; then
        printf "\n" | "$(curl -sSL https://get.rvm.io | bash -s stable --ruby --with-gems='bundler' --autolibs=read-fail)" &> /dev/null
        #  └─ simulate the ENTER keypress
    fi

    print_result 0 "Installed"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_ruby() {

    if cmd_exists "rvm"; then
        
        rvm install ruby &> /dev/null
        print_result $? "Ruby installed"
    else
        print_success "Ruby installed"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

use_ruby() {

    if cmd_exists "rvm"; then
        
        rvm --default use ruby &> /dev/null
        print_result $? "Use Ruby"
    else
        print_success "Use Ruby"
    fi

}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   RVM\n\n"
    
    ask_for_sudo
    install_rvm
    install_ruby
    use_ruby
}

main
