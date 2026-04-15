#!/usr/bin/env bash
# Set GNOME wallpaper to the image bundled in assets/.
# Also handles "capture" mode: --capture saves the current wallpaper into the repo.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

ASSET="$REPO_ROOT/assets/background.jpg"
TARGET="$HOME/.config/background"

if [[ "${1:-}" == "--capture" ]]; then
  # Save current GNOME wallpaper into the repo.
  uri=$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'")
  src="${uri#file://}"
  [[ -f "$src" ]] || die "current wallpaper not found at $src"
  cp "$src" "$ASSET"
  log "captured $src -> $ASSET"
  exit 0
fi

[[ -f "$ASSET" ]] || die "missing $ASSET (run with --capture first, or commit an image)"

# Not all DEs are GNOME; only configure if gsettings schema exists.
if ! has_cmd gsettings || ! gsettings list-schemas 2>/dev/null | grep -q org.gnome.desktop.background; then
  warn "gsettings/GNOME not detected, skipping wallpaper set"
  exit 0
fi

cp "$ASSET" "$TARGET"
uri="file://$TARGET"
gsettings set org.gnome.desktop.background picture-uri "$uri"
gsettings set org.gnome.desktop.background picture-uri-dark "$uri"
gsettings set org.gnome.desktop.background picture-options "zoom"
log "wallpaper set to $TARGET"
