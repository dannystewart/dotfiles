function opencode-move --description="update OpenCode references after project folder move"
    if test (count $argv) -ne 2
        echo "Usage: opencode-move <old-path> <new-path>"
        return 1
    end

    set old_path (string trim --right --chars=/ $argv[1])
    set new_path (string trim --right --chars=/ $argv[2])
    set db "$HOME/.local/share/opencode/opencode.db"

    if not test -f $db
        echo "Error: OpenCode database not found at $db"
        return 1
    end

    set matches (sqlite3 $db "SELECT COUNT(*) FROM project WHERE worktree = '$old_path';")
    if test "$matches" -eq 0
        echo "No project found with path: $old_path"
        echo "Current projects:"
        sqlite3 $db "SELECT worktree FROM project WHERE worktree != '/' ORDER BY worktree;"
        return 1
    end

    sqlite3 $db "
        UPDATE project SET worktree = '$new_path' WHERE worktree = '$old_path';
        UPDATE session SET directory = '$new_path' WHERE directory = '$old_path';
    "

    echo "✓ Updated OpenCode project path:"
    echo "  $old_path → $new_path"
end
