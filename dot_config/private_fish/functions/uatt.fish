function uatt --description "Update all the things"
    # Colors
    set -l red '\033[0;31m'
    set -l green '\033[0;32m'
    set -l blue '\033[0;34m'
    set -l cyan '\033[0;36m'
    set -l bold '\033[1m'
    set -l nc '\033[0m' # No Color

    # Variables
    set -l updated false
    set -l os_type (uname -s)
    set -l start_time (date +%s)

    # Update all the things
    echo -e "$cyan$bold" Updating all the things!"$nc"
    echo -e "$green" Hang tight, here we go...\n"$nc"


    if test "$os_type" = "Linux"
        if command -v apt-get &>/dev/null
            # apt (Debian/Ubuntu)
            sudo apt update && sudo apt upgrade -y
            set updated true
        else if command -v pacman &>/dev/null
            # pacman (Arch)
            sudo pacman -Syu --noconfirm
            set updated true
        else if command -v dnf &>/dev/null
            # dnf (Fedora)
            sudo dnf update -y
            set updated true
        else
            echo -e "$red"No supported Linux package manager found (apt, pacman, dnf)."$nc"
        end
        echo -e "" # line break for visual consistency
    else if test "$os_type" != "Darwin"
        echo -e "$red"Unsupported operating system: $os_type"$nc"
    end

    # mas (Mac App Store)
    if command -v mas &>/dev/null
        mas upgrade
        set updated true
    end

    # Homebrew
    if command -v brew &>/dev/null
        brew update && brew upgrade && brew cleanup
        set updated true
    end

    # softwareupdate (macOS)
    if command -v softwareupdate &>/dev/null
        echo -e "$blue"\n'==> '"$nc$bold"'Updating macOS...'"$nc"
        if sudo -n true 2>/dev/null
            sudo softwareupdate --background
            set updated true
        else
            echo -e "Run with sudo to update macOS."
        end
    end

    # Chezmoi
    if command -v chezmoi &>/dev/null
        echo -e "$blue"\n'==> '"$nc$bold"'Updating Chezmoi...'"$nc"
        chezmoi update
        set updated true
    end

    # Function to format elapsed completion time
    function format_duration --argument-names total_seconds
        set -l minutes (math --scale=0 "$total_seconds / 60")
        set -l seconds (math "$total_seconds % 60")

        # Handle pluralization
        set -l sec_word "second"
        set -l min_word "minute"

        if test $seconds -ne 1
            set sec_word "seconds"
        end

        if test $minutes -ne 1
            set min_word "minutes"
        end

        # Format based on values
        if test $minutes -eq 0
            echo "$seconds $sec_word"
        else if test $seconds -eq 0
            echo "$minutes $min_word"
        else
            echo "$minutes $min_word and $seconds $sec_word"
        end
    end

    # Calculate elapsed time
    set -l end_time (date +%s)
    set -l elapsed_time (math $end_time - $start_time)
    set -l duration_text (format_duration $elapsed_time)

    if test "$updated" = false
        echo -e "$red" No updates performed. Unsupported system or missing tools."$nc"
    else
        echo -e "$green"\n󰸞 All updates completed in "$duration_text"!"$nc"
    end
end
