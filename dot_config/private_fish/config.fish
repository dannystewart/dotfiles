# Set timezone (always needed)
set -x TZ America/New_York

# Initialize Homebrew
test -f /usr/local/bin/brew; and eval "$(/usr/local/bin/brew shellenv)"
test -f /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"
test -f /home/linuxbrew/.linuxbrew/bin/brew; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Configure Python and Ruby builds to use Homebrew dependencies
source ~/.config/fish/conf.d/python-ruby-build.fish

# Initialize pyenv
if command -v pyenv &>/dev/null
    pyenv init - | source
end

if status is-interactive
    # Configure paths and abbreviations
    source ~/.config/fish/conf.d/paths.fish
    source ~/.config/fish/conf.d/abbreviations.fish

    # Bind Tab to complete-and-search
    bind \t complete-and-search

    # Initialize Starship
    starship init fish | source

    # Warp terminal integration
    printf ' P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish", "uname": "'$(uname)'" }}�'
end
