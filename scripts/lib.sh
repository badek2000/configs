#!/usr/bin/env bash
# Common helpers sourced by every script.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; }
die()  { err "$*"; exit 1; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

require_not_root() {
  [[ $EUID -ne 0 ]] || die "Run as your user, not root. sudo is invoked per-command."
}

apt_install_from_file() {
  local file="$1"
  [[ -f "$file" ]] || die "Manifest not found: $file"
  local pkgs=()
  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    pkgs+=("$line")
  done < "$file"
  (( ${#pkgs[@]} )) || return 0
  log "apt install: ${pkgs[*]}"
  sudo apt-get install -y "${pkgs[@]}"
}

apt_update_once() {
  if [[ -z "${_APT_UPDATED:-}" ]]; then
    log "apt update"
    sudo apt-get update
    export _APT_UPDATED=1
  fi
}
