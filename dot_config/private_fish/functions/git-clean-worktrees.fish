function git-clean-worktrees --description 'Prune stale worktrees and delete their local branches'
    # Collect branch names associated with prunable worktrees
    set -l branches (git worktree list --porcelain | awk '/^worktree/{b=""} /^branch/{b=$2} /^prunable/{if(b!=""){sub("refs/heads/","",b); print b}}')

    if test (count $branches) -eq 0
        echo "No prunable worktrees found."
        return 0
    end

    # Move off any branch we're about to delete
    set -l current (git branch --show-current)
    for b in $branches
        if test "$current" = "$b"
            git switch main; or git switch master
            break
        end
    end

    # Prune stale worktree metadata, then delete the associated branches
    git worktree prune --verbose
    for b in $branches
        git branch -D $b
    end
end
