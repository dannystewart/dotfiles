function czman --description "Find potential orphaned files in Chezmoi-managed directories"
    # Colors
    set -l yellow '\033[0;33m'
    set -l green '\033[0;32m'
    set -l blue '\033[0;34m'
    set -l cyan '\033[0;36m'
    set -l bold '\033[1m'
    set -l nc '\033[0m' # No Color

    # Files to ignore (known non-orphans)
    set ignore_patterns \
        ".bash_history" \
        ".bashrc" \
        ".claude.json" \
        ".env" \
        ".git-credentials" \
        ".local/share/*" \
        ".nuke_count" \
        ".pypirc" \
        ".python_build_mode" \
        ".ssh/known_hosts" \
        ".zsh_history" \
        ".zshrc" \
        "*/telegram-upload*" \
        "fish_history"

    echo -e "$green$bold🔍 Finding potential orphaned files in Chezmoi-managed directories..."$nc
    echo -e "$yellow   NOTE: "(count $ignore_patterns)" file patterns are being ignored."$nc
    echo

    # Get all files Chezmoi manages (as relative paths from home)
    set managed_files (chezmoi managed)

    # Extract unique directories where Chezmoi manages files (relative to home)
    set managed_dirs (for file in $managed_files; dirname $file; end | sort -u)

    # Create temp files for comparison
    set temp_managed (mktemp)
    set temp_actual (mktemp)
    set temp_filtered (mktemp)

    # Clean up temp files when function exits
    function cleanup --on-event fish_exit
        rm -f $temp_managed $temp_actual
    end

    printf '%s\n' $managed_files | sort >$temp_managed

    set found_any false
    for dir in $managed_dirs
        set abs_dir "$HOME/$dir"
        if test -d $abs_dir

            # Get all files in this directory (non-recursive, convert to relative paths)
            find $abs_dir -maxdepth 1 -type f | sed "s|$HOME/||" | sed "s|^\./||" | sort >$temp_actual

            # Find files in directory that are NOT managed by Chezmoi
            set all_orphans (comm -23 $temp_actual $temp_managed)

            # Filter out ignored patterns
            set orphans
            for file in $all_orphans
                set should_ignore false
                for pattern in $ignore_patterns
                    if string match -q $pattern $file
                        set should_ignore true
                        break
                    end
                end
                if not $should_ignore
                    set orphans $orphans $file
                end
            end

            if test -n "$orphans"
                set found_any true
                echo -e "$blue$bold📁 Potential orphans in: ~/$dir"$nc
                for orphan in $orphans
                    echo -e "$cyan  $orphan"$nc
                end
                echo
            end
        end
    end

    # Show no results message if nothing found
    if not $found_any
        echo -e "$green✨ No orphaned files found! Your home directory is clean!"$nc
    end

    # Clean up temp files
    rm -f $temp_managed $temp_actual
end
