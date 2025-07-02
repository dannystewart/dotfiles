set -x TZ America/New_York
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx LESSHISTFILE /dev/null
set -gx HOMEBREW_NO_ENV_HINTS true

if status is-interactive
    bind \t complete-and-search # Bind Tab to complete-and-search
    starship init fish | source
end
