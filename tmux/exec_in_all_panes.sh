#!/bin/bash

# Prompt user for command to send to panes
tmux command-prompt -p "Enter command to send to all panes: " "run-shell \"tmux list-panes -F '##{pane_id}' | xargs -I {} tmux send-keys -t {} '%1' Enter\""
