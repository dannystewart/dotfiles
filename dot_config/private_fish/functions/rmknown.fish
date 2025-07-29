function rmknown --description 'Remove line from ~/.ssh/known_hosts'
    if test -n "$argv[1]"
        if string match -qr '^[0-9]+$' "$argv[1]"
            awk -v line="$argv[1]" 'NR != line' ~/.ssh/known_hosts > ~/.ssh/known_hosts.tmp && mv ~/.ssh/known_hosts.tmp ~/.ssh/known_hosts
            echo "Removed line $argv[1]"
        else
            echo "Error: Not a number" >&2
        end
    else
        echo "Error: No line number specified" >&2
    end
end
