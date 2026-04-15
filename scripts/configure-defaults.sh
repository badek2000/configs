#!/usr/bin/env bash
# Post-install personal defaults:
#   - set login shell to fish
#   - set vim as git's default editor
#   - prompt for git user.name / user.email if not already set
#
# Idempotent: re-running skips anything already configured.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

# --- 1. default shell: fish ---
if has_cmd fish; then
  fish_path="$(command -v fish)"
  # Ensure /etc/shells lists fish (chsh refuses otherwise).
  if ! grep -qxF "$fish_path" /etc/shells; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi
  current_shell="$(getent passwd "$USER" | cut -d: -f7)"
  if [[ "$current_shell" != "$fish_path" ]]; then
    log "chsh -s $fish_path"
    sudo chsh -s "$fish_path" "$USER"
  else
    log "login shell already $fish_path"
  fi
else
  warn "fish not installed, skipping chsh"
fi

# --- 2. git defaults ---
if has_cmd git; then
  git config --global core.editor vim
  git config --global init.defaultBranch main
  git config --global pull.rebase false

  if [[ -z "$(git config --global user.name || true)" ]]; then
    read -r -p "git user.name  > " _name
    [[ -n "$_name" ]] && git config --global user.name "$_name"
  else
    log "git user.name already set: $(git config --global user.name)"
  fi
  if [[ -z "$(git config --global user.email || true)" ]]; then
    read -r -p "git user.email > " _email
    [[ -n "$_email" ]] && git config --global user.email "$_email"
  else
    log "git user.email already set: $(git config --global user.email)"
  fi
fi
