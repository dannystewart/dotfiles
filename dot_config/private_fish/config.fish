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

    # OS-specific abbreviations
    if command -v apt &>/dev/null # Debian-based distros
        abbr -a aptup "sudo apt update && sudo apt upgrade -y"
    else if command -v pacman &>/dev/null # Arch-based distros
        abbr -a pacup sudo pacman -Syu
    else if command -v dnf &>/dev/null # Red Hat-based distros
        abbr -a dnfup sudo dnf update -y
    else if command -v mas &>/dev/null # macOS
        abbr -a macup mas upgrade
    end

    # Homebrew updater if available
    if command -v brew &>/dev/null
        abbr -a bru "brew update && brew upgrade && brew cleanup"
    end

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
if test -f /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
else if test -f /usr/local/bin/brew
    eval "$(/usr/local/bin/brew shellenv)"
else if test -f /home/linuxbrew/.linuxbrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

starship init fish | source
