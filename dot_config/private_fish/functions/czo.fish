function czo --description "Find or delete potential orphaned files in Chezmoi-managed directories"
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
        fish_history

    # Parse arguments
    set -l target_dir ""
    set -l delete_mode false

    if test (count $argv) -gt 0
        set target_dir $argv[1]
        set delete_mode true

        # Convert relative path to absolute and then to relative from home
        if string match -q '~/*' $target_dir
            set target_dir (string replace '~/' '' $target_dir)
        else if string match -q '/*' $target_dir
            # Convert absolute path to relative from home
            set target_dir (string replace "$HOME/" '' $target_dir)
        else if string match -q './*' $target_dir
            # Handle relative paths from current directory
            set target_dir (string replace './' '' (realpath $target_dir | string replace "$HOME/" ''))
        else
            # Assume it's already relative to home or handle other cases
            if test -d "$PWD/$target_dir"
                set target_dir (realpath "$PWD/$target_dir" | string replace "$HOME/" '')
            end
        end
    end

    if $delete_mode
        echo -e "$red$bold🗑️  Deleting orphaned files in ~/$target_dir"$clear
        echo
    else
        echo -e "$green$bold🔍 Finding potential orphaned files in Chezmoi-managed directories..."$clear
        echo -e "$yellow   NOTE: "(count $ignore_patterns)" file patterns are being ignored."$clear
        echo
    end

    # Get all files Chezmoi manages (as relative paths from home)
    set managed_files (chezmoi managed)

    if $delete_mode
        # Single directory mode - delete orphans
        set abs_target_dir "$HOME/$target_dir"

        if not test -d $abs_target_dir
            echo -e "$red❌ Directory ~/$target_dir does not exist!"$clear
            return 1
        end

        # Create temp files for comparison
        set temp_managed (mktemp)
        set temp_actual (mktemp)

        printf '%s\n' $managed_files | sort >$temp_managed

        # Get all files in the target directory (non-recursive, convert to relative paths)
        find $abs_target_dir -maxdepth 1 -type f | sed "s|$HOME/||" | sed "s|^\./||" | sort >$temp_actual

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

        if test -z "$orphans"
            echo -e "$green✨ No orphaned files found in ~/$target_dir!"$clear
            rm -f $temp_managed $temp_actual
            return 0
        end

        # Show what will be deleted
        echo -e "$blue$bold📁 Found "(count $orphans)" orphaned file(s) in ~/$target_dir:"$clear
        for orphan in $orphans
            echo -e "$cyan  $orphan"$clear
        end
        echo

        # Confirm deletion
        set -l prompt_text (printf "$red$bold⚠️  WARNING: This will permanently delete these files! Proceed? (y/N) $clear")
        read -l -P "$prompt_text" confirmation

        if test "$confirmation" = Y || test "$confirmation" = y
            set deleted_count 0
            for orphan in $orphans
                if rm "$HOME/$orphan" 2>/dev/null
                    echo -e "$green✓ Deleted: $orphan"$clear
                    set deleted_count (math $deleted_count + 1)
                else
                    echo -e "$red✗ Failed to delete: $orphan"$clear
                end
            end
            echo
            echo -e "$green$bold🗑️ Successfully deleted $deleted_count orphaned file(s)!"$clear
        else
            echo -e "$yellow⏹️  Deletion canceled."$clear
        end

        # Clean up temp files
        rm -f $temp_managed $temp_actual
    else
        # Original behavior - scan all managed directories
        # Extract unique directories where Chezmoi manages files (relative to home)
        set managed_dirs (for file in $managed_files; dirname $file; end | sort -u)

        # Create temp files for comparison
        set temp_managed (mktemp)
        set temp_actual (mktemp)

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
                    echo -e "$blue$bold📁 Potential orphans in: ~/$dir"$clear
                    for orphan in $orphans
                        echo -e "$cyan  $orphan"$clear
                    end
                    echo
                end
            end
        end

        # Show no results message if nothing found
        if not $found_any
            echo -e "$green✨ No orphaned files found! Your home directory is clean!"$clear
        else
            echo -e "$yellow💡 To delete orphans in a specific directory, run: czo <directory>"$clear
        end

        # Clean up temp files
        rm -f $temp_managed $temp_actual
    end
end
