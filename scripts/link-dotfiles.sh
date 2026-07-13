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
  # Walk every file inside the package and move aside anything at the target
  # that stow would refuse to overwrite: real files, and *foreign* symlinks
  # (symlinks that don't already point back into this repo). Leaving a foreign
  # symlink in place makes `stow` abort the entire package, so the rest of the
  # package (e.g. kitty.conf) silently never gets linked.
  (cd "$REPO_ROOT/$pkg" && find . -type f -o -type l) | while read -r rel; do
    rel="${rel#./}"
    local target="$HOME/$rel"
    [[ -e "$target" || -L "$target" ]] || continue
    # Skip anything that already resolves back into this repo — either our own
    # stow symlink, or a file reached through an already-folded parent-directory
    # symlink (e.g. ~/.vim -> repo/vim/.vim). Moving those would cannibalise the
    # repo's own sources.
    local dest; dest="$(readlink -f "$target" 2>/dev/null || true)"
    [[ -n "$dest" && "$dest" == "$REPO_ROOT/"* ]] && continue
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv "$target" "$BACKUP_DIR/$rel"
    warn "backed up $target -> $BACKUP_DIR/$rel"
  done
}

for pkg in "${PACKAGES[@]}"; do
  log "stow $pkg"
  backup_conflicts "$pkg"
  stow -d "$REPO_ROOT" -t "$HOME" -R "$pkg"
done

[[ -d "$BACKUP_DIR" ]] && log "backups at $BACKUP_DIR" || true
