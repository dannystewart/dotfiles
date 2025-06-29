# Package manager abbreviations
switch (uname)
    case Darwin
        command -v mas &>/dev/null; and abbr -a macup mas upgrade
    case Linux
        command -v apt &>/dev/null; and abbr -a aptup "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
        command -v pacman &>/dev/null; and abbr -a pacup sudo pacman -Syu --noconfirm
        command -v dnf &>/dev/null; and abbr -a dnfup sudo dnf update -y
end

# Homebrew abbreviations
command -v brew &>/dev/null; and abbr -a bru "brew update && brew upgrade && brew cleanup"

# eza configuration
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"

# eza base command
function eza
    command eza --no-quotes --time-style='+%Y.%m.%d %I:%M %p' $argv
end

# eza: list
abbr -a l eza -1 --icons
abbr -a ls eza
abbr -a lf eza -1 --icons --group-directories-first # directories first
abbr -a lt eza --tree --level=1 # tree view

# eza: long list
abbr -a ll eza -l --icons --no-user
abbr -a lh eza -la --icons --no-user # same as above, just with hidden files
abbr -a llf eza -l --icons --no-user --group-directories-first # directories first
abbr -a lz eza -l --icons --no-user --total-size -rs size # with folder sizes, sorted by size
abbr -a lg eza -l --git --git-repos --total-size # with git repos and folder sizes
abbr -a lgz eza -l --git --git-repos --total-size -rs size # with repos, sorted by size

# eza: detailed list
abbr -a la eza -lga --git
abbr -a laf eza -lga --git --group-directories-first # directories first
abbr -a laz eza -lga --git --total-size -rs size # with folder sizes, sorted by size

# rsync abbreviations
abbr -a rsync-copy rsync -avz --progress -h
abbr -a rsync-move rsync -avz --progress -h --remove-source-files
abbr -a rsync-update rsync -avzu --progress -h
abbr -a rsync-synchronize rsync -avzu --delete --progress -h

# Other shell abbreviations
abbr -a cat bat -p
abbr -a cu chezmoi update
abbr -a ca chezmoi apply
abbr -a rt trash
abbr -a q exit

# Add Touch ID as allowable for sudo
abbr -a touchid sudo su root -c '/opt/homebrew/bin/gsed -i "2iauth       sufficient     pam_tid.so" /etc/pam.d/sudo'

# Python abbreviations
if command -v pip &>/dev/null
    # pip commands
    abbr -a pin pip install -U
    abbr -a pun pip uninstall -y
    abbr -a pie pip install -e .
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

# Docker abbreviations
if command -v docker &>/dev/null
    abbr -a dcu docker compose up -d
    abbr -a dcd docker compose down --remove-orphans
    abbr -a dcdu "docker compose down --remove-orphans && docker compose up -d"
    abbr -a dcdpu "docker compose down --remove-orphans && docker system prune -a -f -v && docker compose up -d"
    abbr -a dcr docker compose restart
    abbr -a dcl docker compose logs
    abbr -a dcp docker compose pull
    abbr -a dsp docker system prune -a -f -v
end

# Server-specific abbreviations
set -l current_hostname (hostname)
switch $current_hostname
    case web
        abbr -a prl prismlens
        abbr -a prp prismlens
        abbr -a prd prismlens dev
        abbr -a prrp prismlens restart
        abbr -a prrd prismlens dev restart
        abbr -a prra "cd ~/prism/prod && git fetch && git pull && prismlens restart all"
        abbr -a prli "cd ~/prism/dev/prismlens && pip install -e ."
end

# PowerShell abbreviations
abbr -a pim pwsh "/Users/danny/Developer/iri/iri-powershell/Azure/Set-PIM.ps1"
