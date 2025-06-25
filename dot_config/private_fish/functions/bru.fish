function bru --description 'Update Homebrew'
    set -g GREEN (set_color green)
    set -g RED (set_color red)
    set -g NC (set_color normal)

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
