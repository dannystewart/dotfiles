# Cache uname and hostname once per session
if not set -q FISH_CONFIG_LOADED
    set -gx FISH_CONFIG_LOADED 1

    # Cache uname result
    set -gx CACHED_UNAME (uname)

    # Cache hostname for abbreviations
    set -gx CACHED_HOSTNAME (hostname)
end

# Set timezone
set -x TZ America/New_York

# Initialize Homebrew if not already initialized
if not set -q HOMEBREW_PREFIX
    test -f /usr/local/bin/brew; and eval "$(/usr/local/bin/brew shellenv)"
    test -f /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"
    test -f /home/linuxbrew/.linuxbrew/bin/brew; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# Configure paths
source ~/.config/fish/conf.d/paths.fish

# Configure Python build dependencies
source ~/.config/fish/conf.d/python-build.fish

# Initialize pyenv
if command -v pyenv &>/dev/null
    pyenv init - | source
end

if status is-interactive
    # Lazy-load abbreviations
    function __load_abbreviations_once
        if not set -q ABBREVIATIONS_LOADED
            source ~/.config/fish/conf.d/abbreviations.fish
            set -g ABBREVIATIONS_LOADED 1
        end
    end
    function __fish_preexec --on-event fish_preexec
        __load_abbreviations_once
        functions -e __fish_preexec
    end

    # Bind Tab to complete-and-search
    bind \t complete-and-search

    # Warp terminal integration (SSH sessions only)
    if set -q SSH_CONNECTION
        printf 'P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish", "uname": "'$CACHED_UNAME'" }}�'
    end

    # Initialize Starship
    starship init fish | source
end
