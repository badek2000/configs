#!/usr/bin/env bash
# Install VSCode extensions and symlink settings.json + keybindings.json.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

has_cmd code || die "VSCode 'code' not found. Run install-desktop.sh first."

# --- Extensions ---
EXT_FILE="$REPO_ROOT/vscode/extensions.txt"
if [[ -f "$EXT_FILE" ]]; then
  # Installed list, one per line, lowercase.
  installed=$(code --list-extensions | tr '[:upper:]' '[:lower:]' | sort -u)
  while read -r ext; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    lc=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    if grep -qx "$lc" <<<"$installed"; then
      log "ext present: $ext"
    else
      log "installing ext: $ext"
      code --install-extension "$ext" --force
    fi
  done < "$EXT_FILE"
fi

# --- Settings + keybindings ---
# Snap VSCode uses ~/.config/Code/User. Detect and fall back sanely.
CODE_USER_DIR="$HOME/.config/Code/User"
mkdir -p "$CODE_USER_DIR"

for name in settings.json keybindings.json; do
  src="$REPO_ROOT/vscode/$name"
  dst="$CODE_USER_DIR/$name"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "$dst.backup.$(date +%s)"
    warn "backed up existing $dst"
  fi
  ln -sfn "$src" "$dst"
  log "linked $name -> $src"
done
