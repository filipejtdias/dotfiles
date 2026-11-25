# Dotfiles

macOS dotfiles: zsh, git, SSH, Homebrew packages, system and app preferences, and a Dock layout, installed by a single idempotent script. A small profile system layers per-machine-role extras (for example `work`) on top of a common base.

## Requirements

- macOS only. The installer exits with an error on any other OS.
- Intel and Apple Silicon are both handled (Homebrew prefix `/usr/local` or `/opt/homebrew`, picked from `uname -m`).
- `git` and `curl` (shipped with macOS / Xcode Command Line Tools).
- Administrator rights: `sudo` is requested up front when Homebrew packages, macOS defaults or app defaults are selected.
- Homebrew is installed automatically if missing (non-interactive, using the official installer).
- The repo must live at `~/code/dotfiles`. Run from anywhere else, the installer clones a fresh copy there (or runs `git pull --rebase` if one exists) and re-executes from it.

## Quick start

One-liner:

```bash
bash -c "$(curl -fsSL https://raw.github.com/filipejtdias/dotfiles/main/install.sh)"
```

Or clone and run:

```bash
git clone https://github.com/filipejtdias/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

Options:

| Option | Effect |
| --- | --- |
| `-y`, `--yes` | Skip all prompts and answer yes to everything except opening download pages (see below) |
| `--profile <name>` | Use `profiles/<name>/` (default `personal`); saved for later runs |
| `--profile=<name>` | Same as above |
| `--reconfigure` | Ask for the git name and email again, offering the saved values as defaults |

Environment variables `GIT_NAME` and `GIT_EMAIL` provide the git identity non-interactively:

```bash
GIT_NAME="Jane Doe" GIT_EMAIL="jane@example.com" ./install.sh -y
./install.sh --profile work -y
./install.sh --reconfigure
```

Arguments for the one-liner go after `--`:

```bash
bash -c "$(curl -fsSL https://raw.github.com/filipejtdias/dotfiles/main/install.sh)" -- --profile work
```

The script is safe to re-run.

## What the installer does

In order:

1. Checks the OS is macOS, bootstraps the clone at `~/code/dotfiles` if needed, parses flags.
2. Resolves the profile (see Profiles) and detects the architecture.
3. Asks everything upfront (skipped with `-y`):
   - install Homebrew packages from the Brewfiles
   - apply macOS defaults (Dock, Finder, Trackpad, Energy, etc.)
   - apply app defaults
   - open download pages for manual installs (`urls.txt`); never done with `-y`
   - git name and email (kept silently if already in `~/.gitconfig.local`, unless `--reconfigure`)
4. Requests `sudo` once and keeps it alive for the run.
5. Homebrew: loads it into the session, or installs it. With the Brewfile step selected, it taps and trusts the third-party taps in `TRUSTED_TAPS` (if this Homebrew has `brew trust`), then runs `brew bundle` for `Brewfile` and `profiles/<name>/Brewfile`.
6. Opens the URLs in `urls.txt` and `profiles/<name>/urls.txt`, if you said yes.
7. Creates the directories in `directories.txt` and `profiles/<name>/directories.txt` (always, including with `-y`; only paths under `$HOME`, existing ones are left alone).
8. Symlinks the dotfiles (see the table below). Existing files are moved to `~/.dotfiles_backup/<timestamp>/` first.
9. Saves the profile to `~/.dotfiles-profile`, links the profile's `gitconfig` and `ssh_config`, creates an empty `shell/aliases.local.zsh` if missing.
10. Writes the git identity to `~/.gitconfig.local`; warns if it is still unset.
11. Runs `macos/defaults.sh`, `macos/dock.sh`, `macos/energy.sh` (if selected).
12. Runs `apps/defaults.sh`, then `profiles/<name>/defaults.sh` if present (if selected).

Symlinks created:

| Source | Target |
| --- | --- |
| `shell/.zshrc` | `~/.zshrc` |
| `shell/.zprofile` | `~/.zprofile` |
| `shell/.curlrc` | `~/.curlrc` |
| `shell/.inputrc` | `~/.inputrc` |
| `git/.gitconfig` | `~/.gitconfig` |
| `git/.gitignore_global` | `~/.gitignore_global` |
| `git/.gitattributes` | `~/.gitattributes` |
| `ssh/config` | `~/.ssh/config` (`~/.ssh` is created with mode 700) |
| `profiles/<name>/gitconfig` | `~/.gitconfig.profile` |
| `profiles/<name>/ssh_config` | `~/.ssh/config.profile` |

A profile link left over from a previously selected profile is removed if the new profile does not provide that file.

When finished, open a new terminal to load the shell config.

## Profiles

The base config is common to every machine. A profile layers machine-role specifics on top. Precedence: base, then profile, then `*.local` files.

```
profiles/<name>/
  Brewfile        brew bundle, run after the base Brewfile
  defaults.sh     run after apps/defaults.sh
  dock.sh         sourced by macos/dock.sh; set EXTRA_DOCK_APPS=(...) to append Dock items
  zsh/*.zsh       sourced by .zshrc after shell/*.zsh, before shell/*.local.zsh
  gitconfig       linked to ~/.gitconfig.profile (git settings, not identity)
  ssh_config      linked to ~/.ssh/config.profile
  urls.txt        extra download pages, opened like the base urls.txt
  directories.txt extra directories to create, same format as the base directories.txt
```

All files are optional. Shipped profiles are `personal` (the default, essentially empty) and `work` (extra tooling, Outlook/Defender/Zoom defaults, extra Dock entries, Tuist/make aliases).

Selection: `--profile <name>` accepts any directory under `profiles/` (letters, digits, `.`, `_`, `-`; no leading dot). The choice is written to `~/.dotfiles-profile`, which is machine-local and untracked. Later runs without the flag reuse it. With nothing saved and no flag, an interactive run asks `Profile [personal]:` and `-y` uses `personal`.

To add a profile, create `profiles/<name>/` with any of the files above and run:

```bash
./install.sh --profile <name>
```

## Repository layout

```
install.sh              Installer
Brewfile                Base Homebrew taps, formulae, casks, Mac App Store apps
urls.txt                Download pages for apps not on Homebrew or the App Store
directories.txt         Directories to create under $HOME (one per line, ~ allowed)
shell/                  zsh config: .zshrc, .zprofile, aliases/exports/functions/prompt (*.zsh),
                        .curlrc, .inputrc
git/                    .gitconfig, .gitignore_global, .gitattributes
ssh/config              SSH client config (includes config.profile and config.local)
macos/                  defaults.sh (system prefs), dock.sh (Dock layout), energy.sh (pmset, lock)
apps/                   defaults.sh (per-app prefs); iterm2/ holds the iTerm2 prefs plist
profiles/               personal/ and work/ layers (see Profiles)
```

How the shell loads: `.zprofile` sets up Homebrew; `.zshrc` sets zsh options, sources `shell/*.zsh` (skipping `*.local.zsh`), then `profiles/<name>/zsh/*.zsh`, then `shell/*.local.zsh`, and activates `mise` if `~/.local/bin/mise` exists.

## Local overrides and secrets

Nothing machine-specific or secret belongs in tracked files. These are never committed (`.gitignore` covers `*.local`, `*.local.zsh`, `.DS_Store`):

| File | Purpose |
| --- | --- |
| `~/.gitconfig.local` | Git name and email, written by the installer; loaded last, wins over the profile |
| `~/.ssh/config.local` | Private SSH hosts and keys; included by `ssh/config` (missing file is ignored) |
| `shell/*.local.zsh` | Local aliases, exports, tokens; `shell/aliases.local.zsh` is created empty by the installer |
| `~/.dotfiles-profile` | Selected profile name |

## Customising

- Package: add a `brew`, `cask` or `mas "Name", id: N` line to `Brewfile` (or `profiles/<name>/Brewfile`).
- Third-party tap: add `tap "owner/repo"` to the Brewfile and the same name to `TRUSTED_TAPS` in `install.sh`.
- Dock app: add an absolute path (or `"SPACER"`) to `DOCK_APPS` in `macos/dock.sh`; missing apps are skipped with a warning. Per profile, set `EXTRA_DOCK_APPS` in `profiles/<name>/dock.sh`.
- macOS or app preference: add a `defaults write` block to `macos/defaults.sh` or `apps/defaults.sh` (or `profiles/<name>/defaults.sh`), following the existing sections.
- Download page: add a URL to `urls.txt` (or `profiles/<name>/urls.txt`), one per line; `#` comments and blank lines are ignored.
- Directory: add a path under `$HOME` to `directories.txt` (or `profiles/<name>/directories.txt`), one per line; `~` expands to `$HOME`, `#` comments and blank lines are ignored.
- New dotfile: put it in the right directory, add a `create_symlink` line in `install.sh`, re-run.
- Aliases, exports, functions: edit the matching file under `shell/`, or add a new `shell/<name>.zsh`.

## Manual steps and known limits

- Several `defaults` changes need a logout or restart to fully apply; the script restarts Dock, Finder, SystemUIServer and cfprefsd itself.
- Some settings are written but may not be honoured on recent macOS (the scripts note this): Safari preferences (sandboxed container), Mission Control and screensaver idle-time keys. Set these in System Settings or Safari Settings if they do not take effect.
- Zoom's menu bar icon can only be hidden in the app (work profile).
- Granting Touch ID for `sudo` edits `/etc/pam.d/sudo_local`.
- The timezone is set to `Europe/London` with `systemsetup`, which may need Full Disk Access for the terminal; failure is ignored. The macOS defaults also hard-code metric units, a 24-hour clock, a Monday week start and a Cmd+section-sign shortcut. Edit `macos/defaults.sh` to taste.
- Energy settings (`pmset`) and the screen lock delay are applied by `macos/energy.sh`.
- iTerm2 loads preferences from `~/code/dotfiles/apps/iterm2` and saves changes back there automatically.
- Apps listed in `urls.txt` (and anything not on Homebrew or the App Store) must be installed by hand.
- Review the Dock list in `macos/dock.sh` first: running it clears all existing Dock items.

## Uninstall and restore

Every replaced file is moved, not deleted, to `~/.dotfiles_backup/<YYYYmmdd_HHMMSS>/` and the path is printed at the end of the run. To restore, remove the symlink and move the backup back:

```bash
rm ~/.zshrc
mv ~/.dotfiles_backup/<timestamp>/.zshrc ~/
```

The installer does not revert `defaults` changes, `pmset` settings, installed packages or the Dock layout; undo those with `defaults delete`, `pmset`, `brew uninstall` or System Settings.
