if not set -q TMUX
    set -gx TERM xterm-256color
end

set -gx EDITOR vim
set -gx VISUAL vim

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    set_color brblack
    echo (hostname) "—" (date "+%A, %Y-%m-%d %H:%M:%S")
    
    echo "User: "(whoami)"  Shell: $SHELL"
    
    echo "Uptime: "(uptime -p)""
    
    set_color normal
end

function open_ranger
    ranger
    commandline -f repaint
end

function clipfile
    if test (count $argv) -eq 0
        echo "Usage: clipfile <file>"
        return 1
    end

    if test -f $argv[1]
        xclip -selection clipboard < $argv[1]
        echo "Copied '$argv[1]' to clipboard."
    else
        echo "File '$argv[1]' not found."
        return 1
    end
end

function clip
    xclip -sel clip
end

#aliases
alias apt="sudo nala"
alias reloadfish="source ~/.config/fish/config.fish"

#keybindings
bind \cr open_ranger

# Created by `pipx` on 2025-07-17 07:37:15
set PATH $PATH /home/badek2000/.local/bin

# pyenv
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
if type -q pyenv
    pyenv init - fish | source
end
