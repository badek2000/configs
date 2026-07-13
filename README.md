# configs

Personal dotfiles and machine-setup scripts for Ubuntu / GNOME.

> **⚠ AI-generated repository.** Every script and manifest here was produced by
> Claude (Opus 4.6) on **2026-04-15** from a live snapshot of badek2000's
> machine — captured fonts, wallpaper, kitty/vim/vscode configs, GNOME
> settings, installed packages. It encodes one user's preferences, not a
> general-purpose installer. Read the scripts before running them on any
> other machine.

## Layout

```
configs/
  install.sh              orchestrator
  scripts/                per-module installers
  manifests/              package lists, fonts.conf, gnome-settings.ini
  vscode/                 settings.json, keybindings.json, extensions.txt
  assets/                 wallpaper etc.
  fish/ ranger/ tmux/     stow packages (mirror $HOME layout)
  vim/ kitty/             stow packages
  .editorconfig           repo-wide editor defaults
```

## Usage

```sh
# everything
./install.sh

# pick modules
./install.sh --dotfiles --dev --vscode --wallpaper --fonts --gnome

# github ssh (standalone)
bash scripts/setup-ssh-github.sh
```

## Modules

| Flag | What it does |
|------|--------------|
| `--dotfiles`  | Stow `fish/ ranger/ tmux/ vim/ kitty/` into `~`. Real files moved to `~/.config-backup-<timestamp>/`. |
| `--dev`       | `rustup` (stable + rust-analyzer/clippy/rustfmt), `pyenv` + latest CPython wired into fish, `build-essential clang clangd lldb gdb cmake ninja`, `pipx`, `gh`, **Claude Code CLI** (via `claude.ai/install.sh`). |
| `--desktop`   | Firefox (apt), VSCode (snap), **Moonlight** (Flathub `com.moonlight_stream.Moonlight`), `fonts-jetbrains-mono`. |
| `--vscode`    | Installs extensions from `vscode/extensions.txt`, symlinks `settings.json` and `keybindings.json`. |
| `--wallpaper` | Copies `assets/background.jpg` and calls `gsettings`. `scripts/set-wallpaper.sh --capture` snapshots the current wallpaper. |
| `--fonts`     | Applies `manifests/fonts.conf` via `gsettings`. `scripts/set-fonts.sh --capture` snapshots current fonts. |
| `--gnome`     | `dconf load /` from `manifests/gnome-settings.ini` — dock, top bar, keyboard shortcuts, enabled extensions, night light, etc. `scripts/gnome-settings.sh --capture` re-dumps. |
| `--snapshots` | Installs **snapper** + enables timeline/cleanup timers. No-op on non-btrfs roots. |
| `--defaults`  | `chsh` login shell to fish, `git config --global core.editor vim`, prompts for git user.name/user.email if unset. |

Base packages in `manifests/apt-base.txt` (installed on every run): `stow git curl wget fish tmux ranger vim kitty ripgrep fd-find bat eza fzf xclip nala` plus essentials. (`config.fish` aliases `apt` to `nala` and uses `xclip` for its `clip`/`clipfile` helpers.)

## Vim

- Config at `vim/.vimrc`, colorscheme at `vim/.vim/colors/kitty.vim`.
- The colorscheme matches `~/.config/kitty/kitty.conf` (bg `#1B1B1B`, green `#008067`, orange `#FF9000`, red `#FF5F5F`, etc.).
- `EDITOR=vim` and `VISUAL=vim` exported in `fish/config.fish`; `git config --global core.editor vim` set by `--defaults`.

## Firefox note

On Ubuntu, `apt install firefox` pulls the **snap transition package**, so the actual Firefox is a snap. If you want the deb binary, use Mozilla's PPA or install from Flathub (`org.mozilla.firefox`) — neither is configured here.

## GitHub SSH

Separate from the orchestrator because it prompts to paste a public key into GitHub:

```sh
bash scripts/setup-ssh-github.sh
```

Prompts for `git user.name` / `user.email` if unset, generates `~/.ssh/id_ed25519_github`, adds a `Host github.com` block to `~/.ssh/config`, loads the key into the agent, and prints the public key to paste at <https://github.com/settings/keys>.

## Uninstall

```sh
bash scripts/uninstall.sh
```

Un-stows dotfiles. Does not remove apps, toolchains, snapshots, GNOME settings, or the shell change.
