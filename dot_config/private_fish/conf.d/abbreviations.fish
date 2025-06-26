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

# Shell abbreviations
abbr -a ls eza --oneline
abbr -a ll eza -l --no-user --no-permissions --icons
abbr -a la eza -la --no-user --no-permissions --icons
abbr -a lt eza --tree --level=1
abbr -a cat bat -p
abbr -a dud du -d 1 -h

# Disk usage by size
function duds --description 'Display disk usage sorted by size'
    du -d 1 -h $argv | sort -hr
end

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
    abbr -a gp git push
    abbr -a gsc git stash clear
    abbr -a gfp "git fetch && git pull"
    abbr -a gac "git add -A && git commit -m"
end

# Server-specific abbreviations
set -l current_hostname (hostname)
switch $current_hostname
    case web
        command -v prismlens &>/dev/null; and abbr -a pra "cd ~/prism/prod && git fetch && git pull && prismlens restart all"
        command -v prismlens &>/dev/null; and abbr -a prd prismlens dev restart
end

# PowerShell abbreviations
abbr -a pim pwsh "/Users/danny/Developer/iri/iri-powershell/Azure/Set-PIM.ps1"
