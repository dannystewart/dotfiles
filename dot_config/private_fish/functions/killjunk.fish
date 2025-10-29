function killjunk --description 'Delete files by pattern or predefined shortcuts'
    set directory "."
    set patterns

    # Parse arguments
    set i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -d --directory
                set i (math $i + 1)
                if test $i -le (count $argv)
                    set directory $argv[$i]
                else
                    error "Error: -d requires a directory argument"
                    return 1
                end
            case ds dsstore
                set patterns $patterns ".DS_Store"
            case sc sync-conflict
                set patterns $patterns "*.sync-conflict-*"
            case pkf
                set patterns $patterns "*.pkf"
            case py python-cache
                set patterns $patterns "*.egg-info" ".idea" ".mypy_cache" ".pytest_cache" ".ruff_cache" ".tox" ".coverage" "__pycache__" "*.pyc" "*.pyo"
            case junk windows-junk
                set patterns $patterns "\$RECYCLE.BIN" "desktop.ini" "Thumbs.db" "Icon?" ".DS_Store"
            case --help -h
                echo "Usage: killjunk [options] [pattern|shortcut]..."
                echo ""
                echo "Options:"
                echo "  -d, --directory DIR    Directory to search (default: current)"
                echo ""
                echo "Shortcuts:"
                echo "  junk                  Windows and macOS junk files"
                echo "  ds, dsstore           .DS_Store files"
                echo "  sc, sync-conflict     Sync conflict files"
                echo "  pkf                   Audition .pkf files"
                echo "  py, python-cache      Python cache files"
                echo ""
                echo "Examples:"
                echo "  killjunk ds                    # Delete .DS_Store files"
                echo "  killjunk '*.tmp'               # Delete .tmp files"
                echo "  killjunk -d ~/Downloads sc     # Delete sync conflicts in Downloads"
                echo "  killjunk junk py               # Delete both junk and Python cache files"
                return 0
            case '*'
                # Treat as a literal pattern
                set patterns $patterns $argv[$i]
        end
        set i (math $i + 1)
    end

    if test (count $patterns) -eq 0
        error "No patterns specified. Use --help for usage."
        return 1
    end

    set -l total_deleted 0

    # Execute find commands for each pattern
    for pattern in $patterns
        info "Searching for: $pattern"
        # First find and print what will be deleted
        set found_items (find "$directory" -name "$pattern" -print 2>/dev/null)
        if test (count $found_items) -gt 0
            for item in $found_items
                warning "  Found: $item"
            end
            # Delete files first, then directories (in reverse order for nested structures)
            find "$directory" -name "$pattern" -type f -delete 2>/dev/null
            find "$directory" -name "$pattern" -type d -exec rm -rf {} + 2>/dev/null
            success "  Deleted "(pluralize (count $found_items) item)" total."
            set total_deleted (math $total_deleted + (count $found_items))
        else
            echo "  No matches found"
        end
        echo ""
    end

    if test $total_deleted -gt 0
        success "File cleanup complete! Deleted "(pluralize $total_deleted item)" total."
    else
        info "File cleanup complete! No files were deleted."
    end
end
