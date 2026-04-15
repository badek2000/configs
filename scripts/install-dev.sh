#!/usr/bin/env bash
# Install dev toolchains:
#   - Rust via rustup (stable + rust-analyzer/clippy/rustfmt)
#   - Python via pyenv (wiring for fish is committed in fish/config.fish)
#   - C/C++ via apt (build-essential, clang, lldb, gdb, cmake, ninja)
#   - Package managers: pipx (apt), gh
#   - Claude Code CLI (anthropic native installer)

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_not_root

apt_update_once
apt_install_from_file "$REPO_ROOT/manifests/apt-dev.txt"

# --- Rust via rustup ---
if ! has_cmd rustup; then
  log "installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile default
else
  log "rustup present, updating"
  rustup self update || true
  rustup update stable
fi
# Common components for rust-analyzer
rustup component add rust-src rust-analyzer clippy rustfmt 2>/dev/null || true

# --- Python via pyenv ---
PYENV_ROOT="$HOME/.pyenv"
if [[ ! -d "$PYENV_ROOT" ]]; then
  log "cloning pyenv"
  git clone --depth 1 https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
else
  log "pyenv present, updating"
  git -C "$PYENV_ROOT" pull --ff-only || true
fi

# Fish wiring for pyenv is already committed in fish/.config/fish/config.fish.

# Install a default Python if none are installed.
export PATH="$PYENV_ROOT/bin:$PATH"
if ! pyenv versions --bare | grep -q .; then
  PY_VERSION="$(pyenv install --list | awk '/^\s+3\.[0-9]+\.[0-9]+$/ {v=$1} END {print v}')"
  log "installing python $PY_VERSION via pyenv (this takes a few minutes)"
  pyenv install -s "$PY_VERSION"
  pyenv global "$PY_VERSION"
fi

# --- Claude Code CLI ---
# Uses Anthropic's native installer (no Node required). Lands in ~/.local/bin.
if ! has_cmd claude; then
  log "installing Claude Code CLI"
  curl -fsSL https://claude.ai/install.sh | bash
else
  log "claude already installed ($(claude --version 2>/dev/null | head -1))"
fi

log "dev environments ready. Open a new shell for pyenv/cargo/claude PATH updates."
