#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Energy\n\n"

execute "sudo pmset -a lidwake 1" \
    "Enable lid wakeup"

execute "sudo pmset -a displaysleep 15" \
    "Sleep the display after 15 minutes"

execute "sudo pmset -c sleep 0" \
    "Disable machine sleep while charging"

execute "sudo pmset -b sleep 5" \
    "Set machine sleep to 5 minutes on battery"

execute "sudo pmset -a standbydelay 86400" \
    "Set standby delay to 24 hours"

execute "sudo pmset -a hibernatemode 3" \
    "Hibernation mode"

execute "defaults write com.apple.screensaver askForPassword -int 1 && \
         defaults write com.apple.screensaver askForPasswordDelay -int 0" \
    "Require password immediately after into sleep or screen saver mode"
