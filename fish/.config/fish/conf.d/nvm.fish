set -gx NVM_DIR "$HOME/.nvm"
if test -d "$NVM_DIR/versions/node"
    set -l node_dir (find "$NVM_DIR/versions/node" -maxdepth 1 -type d -name 'v*' | sort -V | tail -1)
    if test -n "$node_dir"
        fish_add_path -gP "$node_dir/bin"
    end
end
