function mosh --description 'Enhanced mosh function'
    switch "$argv[1]"
        case "saber" "calufrax" "defiant"
            set -e argv[1]  # Remove first argument
            command mosh --server=/opt/homebrew/bin/mosh-server $argv
        case '*'
            command mosh $argv
    end
end
