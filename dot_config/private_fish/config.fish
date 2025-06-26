# Set timezone
set -x TZ America/New_York

# Initialize Homebrew
test -f /usr/local/bin/brew; and eval "$(/usr/local/bin/brew shellenv)"
test -f /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"
test -f /home/linuxbrew/.linuxbrew/bin/brew; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Configure paths
source ~/.config/fish/conf.d/paths.fish

# Configure Python and Ruby build dependencies
source ~/.config/fish/conf.d/python-ruby-build.fish

# Initialize pyenv
if command -v pyenv &>/dev/null
    pyenv init - | source
end

if status is-interactive
    # Configure abbreviations
    source ~/.config/fish/conf.d/abbreviations.fish

    # Bind Tab to complete-and-search
    bind \t complete-and-search

    # Warp terminal integration (SSH sessions only)
    if set -q SSH_CONNECTION
        printf 'P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish", "uname": "'$(uname)'" }}�'
    end

    # Initialize Starship
    starship init fish | source
end
