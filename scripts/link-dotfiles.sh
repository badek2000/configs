#!/usr/bin/env bash
# Stow fish, ranger, tmux into $HOME. Backs up conflicting real files first.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

PACKAGES=(fish ranger tmux vim kitty)
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

if ! has_cmd stow; then
  apt_update_once
  sudo apt-get install -y stow
fi

backup_conflicts() {
  local pkg="$1"
  # Walk every file inside the package and back up any real file at the target.
  (cd "$REPO_ROOT/$pkg" && find . -type f -o -type l) | while read -r rel; do
    rel="${rel#./}"
    local target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$target" "$BACKUP_DIR/$rel"
      warn "backed up $target -> $BACKUP_DIR/$rel"
    fi
  done
}

for pkg in "${PACKAGES[@]}"; do
  log "stow $pkg"
  backup_conflicts "$pkg"
  stow -d "$REPO_ROOT" -t "$HOME" -R "$pkg"
done

[[ -d "$BACKUP_DIR" ]] && log "backups at $BACKUP_DIR" || true
