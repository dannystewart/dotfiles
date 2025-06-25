# Color definitions for fish
set -g GREEN (set_color green)
set -g RED (set_color red)
set -g BLUE (set_color blue)
set -g YELLOW (set_color yellow)
set -g NC (set_color normal)

# Homebrew updates
function brewup
    if command -v brew >/dev/null 2>&1
        echo -e "$GREEN""Updating Homebrew...$NC"
        brew update
        echo -e "$GREEN""Installing updates...$NC"
        brew upgrade
        echo -e "$GREEN""Cleaning up...$NC"
        brew cleanup
        echo -e "$GREEN""Homebrew update complete!$NC"
    else
        echo -e "$RED""Error: Homebrew not found. Are you sure it's installed?$NC"
    end
end

# General aliases
function bru
    brewup
end

function vscode
    code $argv
end

function powershell
    pwsh $argv
end

function timeout
    gtimeout $argv
end

# Function to kill specified types of files
function kill_files
    set directory $argv[1]
    set name $argv[2]

    if test -z "$directory"
        set directory "."
    end

    if test -z "$name"
        echo "No file type specified."
        return 1
    end

    find "$directory" -name "$name" -print -delete
end

# Aliases for specific file types
function killds
    kill_files . ".DS_Store"
end

function killjunk
    find . \( -name "\$RECYCLE.BIN" -o -name "desktop.ini" -o -name "Thumbs.db" -o -name "Icon?" -o -name ".DS_Store" \) -print -delete
end

function killsc
    kill_files . "*.sync-conflict-*"
end

function killpkf
    kill_files . "*.pkf"
end

# Update all the things
function uatt
    set updated false
    set os_type (uname -s)

    echo -e "$BLUE""Updating all the things...$NC"

    if test "$os_type" = "Linux"
        if command -v apt-get >/dev/null 2>&1
            aptup
            set updated true
        else if command -v pacman >/dev/null 2>&1
            pacup
            set updated true
        else if command -v dnf >/dev/null 2>&1
            dnfup
            set updated true
        else if command -v softwareupdate >/dev/null 2>&1
            sudo softwareupdate --background
            set updated true
        else
            echo -e "$RED""No supported Linux package manager found (apt, pacman, dnf).$NC"
        end
    else if test "$os_type" != "Darwin"
        echo -e "$RED""Unsupported operating system: $os_type$NC"
    end

    if command -v brew >/dev/null 2>&1
        brewup
        set updated true
    end

    if command -v chezmoi >/dev/null 2>&1
        echo -e "$GREEN""Updating Chezmoi...$NC"
        chezmoi update
        echo -e "$GREEN""Chezmoi updated!$NC"
        set updated true
    end

    if test "$updated" = false
        echo -e "$RED""No updates were performed. Unsupported system or missing tools.$NC"
    else
        echo -e "$BLUE""All updates complete!$NC"
    end
end

# Disk usage and sizing aliases
function dud
    du -d 1 -h $argv
end

function duds
    du -d 1 -h $argv | sort -hr
end

function duf
    if command -v duf >/dev/null 2>&1
        command duf $argv
    else
        du -sh * $argv
    end
end

# Remove line from ~/.ssh/known_hosts
function rmknown
    if test -n "$argv[1]"
        if string match -qr '^[0-9]+$' "$argv[1]"
            gsed -i "$argv[1]"d ~/.ssh/known_hosts
            echo "Removed line $argv[1]"
        else
            echo "Error: Not a number" >&2
        end
    else
        echo "Error: No line number specified" >&2
    end
end

# Enhanced mosh function
function mosh
    switch "$argv[1]"
        case "saber" "calufrax" "defiant"
            set -e argv[1]  # Remove first argument
            command mosh --server=/opt/homebrew/bin/mosh-server $argv
        case '*'
            command mosh $argv
    end
end
