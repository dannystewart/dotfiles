function changelog
    git --no-pager log --oneline --reverse --since="$argv[1]" $argv[2..]
end
