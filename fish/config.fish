set -x TERM xterm-256color

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
 	fortune
end

function open_ranger
    ranger
    commandline -f repaint
end

bind \cr open_ranger
