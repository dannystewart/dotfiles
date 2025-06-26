if status is-interactive
    # Clear and rebuild PATH
    set -e fish_user_paths # Clear user paths
    set -g fish_user_paths # Reset to empty

    # Add paths in reverse order (fish prepends)
    set path_candidates \
        /opt/homebrew/opt/openjdk/bin \
        /opt/homebrew/opt/findutils/libexec/gnubin \
        /usr/local/opt/findutils/libexec/gnubin \
        /var/lib/snapd/snap/bin \
        ~/.cargo/bin \
        ~/.rbenv/bin \
        ~/.pyenv/shims \
        ~/.pyenv/bin \
        ~/bin \
        ~/.bin \
        ~/.local/bin \
        ~/.local/bin/node \
        /usr/local/bin \
        /usr/libexec \
        /Library/Apple/usr/bin \
        /System/Cryptexes/App/usr/bin \
        /sbin \
        /opt/local/bin

    for path in $path_candidates
        if test -d $path
            fish_add_path $path
        end
    end

    # Set timezone
    set -x TZ "America/New_York"

    # Bind Tab to complete-and-search
    bind \t complete-and-search

    # Warp terminal integration (auto-Warpify subshells)
    printf 'P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish", "uname": "'$(uname)'" }}�'

    # Package manager abbreviations
    switch (uname)
        case Darwin
            command -v mas &>/dev/null; and abbr -a macup mas upgrade
        case Linux
            command -v apt &>/dev/null; and abbr -a aptup "sudo apt update && sudo apt upgrade -y"
            command -v pacman &>/dev/null; and abbr -a pacup sudo pacman -Syu
            command -v dnf &>/dev/null; and abbr -a dnfup sudo dnf update -y
        end
    command -v brew &>/dev/null; and abbr -a bru "brew update && brew upgrade && brew cleanup"

    # Python abbreviations if available
    if command -v pip &>/dev/null
        # pip commands
        abbr -a pipin pip install -U
        abbr -a pipun pip uninstall -y
        abbr -a pipie pip install -e .
        # Personal packages
        abbr -a pipds "pip uninstall -y dsbin && pip install -U dsbin"
        abbr -a pipdev "pip uninstall -y dsbin && pip install -U git+ssh://git@github.com/dannystewart/dsbin.git"
    end
end

# Homebrew setup
test -f /usr/local/bin/brew; and eval "$(/usr/local/bin/brew shellenv)"
test -f /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"
test -f /home/linuxbrew/.linuxbrew/bin/brew; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Initialize Starship
starship init fish | source
