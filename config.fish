function fish_greeting
    set_color brgreen
    fortune
    set_color normal
end

set -x MANPATH /usr/share/fish/man /usr/local/man /usr/local/share/man /usr/share/man

set -x PIPENV_SHELL_FANCY 1

set -x GPG_TTY (tty)

set -g theme_nerd_fonts yes

# pyenv config
if test -d $HOME/.pyenv
    set -x PYENV_ROOT $HOME/.pyenv
    set -x PATH $PYENV_ROOT/bin $PATH
end

if test -e $HOME/.variables
    source $HOME/.variables
end

if test -e $HOME/.abbrevations
    source $HOME/.abbrevations
end

# poetry config
if test -d $HOME/.poetry
    set -x PATH $HOME/.poetry/bin $PATH
end


function cd
    builtin cd $argv
    ls
end

function mv
    command mv -v -i $argv
end

function cp
    command cp -v -i $argv
end

function rm
    command rm -v $argv
end

function top
    htop
end

# Emacs ansi-term support
if test -n "$EMACS"
    set -x TERM eterm-color
end

# This function may be required
function fish_title
    true
end

function cowfortune
    fortune | cowsay | lolcat
end

# pyenv configuration
if command -s pyenv > /dev/null 2>&1
    pyenv init - | source
end

# make fuck callable
if command -s thefuck > /dev/null 2>&1
    thefuck --alias | source
end

# Abbreviations
abbr p "sudo pacman"
abbr SS "sudo systemctl"
abbr pi "ping google.com"
abbr y "yay -S"
