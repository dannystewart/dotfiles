# Set timezone
set -gx TZ America/New_York

# Set default text editor based on what's available
if command -q cursor
    set -gx EDITOR cursor
else if command -q code
    set -gx EDITOR code
else
    set -gx EDITOR nano
end

# Disable Homebrew environment variable hints
set -gx HOMEBREW_NO_ENV_HINTS 1

# Set config paths and directories
set -gx BAT_CONFIG_PATH "$HOME/.config/bat/config"
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx EZA_ICONS_AUTO true
set -gx NVM_DIR "$HOME/.nvm"

# Use bat for manpages and show icons in eza output
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Disable less history file
set -gx LESSHISTFILE /dev/null

# Use admin download mode for evremixes
set -gx EVREMIXES_ADMIN 1

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
