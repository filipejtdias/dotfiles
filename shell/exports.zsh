# Editor
export EDITOR="subl -w"

# History
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Pager
export MANPAGER="less -X"

# Colored man pages
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

# Colored ls (macOS)
export CLICOLOR=1
export LSCOLORS="gxfxcxdxcxegedabagccbd"

# Python
export PYTHONIOENCODING="UTF-8"
