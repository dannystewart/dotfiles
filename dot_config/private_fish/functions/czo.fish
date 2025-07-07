function czo --description "Find or delete potential orphaned files in Chezmoi-managed directories"
    # Files to ignore (known non-orphans)
    set ignore_patterns \
        ".bash_history" \
        ".bashrc" \
        ".claude.json" \
        ".git-credentials" \
        ".local/share/*" \
        ".nuke_count" \
        ".pypirc" \
        ".python_build_mode" \
        ".ssh/known_hosts" \
        ".zsh_history" \
        ".zshrc" \
        "*/.env" \
        "*/fish_history" \
        "*/fish_variables" \
        "*/telegram-upload*" \
        "*/updater"

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
        error --bold "🗑️  Deleting orphaned files in ~/$target_dir"
        echo
    else
        success --bold "🔍 Finding potential orphaned files in Chezmoi-managed directories..."
        warning "   NOTE: "(count $ignore_patterns)" file patterns are being ignored."
        echo
    end

    # Get all files Chezmoi manages (as relative paths from home)
    set managed_files (chezmoi managed)

    if $delete_mode
        # Single directory mode - delete orphans
        set abs_target_dir "$HOME/$target_dir"

        if not test -d $abs_target_dir
            error "❌ Directory ~/$target_dir does not exist!"
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
            success "✨ No orphaned files found in ~/$target_dir!"
            rm -f $temp_managed $temp_actual
            return 0
        end

        # Show what will be deleted
        info --bold "📁 Found "(count $orphans)" orphaned file(s) in ~/$target_dir:"
        for orphan in $orphans
            echo -e "$cyan  $orphan"$clear
        end
        echo

        # Confirm deletion
        set -l prompt_text (error "⚠️  WARNING: This will permanently delete these files! Proceed? (y/N) ")
        read -l -P "$prompt_text" confirmation

        if test "$confirmation" = Y || test "$confirmation" = y
            set deleted_count 0
            for orphan in $orphans
                if rm "$HOME/$orphan" 2>/dev/null
                    success "✓ Deleted: $orphan"
                    set deleted_count (math $deleted_count + 1)
                else
                    error "✗ Failed to delete: $orphan"
                end
            end
            echo
            success --bold "🗑️ Successfully deleted "(pluralize $deleted_count 'orphaned file')"!"
        else
            warning "⏹️  Deletion canceled."
        end

        # Clean up temp files
        rm -f $temp_managed $temp_actual
    else
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
                    info --bold "📁 Potential orphans in: ~/$dir"
                    for orphan in $orphans
                        echo -e "$cyan  $orphan"$clear
                    end
                    echo
                end
            end
        end

        # Show no results message if nothing found
        if not $found_any
            success "✨ No orphaned files found! Your home directory is clean!"
        else
            warning "💡 To delete orphans in a specific directory, run: czo <directory>"
        end

        # Clean up temp files
        rm -f $temp_managed $temp_actual
    end
end
