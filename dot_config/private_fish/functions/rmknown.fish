function rmknown --description 'Remove line from ~/.ssh/known_hosts'
    if test -n "$argv[1]"
        if string match -qr '^[0-9]+$' "$argv[1]"
            set line_num $argv[1]
            # Check if gsed is available, otherwise use regular sed
            if command -q gsed
                gsed -i -e "$line_num d" ~/.ssh/known_hosts
            else
                # Use regular sed with different syntax for macOS/BSD
                sed -i '' -e "$line_num d" ~/.ssh/known_hosts
            end
            echo "Removed line $argv[1]"
        else
            echo "Error: Not a number" >&2
        end
    else
        echo "Error: No line number specified" >&2
    end
end
