function _check_archiver --description "Check if archive command is available for given format"
    set --local format $argv[1]

    switch $format
        case tar gz tgz bz2
            set --local cmd tar
            if not command -v $cmd >/dev/null
                echo "Error: '$cmd' command not found. Please install tar."
                return 1
            end
        case rar
            set --local cmd rar unrar
            set --local missing_cmds
            for c in $cmd
                if not command -v $c >/dev/null
                    set -a missing_cmds $c
                end
            end
            if test (count $missing_cmds) -gt 0
                echo "Error: '$missing_cmds' command(s) not found. Please install rar/unrar (try: brew install rar unrar)."
                return 1
            end
        case zip
            set --local cmd zip unzip
            set --local missing_cmds
            for c in $cmd
                if not command -v $c >/dev/null
                    set -a missing_cmds $c
                end
            end
            if test (count $missing_cmds) -gt 0
                echo "Error: '$missing_cmds' command(s) not found. Please install zip/unzip."
                return 1
            end
        case 7z
            set --local cmd 7z
            if not command -v $cmd >/dev/null
                echo "Error: '$cmd' command not found. Please install p7zip (try: brew install p7zip)."
                return 1
            end
        case gz_single
            set --local cmd gunzip
            if not command -v $cmd >/dev/null
                echo "Error: '$cmd' command not found. Please install gzip."
                return 1
            end
        case '*'
            echo "Error: Unknown format '$format' for command checking."
            return 1
    end
    return 0
end
