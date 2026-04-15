#!/usr/bin/env bash
# Apply GNOME font settings from manifests/fonts.conf.
# --capture dumps the current GNOME fonts back into the manifest.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

CONF="$REPO_ROOT/manifests/fonts.conf"

if [[ "${1:-}" == "--capture" ]]; then
  has_cmd gsettings || die "gsettings not found"
  cat > "$CONF" <<EOF
# key=value pairs consumed by scripts/set-fonts.sh
# Edit, re-run --fonts to apply.
interface=$(gsettings get org.gnome.desktop.interface font-name | tr -d "'")
document=$(gsettings get org.gnome.desktop.interface document-font-name | tr -d "'")
monospace=$(gsettings get org.gnome.desktop.interface monospace-font-name | tr -d "'")
titlebar=$(gsettings get org.gnome.desktop.wm.preferences titlebar-font | tr -d "'")
EOF
  log "captured current fonts -> $CONF"
  exit 0
fi

[[ -f "$CONF" ]] || die "missing $CONF"

if ! has_cmd gsettings || ! gsettings list-schemas 2>/dev/null | grep -q org.gnome.desktop.interface; then
  warn "GNOME not detected, skipping font setup"
  exit 0
fi

# shellcheck disable=SC1090
declare -A fonts
while IFS='=' read -r k v; do
  [[ -z "$k" || "$k" == \#* ]] && continue
  fonts[$k]="$v"
done < "$CONF"

[[ -n "${fonts[interface]:-}" ]] && gsettings set org.gnome.desktop.interface font-name "${fonts[interface]}"
[[ -n "${fonts[document]:-}"  ]] && gsettings set org.gnome.desktop.interface document-font-name "${fonts[document]}"
[[ -n "${fonts[monospace]:-}" ]] && gsettings set org.gnome.desktop.interface monospace-font-name "${fonts[monospace]}"
[[ -n "${fonts[titlebar]:-}"  ]] && gsettings set org.gnome.desktop.wm.preferences titlebar-font "${fonts[titlebar]}"

log "fonts applied from $CONF"
