#!/usr/bin/env bash
# Apply or capture a full GNOME dconf tree.
#
#   (no args)     load manifests/gnome-settings.ini into the current session
#   --capture     dump current dconf / into manifests/gnome-settings.ini
#
# The dump includes: dock, panel, keyboard shortcuts, enabled extensions,
# night light, power settings, file manager prefs, terminal profiles, and more.
# Applying overwrites every captured key — review the diff before running on a
# machine whose GNOME state you care about.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

CONF="$REPO_ROOT/manifests/gnome-settings.ini"

if ! has_cmd dconf; then
  warn "dconf not found, skipping (non-GNOME system?)"
  exit 0
fi

if [[ "${1:-}" == "--capture" ]]; then
  dconf dump / > "$CONF"
  log "captured $(wc -l < "$CONF") lines -> $CONF"
  exit 0
fi

[[ -f "$CONF" ]] || die "missing $CONF (run with --capture first)"

key_count=$(grep -cE '^[a-zA-Z0-9._/-]+=' "$CONF" || true)
warn "About to overwrite $key_count GNOME keys from $CONF."
warn "This replaces dock, shortcuts, extensions, favourites, and more."

if [[ "${1:-}" != "--force" && -z "${GNOME_APPLY_YES:-}" ]]; then
  read -r -p "Proceed? [y/N] " _ans
  case "$_ans" in
    y|Y|yes|YES) ;;
    *) log "skipped."; exit 0 ;;
  esac
fi

log "applying $CONF via dconf load"
dconf load / < "$CONF"
log "GNOME settings applied. Some changes (e.g. dock, extensions) require logout."
