function extract --description "Expand or extract bundled and compressed files"
    if test (count $argv) -eq 0
        echo "Usage: extract <archive_file>"
        echo "Supported formats: tar, tar.gz, tgz, tar.bz2, rar, zip, 7z"
        return 1
    end

    if not test -f $argv[1]
        echo "Error: '$argv[1]' is not a file or does not exist"
        return 1
    end

    set --local ext (echo $argv[1] | awk -F. '{print $NF}')
    switch $ext
        case tar # non-compressed, just bundled
            if not command -v tar >/dev/null
                echo "Error: 'tar' command not found. Please install tar."
                return 1
            end
            tar -xvf $argv[1]
        case gz
            if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar # tar bundle compressed with gzip
                if not command -v tar >/dev/null
                    echo "Error: 'tar' command not found. Please install tar."
                    return 1
                end
                tar -zxvf $argv[1]
            else # single gzip
                if not command -v gunzip >/dev/null
                    echo "Error: 'gunzip' command not found. Please install gzip."
                    return 1
                end
                gunzip $argv[1]
            end
        case tgz # same as tar.gz
            if not command -v tar >/dev/null
                echo "Error: 'tar' command not found. Please install tar."
                return 1
            end
            tar -zxvf $argv[1]
        case bz2 # tar compressed with bzip2
            if not command -v tar >/dev/null
                echo "Error: 'tar' command not found. Please install tar."
                return 1
            end
            tar -jxvf $argv[1]
        case rar
            if not command -v unrar >/dev/null
                echo "Error: 'unrar' command not found. Please install unrar (try: brew install unrar)."
                return 1
            end
            unrar x $argv[1]
        case zip
            if not command -v unzip >/dev/null
                echo "Error: 'unzip' command not found. Please install unzip."
                return 1
            end
            unzip $argv[1]
        case 7z
            if not command -v 7z >/dev/null
                echo "Error: '7z' command not found. Please install p7zip (try: brew install p7zip)."
                return 1
            end
            7z x $argv[1]
        case '*'
            echo "Unknown extension '$ext'. Supported formats: tar, tar.gz, tgz, tar.bz2, rar, zip, 7z"
            return 1
    end
end
