# Platform-specific abbreviations
switch (uname)
    case Darwin
        # Mac App Store updater
        command -v mas &>/dev/null; and abbr -a macup mas upgrade
        # PowerShell abbreviations
        abbr -a pim pwsh "/Users/danny/Developer/iri/iri-powershell/Azure/Set-PIM.ps1"
        # Add Touch ID as allowable for sudo
        abbr -a touchid sudo su root -c '/opt/homebrew/bin/gsed -i "2iauth       sufficient     pam_tid.so" /etc/pam.d/sudo'
        # Bluetooth reset
        abbr -a btreset "blueutil -p 0 && sleep 1 && blueutil -p 1"
    case Linux
        # Linux package managers
        command -v apt &>/dev/null; and abbr -a aptup "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
        command -v pacman &>/dev/null; and abbr -a pacup sudo pacman -Syu --noconfirm
        command -v dnf &>/dev/null; and abbr -a dnfup sudo dnf update -y
end

# Homebrew abbreviations
command -v brew &>/dev/null; and abbr -a bru "brew update && brew upgrade && brew cleanup"

# Chezmoi abbreviations
abbr -a cu chezmoi update
abbr -a ca chezmoi apply

# ls abbreviations
abbr -a l ls -1
abbr -a ll ls -l --no-user
abbr -a lt ls --tree --level=1 # tree view
abbr -a la ls -la --no-user # same as above, just with hidden files
abbr -a lz ls -l --no-user --total-size -rs size # with folder sizes, sorted by size
abbr -a lv ls -lga --git # verbose (includes user, group, and git status)
abbr -a lvz ls -lga --git --total-size -rs size # with folder sizes, sorted by size

# Other shell helpers
abbr -a rt trash # like rm, but to the trash
abbr -a rsync-copy rsync -avz --progress -h
abbr -a rsync-move rsync -avz --progress -h --remove-source-files
abbr -a rsync-update rsync -avzu --progress -h
abbr -a rsync-synchronize rsync -avzu --delete --progress -h

# Python
if command -v pip &>/dev/null
    # pip commands
    abbr -a pin pip install -U
    abbr -a pun pip uninstall -y
    abbr -a pie pip install -e .
    # Personal packages
    abbr -a pipds "pip uninstall -y dsbin && pip install -U dsbin"
    abbr -a pipdev "pip uninstall -y dsbin && pip install -U git+ssh://git@github.com/dannystewart/dsbin.git"
end

# Git
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

# Docker
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

# Server-specific
switch $CACHED_HOSTNAME
    case web
        # Prism
        abbr -a prl prismlens
        abbr -a prp prismlens
        abbr -a prd prismlens dev
        abbr -a prrp prismlens restart
        abbr -a prrd prismlens dev restart
        abbr -a prra "cd ~/prism/prod && git fetch && git pull && prismlens restart all"
        abbr -a prli "cd ~/prism/dev/prismlens && pip install -e ."
end
