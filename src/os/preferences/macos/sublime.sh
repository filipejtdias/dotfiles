#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Sublime\n\n"

declare SUBLIME_PACKAGE_CONTROL_URL="https://packagecontrol.io/Package%20Control.sublime-package"
declare package_control_dir="$HOME/Library/Application Support/Sublime Text 3/Installed Packages/"
declare package_control_settings_dir="$HOME/Library/Application Support/Sublime Text 3/Packages/User/Package Control.sublime-settings"

set_symlink() {
	
	execute "ln -s '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' /usr/local/bin/sublime" \
    	"Set symlink"
    return $?
}

open_sublime() {
    open -a 'Sublime Text'
}

download() {
    local url="$1"
    curl -O "$url" &> /dev/null
    return $?
}

download_sublime_package_control() {

    mkdir "$package_control_dir"
    pushd "$package_control_dir" > /dev/null
    download "$SUBLIME_PACKAGE_CONTROL_URL"
    print_result $? "Download Package Control" "true"

    for x in *
        do mv -- "$x" "${x//%20/ }"
    done
    print_result $? "Renamed file" "true"

    popd > /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   return 1
}

install_packages() {

    local sourceFile="$(cd .. && pwd)/PackageControl.sublime-settings"
    execute "ln -sf '$sourceFile' '$package_control_settings_dir'" \
        "Install Packages"
    return $?
}

remove_license_prompt() {

    if grep -q sublimetext /etc/hosts; then
        print_success "Remove License Prompt"
        return 1
    else
        execute "echo '127.0.0.1 sublimetext.com' | sudo tee -a /etc/hosts && \
                 echo '127.0.0.1 www.sublimetext.com' | sudo tee -a /etc/hosts && \
                 echo '127.0.0.1 sublimehq.com' | sudo tee -a /etc/hosts && \
                 echo '127.0.0.1 telemetry.sublimehq.com' | sudo tee -a /etc/hosts && \
                 echo '127.0.0.1 license.sublimehq.com' | sudo tee -a /etc/hosts" \
            "Remove License Prompt"
        return $?
    fi
}

main() {
	set_symlink
    open_sublime
	download_sublime_package_control
	install_packages
	ask_for_sudo
	remove_license_prompt	
}

main
