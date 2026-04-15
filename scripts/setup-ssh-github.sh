#!/usr/bin/env bash
# Generate an ed25519 key for GitHub and register it with ssh-agent.
# Standalone: does not depend on the rest of the repo.

set -euo pipefail

KEY="$HOME/.ssh/id_ed25519_github"

[[ $EUID -ne 0 ]] || { echo "Run as your user, not root."; exit 1; }

# --- git identity (prompt if unset) ---
if command -v git >/dev/null 2>&1; then
  if [[ -z "$(git config --global user.name || true)" ]]; then
    read -r -p "git user.name  > " _name
    [[ -n "$_name" ]] && git config --global user.name "$_name"
  fi
  if [[ -z "$(git config --global user.email || true)" ]]; then
    read -r -p "git user.email > " _email
    [[ -n "$_email" ]] && git config --global user.email "$_email"
  fi
fi

EMAIL="${1:-$(git config --global user.email 2>/dev/null || echo "${USER}@$(hostname)")}"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ -f "$KEY" ]]; then
  echo "Key already exists: $KEY"
else
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY" -N ""
fi

# Ensure an SSH config entry for github.com uses this key.
CONFIG="$HOME/.ssh/config"
touch "$CONFIG"
chmod 600 "$CONFIG"
if ! grep -q "Host github.com" "$CONFIG"; then
  cat >> "$CONFIG" <<EOF

Host github.com
  HostName github.com
  User git
  IdentityFile $KEY
  IdentitiesOnly yes
EOF
fi

eval "$(ssh-agent -s)" >/dev/null
ssh-add "$KEY" 2>/dev/null || true

echo
echo "Public key (add it at https://github.com/settings/keys):"
echo "------------------------------------------------------------"
cat "${KEY}.pub"
echo "------------------------------------------------------------"
echo
echo "Test after adding: ssh -T git@github.com"
