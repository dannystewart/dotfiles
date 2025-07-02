# Configure paths and dependencies once per session
if not set -q FISH_CONFIG_LOADED
    set -gx FISH_CONFIG_LOADED 1
    source ~/.config/fish/conf.d/paths.fish
    source ~/.config/fish/conf.d/pythonbuild.fish
end

# Set environment variables
set -x TZ America/New_York
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx LESSHISTFILE /dev/null
set -gx HOMEBREW_NO_ENV_HINTS true

# Initialize Homebrew
if not set -q HOMEBREW_PREFIX
    test -f /usr/local/bin/brew; and eval "$(/usr/local/bin/brew shellenv)"
    test -f /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"
    test -f /home/linuxbrew/.linuxbrew/bin/brew; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# Initialize pyenv
set -l pyenv_cache ~/.cache/fish/pyenv_init
if not test -f $pyenv_cache; or test (which pyenv) -nt $pyenv_cache
    if command -v pyenv &>/dev/null
        mkdir -p (dirname $pyenv_cache)
        pyenv init - >$pyenv_cache
    end
end
test -f $pyenv_cache; and source $pyenv_cache

# Initialize interactive shell
if status is-interactive
    source ~/.config/fish/conf.d/abbreviations.fish
    bind \t complete-and-search # Bind Tab to complete-and-search
    starship init fish | source
end
