# Dotfiles

A macOS setup for zsh, git, SSH, Homebrew, system and app preferences, and the Dock, installed by one idempotent script with a common base and optional per-machine profiles.

## Install

Personal machine (default profile):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/filipejtdias/dotfiles/main/install.sh)"
```

Work machine (`work` profile):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/filipejtdias/dotfiles/main/install.sh)" -- --profile work
```

Unattended (no prompts, git identity from environment variables):

```bash
GIT_NAME="Jane Doe" GIT_EMAIL="jane@example.com" bash -c "$(curl -fsSL https://raw.githubusercontent.com/filipejtdias/dotfiles/main/install.sh)" -- -y
```

Add `--profile work` after `--` to combine it with `-y`.

From an existing clone:

```bash
./install.sh --profile <name>
```

The one-liners clone the repo to `~/code/dotfiles` (or run `git pull --rebase` if it is already there) and re-run the installer from the clone. The chosen profile is saved to `~/.dotfiles-profile` and reused on later runs, so `--profile` is only needed the first time or when switching.

## Contents

- [What you get](#what-you-get)
- [Requirements](#requirements)
- [Options](#options)
- [Profiles](#profiles)
- [Local overrides and secrets](#local-overrides-and-secrets)
- [Customising](#customising)
- [How it works](#how-it-works)
- [Manual steps and known limits](#manual-steps-and-known-limits)
- [Uninstall and restore](#uninstall-and-restore)
- [License](#license)

## What you get

- A common base plus profile layers (`personal`, `work`) selected with `--profile`.
- Homebrew packages, macOS defaults, per-app preferences and a Dock layout, each step optional.
- A zsh setup: options, aliases, exports, functions and prompt, split into small files.
- Git identity prompted for (or passed via environment), never hardcoded in the repo.
- Secrets and machine-specific settings kept in untracked `*.local` files.
- Safe re-runs: existing files are backed up, correct links are skipped.

## Requirements

- macOS only. The installer exits with an error on any other OS.
- Intel and Apple Silicon are both handled (Homebrew prefix `/usr/local` or `/opt/homebrew`, picked from `uname -m`).
- `git` and `curl` (shipped with macOS / Xcode Command Line Tools).
- Administrator rights: `sudo` is always requested up front (the Xcode step needs it).
- Homebrew is installed automatically if missing (non-interactive, using the official installer).
- Xcode is required and installed automatically (over 10 GB, from the Mac App Store with `mas`, before everything else). You must be signed in to the App Store before running.
- The repo must live at `~/code/dotfiles`. Run from anywhere else, the installer clones a fresh copy there (or runs `git pull --rebase` if one exists) and re-executes from it.

## Options

| Option | Effect |
| --- | --- |
| `-y`, `--yes` | Skip all prompts and answer yes to everything except opening download pages (never done with `-y`) |
| `--profile <name>`, `--profile=<name>` | Use `profiles/<name>/` (default `personal`); saved for later runs |
| `--reconfigure` | Ask for the git name and email again, offering the saved values as defaults |

| Environment variable | Effect |
| --- | --- |
| `GIT_NAME`, `GIT_EMAIL` | Git identity for non-interactive runs (use with `-y`) |

Examples from a clone:

```bash
GIT_NAME="Jane Doe" GIT_EMAIL="jane@example.com" ./install.sh -y
./install.sh --profile work -y
./install.sh --reconfigure
```

When the installer finishes, open a new terminal to load the shell config.

## Profiles

The base config is common to every machine. A profile layers machine-role specifics on top. Precedence: base, then profile, then `*.local` files.

| Profile | Contents |
| --- | --- |
| `personal` | Default; essentially empty |
| `work` | Extra tooling, Outlook/Defender/Zoom defaults, extra Dock entries, Tuist/make aliases |

Selection: `--profile <name>` accepts any directory under `profiles/` (letters, digits, `.`, `_`, `-`; no leading dot). The choice is written to `~/.dotfiles-profile`, which is machine-local and untracked. Later runs without the flag reuse it. With nothing saved and no flag, an interactive run asks `Profile [personal]:` and `-y` uses `personal`.

A profile directory can contain any of these files, all optional:

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

To add a profile, create `profiles/<name>/` with any of the files above and run `./install.sh --profile <name>`.

## Local overrides and secrets

Nothing machine-specific or secret belongs in tracked files. These are never committed (`.gitignore` covers `*.local`, `*.local.zsh`, `.DS_Store`):

| File | Purpose |
| --- | --- |
| `~/.gitconfig.local` | Git name and email, written by the installer; loaded last, wins over the profile |
| `~/.ssh/config.local` | Private SSH hosts and keys; included by `ssh/config` (missing file is ignored) |
| `shell/*.local.zsh` | Local aliases, exports, tokens; `shell/aliases.local.zsh` is created empty by the installer |
| `~/.dotfiles-profile` | Selected profile name |

## Customising

| To add | Do this |
| --- | --- |
| Package | Add a `brew`, `cask` or `mas "Name", id: N` line to `Brewfile` (or `profiles/<name>/Brewfile`) |
| Third-party tap | Add `tap "owner/repo"` to the Brewfile and the same name to `TRUSTED_TAPS` in `install.sh` |
| Dock app | Add an absolute path (or `"SPACER"`) to `DOCK_APPS` in `macos/dock.sh`; missing apps are skipped with a warning. Per profile, set `EXTRA_DOCK_APPS` in `profiles/<name>/dock.sh` |
| macOS or app preference | Add a `defaults write` block to `macos/defaults.sh` or `apps/defaults.sh` (or `profiles/<name>/defaults.sh`), following the existing sections |
| Download page | Add a URL to `urls.txt` (or `profiles/<name>/urls.txt`), one per line; `#` comments and blank lines are ignored |
| Directory | Add a path under `$HOME` to `directories.txt` (or `profiles/<name>/directories.txt`), one per line; `~` expands to `$HOME`, `#` comments and blank lines are ignored |
| Dotfile | Put it in the right directory, add a `create_symlink` line in `install.sh`, re-run |
| Alias, export, function | Edit the matching file under `shell/`, or add a new `shell/<name>.zsh` |

## How it works

How the shell loads: `.zprofile` sets up Homebrew; `.zshrc` sets zsh options, sources `shell/*.zsh` (skipping `*.local.zsh`), then `profiles/<name>/zsh/*.zsh`, then `shell/*.local.zsh`, and activates `mise` if `~/.local/bin/mise` exists.

<details>
<summary>Installer steps, in order</summary>

1. Checks the OS is macOS, bootstraps the clone at `~/code/dotfiles` if needed, parses flags.
2. Resolves the profile (see [Profiles](#profiles)) and detects the architecture.
3. Asks everything upfront (skipped with `-y`):
   - install Homebrew packages from the Brewfiles
   - apply macOS defaults (Dock, Finder, Trackpad, Energy, etc.)
   - apply app defaults
   - open download pages for manual installs (`urls.txt`); never done with `-y`
   - git name and email (kept silently if already in `~/.gitconfig.local`, unless `--reconfigure`)
4. Requests `sudo` once and keeps it alive for the run.
5. Homebrew: loads it into the session, or installs it.
6. Xcode (mandatory, always runs): the install is skipped if `/Applications/Xcode.app` exists; otherwise installs it with `mas` (App Store id 497799835), installing `mas` first if needed. If that fails (usually not signed in to the App Store), the installer stops with an error before any later step; sign in and re-run it. Then it selects Xcode as the active developer directory if needed, accepts the Xcode license (`sudo xcodebuild -license accept`, skipped if already accepted; stops with an error if that fails) and runs `sudo xcodebuild -runFirstLaunch` (a failure there is only a warning).
7. With the Brewfile step selected, it taps and trusts the third-party taps in `TRUSTED_TAPS` (if this Homebrew has `brew trust`), then runs `brew bundle` for `Brewfile` and `profiles/<name>/Brewfile`.
8. Opens the URLs in `urls.txt` and `profiles/<name>/urls.txt`, if you said yes.
9. Creates the directories in `directories.txt` and `profiles/<name>/directories.txt` (always, including with `-y`; only paths under `$HOME`, existing ones are left alone).
10. Symlinks the dotfiles (see the table below). Existing files are moved to `~/.dotfiles_backup/<timestamp>/` first.
11. Saves the profile to `~/.dotfiles-profile`, links the profile's `gitconfig` and `ssh_config`, creates an empty `shell/aliases.local.zsh` if missing.
12. Writes the git identity to `~/.gitconfig.local`; warns if it is still unset.
13. Runs `macos/defaults.sh`, `macos/dock.sh`, `macos/energy.sh` (if selected).
14. Runs `apps/defaults.sh`, then `profiles/<name>/defaults.sh` if present (if selected).

</details>

<details>
<summary>Symlinks created</summary>

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

</details>

<details>
<summary>Repository layout</summary>

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

</details>

## Manual steps and known limits

- Several `defaults` changes need a logout or restart to fully apply; the script restarts Dock, Finder, SystemUIServer and cfprefsd itself.
- Some settings are written but may not be honoured on recent macOS (the scripts note this): Safari preferences (sandboxed container), Mission Control and screensaver idle-time keys. Set these in System Settings or Safari Settings if they do not take effect.
- Zoom's menu bar icon can only be hidden in the app (work profile).
- The installer asks for your password up front and, if macOS resets it mid-run (a Homebrew or cask installer can), again at the Homebrew, macOS defaults and app defaults steps.
- Sign in to the App Store before running: Xcode and the `mas` apps in the Brewfile need it. The installer accepts the Xcode license on your behalf, so by running it you agree to Apple's Xcode terms. Xcode cannot be skipped.
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

## License

Released under the [MIT License](LICENSE).
