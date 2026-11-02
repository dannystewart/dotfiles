function pullall
    set -l failed

    for dir in */
        # Only actual git repos (also catches worktrees, where .git is a file)
        git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; or continue

        echo "==> $dir"
        if not git -C "$dir" fetch; or not git -C "$dir" pull
            set -a failed "$dir"
        end
    end

    if set -q failed[1]
        echo "\nFailed to update:"
        printf '  %s\n' $failed
    end
end
