# Chezmoi Dotfiles

Welcome to my dotfiles repo! This is my personal, ever-evolving collection of configs, scripts, and shell tweaks.

It's managed with [Chezmoi](https://www.chezmoi.io/) so everything is portable and reproducible. Things like secrets and SSH keys are encrypted with [age](https://www.chezmoi.io/user-guide/encryption/age/). I regularly prune, refactor, and add new helpers as my workflow evolves. If you spot something useful, feel free to borrow or adapt!

## One-Line Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dannystewart
```

## What's Inside?

### 🐟 Fish + 🚀 Starship

- Modular config in `conf.d/` (paths, Homebrew, pyenv, abbreviations, and more).
- Plugin management via [fisher](https://github.com/jorgebucaran/fisher) and a curated set of plugins (see `fish_plugins`).
- Handy abbreviations for git, Docker, Python, Homebrew, Chezmoi, and more (`90-abbreviations.fish`).
- A beautiful custom Starship prompt (`starship.toml`).
- Custom completions for a bunch of my own scripts and tools.

#### Functions and Plugins

- `ls`: Smart wrapper for `eza` with pretty output and fallback to `ls`.
- `uatt`: One command to update all the things (OS, Homebrew, Chezmoi, etc.).
- `killfiles`: Cleans up junk files (macOS, Windows, Python, etc.).
- `czo`: Finds orphaned files in Chezmoi-managed directories.
- Many more helpers and wrappers for daily tasks.

#### Fish Plugins

- `z`: Smart directory jumping based on frecent (frequent + recent) folders.
- `sponge`: Cleans up invalid commands from your Fish history.
- `autopair`: Auto-closing brackets/quotes.
- `done`: Desktop notifications when long-running commands finish.
- `bang-bang`, `extract`, `colored_man_pages`, and more.

### 🛠️ Other Goodies

- PowerShell customizations for cross-platform shell consistency (`Microsoft.PowerShell_profile.ps1`), including its own Starship prompt variant (`starship_pwsh.toml`).
- Completions for my own scripts and tools (in `completions/`).
- macOS, Linux, and even some Windows-specific helpers and abbreviations.

## Automated Setup

One of my favorite things here is the trio of setup scripts that handle almost everything for you when setting up a new machine:

- `run_once_before_decrypt.sh.tmpl` installs the `age` encryption tool using your system's package manager, then securely decrypts your secrets. It's smart enough to handle macOS, Linux, and even Windows edge cases.

- `run_once_packages.sh.tmpl` installs all my essential packages, no matter the OS or package manager (Homebrew, apt, pacman, dnf, etc.). It  handles Homebrew on Apple Silicon and x86, and ensures all my favorite CLI tools are ready to go.

- `run_once_after_fish.sh.tmpl` makes sure Fish is installed, sets it as the default shell (with all the right permissions and `/etc/shells` tweaks), and ensures the [Starship](https://starship.rs/) is available and configured.

With these, I just clone the repo and the whole thing basically sets itself up for me in just a minute or two, with almost zero manual intervention.
