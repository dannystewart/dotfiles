function killfiles --description 'Delete files by pattern or predefined shortcuts'
    set directory "."
    set patterns

    # Parse arguments
    set i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case '-d' '--directory'
                set i (math $i + 1)
                if test $i -le (count $argv)
                    set directory $argv[$i]
                else
                    echo "Error: -d requires a directory argument"
                    return 1
                end
            case 'ds' 'dsstore'
                set patterns $patterns ".DS_Store"
            case 'sc' 'sync-conflict'
                set patterns $patterns "*.sync-conflict-*"
            case 'pkf'
                set patterns $patterns "*.pkf"
            case 'py' 'python-cache'
                set patterns $patterns "*.egg-info" ".idea" ".mypy_cache" ".pytest_cache" ".ruff_cache" ".tox" ".coverage" ".coverage""__pycache__" "*.pyc" "*.pyo"
            case 'junk' 'windows-junk'
                set patterns $patterns "\$RECYCLE.BIN" "desktop.ini" "Thumbs.db" "Icon?" ".DS_Store"
            case '--help' '-h'
                echo "Usage: killfiles [options] [pattern|shortcut]..."
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
                echo "  killfiles ds                    # Delete .DS_Store files"
                echo "  killfiles '*.tmp'               # Delete .tmp files"
                echo "  killfiles -d ~/Downloads sc     # Delete sync conflicts in Downloads"
                echo "  killfiles junk py               # Delete both junk and Python cache files"
                return 0
            case '*'
                # Treat as a literal pattern
                set patterns $patterns $argv[$i]
        end
        set i (math $i + 1)
    end

    if test (count $patterns) -eq 0
        echo "Error: No patterns specified. Use --help for usage."
        return 1
    end

    # Execute find commands for each pattern
    for pattern in $patterns
        echo "Searching for: $pattern"
        find "$directory" -name "$pattern" -print -delete 2>/dev/null
    end

    echo "File cleanup complete!"
end
