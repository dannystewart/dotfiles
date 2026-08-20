# Set timezone
set -gx TZ America/New_York

# Set default text editor based on what's available
for editor in code-insiders cursor code zed micro nano
    if command -q $editor
        set -gx EDITOR $editor
        break
    end
end

# Disable Homebrew environment variable hints
set -gx HOMEBREW_NO_ENV_HINTS 1

# Bypass Homebrew's confirmation prompt
set -gx NONINTERACTIVE 1

# Set config paths and directories
set -gx BAT_CONFIG_PATH "$HOME/.config/bat/config"
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx EZA_ICONS_AUTO true

# I've become everything I claimed to hate
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end

# Use bat for manpages and show icons in eza output
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Disable less history file
set -gx LESSHISTFILE /dev/null

# Use admin download mode for evremixes
set -gx EVREMIXES_ADMIN 1

# Set signing identity for Xcode
set -gx CODE_SIGN_IDENTITY "Apple Development: Danny Stewart (75GS56XYDQ)"

# Interactive shell configuration
if status is-interactive
    # Bind Tab to complete-and-search
    bind \t complete-and-search

    # Bind Ctrl+Alt+R to re-apply the Chezmoi state
    bind ctrl-alt-r _chezmoi_apply

    # Bind Ctrl+Alt+K to select a process to kill
    bind ctrl-alt-k _kill_process

    # Initialize Starship
    starship init fish | source
end
