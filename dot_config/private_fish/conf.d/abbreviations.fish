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
function eza
    command eza -bg --no-permissions --no-quotes --smart-group --time-style='+%Y-%m-%d %I:%M %p' --group-directories-first --git --icons $argv
end
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
abbr -a ls eza
abbr -a l eza --oneline
abbr -a ll eza -l
abbr -a la eza -la
abbr -a lz eza -l --total-size
abbr -a lzs eza -l --total-size -s size -r
abbr -a lg eza -l --git-repos
abbr -a lt eza --tree --level=1
abbr -a lp command eza -lbg --no-quotes --time-style=long-iso
abbr -a cat bat -p
abbr -a cu chezmoi update
abbr -a ca chezmoi apply

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
    abbr -a gpf git push --force
    abbr -a gsc git stash clear
    abbr -a grhh git reset --hard HEAD
    abbr -a gfp "git fetch && git pull"
    abbr -a gac "git add -A && git commit -m"
end

# Server-specific abbreviations
set -l current_hostname (hostname)
switch $current_hostname
    case web
        abbr -a prp prismlens
        abbr -a prd prismlens dev
        abbr -a prrp prismlens restart
        abbr -a prrd prismlens dev restart
        abbr -a prra "cd ~/prism/prod && git fetch && git pull && prismlens restart all"
        abbr -a prli "cd ~/prism/dev/prismlens && pip install -e ."
end

# PowerShell abbreviations
abbr -a pim pwsh "/Users/danny/Developer/iri/iri-powershell/Azure/Set-PIM.ps1"
