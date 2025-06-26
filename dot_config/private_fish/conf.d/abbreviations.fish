# Package manager abbreviations
switch (uname)
    case Darwin
        command -v mas &>/dev/null; and abbr -a macup mas upgrade
    case Linux
        command -v apt &>/dev/null; and abbr -a aptup "sudo apt update && sudo apt upgrade -y"
        command -v pacman &>/dev/null; and abbr -a pacup sudo pacman -Syu
        command -v dnf &>/dev/null; and abbr -a dnfup sudo dnf update -y
end

# Homebrew abbreviations
command -v brew &>/dev/null; and abbr -a bru "brew update && brew upgrade && brew cleanup"

# Python abbreviations
if command -v pip &>/dev/null
    # pip commands
    abbr -a pipin pip install -U
    abbr -a pipun pip uninstall -y
    abbr -a pipie pip install -e .
    # Personal packages
    abbr -a pipds "pip uninstall -y dsbin && pip install -U dsbin"
    abbr -a pipdev "pip uninstall -y dsbin && pip install -U git+ssh://git@github.com/dannystewart/dsbin.git"
end

# Git abbreviations
if command -v git &>/dev/null
    abbr -a gs git status
    abbr -a ga git add -A
    abbr -a gc git commit -m
    abbr -a gfp "git fetch && git pull"
    abbr -a gac "git add -A && git commit -m"
    abbr -a gsc "git stash clear"
    abbr -a gp git push
end

# Server-specific abbreviations
switch (hostname)
    case web
        command -v prismlens &>/dev/null; and abbr -a pra "cd ~/prism/prod && git fetch && git pull && prismlens restart all"
        command -v prismlens &>/dev/null; and abbr -a prd "prismlens dev restart"
end
