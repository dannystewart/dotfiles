function uatt --description "Update all the things"
    set -l updated false
    set -l os_type (uname -s)
    set -l start_time (date +%s)

    # Update all the things
    info --bold " Updating all the things!"
    success " Hang tight, here we go...\n"

    if test "$os_type" = Linux
        if command -q apt-get
            # apt (Debian/Ubuntu)
            sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
            set updated true
            echo -e "" # line break for visual consistency
        else if command -q pacman
            # pacman (Arch)
            sudo pacman -Syu --noconfirm
            set updated true
            echo -e "" # line break for visual consistency
        else if command -q dnf
            # dnf (Fedora)
            sudo dnf update -y
            set updated true
        else
            error "No supported Linux package manager found (apt, pacman, dnf)."
        end
    else if test "$os_type" != Darwin
        echo -e "$red"Unsupported operating system: $os_type"$clear"
    end

    # mas (Mac App Store)
    if command -q mas
        mas upgrade
        set updated true
    end

    # Homebrew
    if command -q brew
        brew update && brew upgrade && brew cleanup
        set updated true
    end

    # Chezmoi
    if command -q chezmoi
        echo -e "$blue"\n'==> '"$clear$bold"'Updating Chezmoi...'"$clear"
        chezmoi update
        set updated true
    end

    # Calculate elapsed time
    set -l end_time (date +%s)
    set -l elapsed_time (math $end_time - $start_time)
    set -l duration_text (format_duration $elapsed_time)

    if test "$updated" = false
        error " No updates performed. Unsupported system or missing tools."
    else
        success "\n󰸞 All updates completed in "$duration_text"!"
    end
end
