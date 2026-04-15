#!/usr/bin/env bash
# Install Firefox (apt), VSCode (snap), Moonlight (flatpak).
# VSCode settings/extensions are handled by scripts/vscode-setup.sh.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

apt_update_once
apt_install_from_file "$REPO_ROOT/manifests/apt-desktop.txt"

# --- VSCode via snap (classic confinement) ---
if ! has_cmd code; then
  log "installing VSCode (snap)"
  sudo snap install code --classic
else
  log "VSCode already installed"
fi

# --- Flatpak / Flathub ---
if ! flatpak remotes | grep -q flathub; then
  log "adding flathub remote"
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# --- Flatpak apps from manifest ---
FLATPAK_MANIFEST="$REPO_ROOT/manifests/flatpak.txt"
if [[ -f "$FLATPAK_MANIFEST" ]]; then
  while read -r app; do
    [[ -z "$app" || "$app" == \#* ]] && continue
    if flatpak list --app --columns=application | grep -qx "$app"; then
      log "flatpak: $app already installed"
    else
      log "flatpak install $app"
      flatpak install -y flathub "$app"
    fi
  done < "$FLATPAK_MANIFEST"
fi
