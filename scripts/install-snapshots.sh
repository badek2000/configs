#!/usr/bin/env bash
# Install snapper (btrfs snapshot manager) if root filesystem is btrfs.
# On other filesystems this is a no-op.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

root_fs="$(findmnt -no FSTYPE /)"
if [[ "$root_fs" != "btrfs" ]]; then
  log "root fs is $root_fs, not btrfs — skipping snapshot manager"
  exit 0
fi

log "btrfs root detected — installing snapper"
apt_update_once
SNAPPER_PKGS=(snapper btrfs-progs)
if apt-cache show snapper-gui >/dev/null 2>&1; then
  SNAPPER_PKGS+=(snapper-gui)
fi
sudo apt-get install -y "${SNAPPER_PKGS[@]}"

# Create a root config if missing. snapper refuses if one exists.
if ! sudo snapper list-configs 2>/dev/null | awk 'NR>2 {print $1}' | grep -qx root; then
  log "snapper create-config /"
  sudo snapper -c root create-config /
else
  log "snapper root config already present"
fi

# Make the timeline + cleanup timers start on boot.
sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer 2>/dev/null || \
  warn "could not enable snapper timers (may not exist on this snapper build)"

log "snapshots: sudo snapper list  |  sudo snapper create --description 'pre-change'"
