# Platform-specific abbreviations
switch (uname)
    case Darwin
        # Mac App Store updater
        abbr -a macup mas upgrade
        # PowerShell abbreviations
        abbr -a pim pwsh "/Users/danny/Developer/iri/iri-powershell/Azure/Set-PIM.ps1"
        # Add Touch ID as allowable for sudo
        abbr -a touchid sudo su root -c '/opt/homebrew/bin/gsed -i "2iauth       sufficient     pam_tid.so" /etc/pam.d/sudo'
        # Bluetooth reset
        abbr -a btreset "blueutil -p 0 && sleep 1 && blueutil -p 1"
    case Linux
        # Linux package managers
        command -q apt; and abbr -a aptup "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
        command -q pacman; and abbr -a pacup sudo pacman -Syu --noconfirm
        command -q dnf; and abbr -a dnfup sudo dnf update -y
        command -q zypper; and abbr -a zup sudo zypper --non-interactive update
end

# Homebrew abbreviations
abbr -a bru "brew update && brew upgrade && brew cleanup"

# Chezmoi abbreviations
abbr -a czu chezmoi update
abbr -a cza chezmoi apply

# ls abbreviations
abbr -a l ls -1 # basic vertical list
abbr -a ll ls -l --no-user # ls + times, sizes, and permissions
abbr -a la ls -la --no-user # ll + hidden files
abbr -a lz ls -la --no-user --total-size -rs size # la + sort by size
abbr -a lv ls -lga --git # la + group and git status (verbose)
abbr -a lt ls --tree --level=1 # tree view

# Other shell helpers
abbr -a rt trash # like rm, but to the trash
abbr -a rsync-copy rsync -avz --progress -h
abbr -a rsync-move rsync -avz --progress -h --remove-source-files
abbr -a rsync-update rsync -avzu --progress -h
abbr -a rsync-synchronize rsync -avzu --delete --progress -h

# Python commands
abbr -a pin pip install -U
abbr -a pun pip uninstall -y
abbr -a pie pip install -e .

# Personal Python packages
abbr -a pipds "pip uninstall -y dsbin && pip install -U dsbin"
abbr -a pipdev "pip uninstall -y dsbin && pip install -U git+ssh://git@github.com/dannystewart/dsbin.git"

# Git
abbr -a gs git status
abbr -a ga git add -A
abbr -a gc git commit -m
abbr -a gca git commit --amend --no-edit
abbr -a gp git push
abbr -a gpff git push --force
abbr -a gsc git stash clear
abbr -a grhh git reset --hard HEAD
abbr -a gfp "git fetch && git pull"
abbr -a gac "git add -A && git commit -m"

# Docker
abbr -a dcu docker compose up -d
abbr -a dcd docker compose down --remove-orphans
abbr -a dcdu "docker compose down --remove-orphans && docker compose up -d"
abbr -a dcdpu "docker compose down --remove-orphans && docker system prune -a -f --volumes && docker compose up -d"
abbr -a dcr docker compose restart
abbr -a dcl docker compose logs
abbr -a dcp docker compose pull
abbr -a dsp docker system prune -a -f --volumes

# Computer-specific
switch (hostname)
    case web
        # Fetch, pull, and restart both Prism instances
        abbr -a prra "cd ~/prism/prod && git fetch && git pull && prismlens restart all"
end

# Helper function to re-apply Chezmoi state
function _chezmoi_apply
    chezmoi apply
    success "Chezmoi applied!"
    fish_prompt
end

# Helper function to find and kill a process
function _kill_process
    ps aux | fzf --header="Select process to kill" | awk \'{print $2}\' | xargs kill
    commandline -f repaint
end
