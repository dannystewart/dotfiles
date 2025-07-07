set -gx BAT_CONFIG_PATH "$HOME/.config/bat/config"
set -gx EDITOR cursor
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx EZA_ICONS_AUTO true
set -gx HOMEBREW_NO_ENV_HINTS true
set -gx LESSHISTFILE /dev/null
set -gx TZ America/New_York

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
