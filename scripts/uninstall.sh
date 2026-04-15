#!/usr/bin/env bash
# Un-stow all dotfile packages. Does not touch dev toolchains or apps.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

PACKAGES=(fish ranger tmux vim kitty)

for pkg in "${PACKAGES[@]}"; do
  log "unstow $pkg"
  stow -d "$REPO_ROOT" -t "$HOME" -D "$pkg" || warn "unstow $pkg failed"
done

log "Installed apps (firefox, vscode, moonlight) and toolchains (rust, pyenv) are NOT removed."
log "Restore ~/.config-backup-* directories manually if needed."
