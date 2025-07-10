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

    # Check for required commands early
    set --local check_format $ext
    if test $ext = gz -a (echo $argv[1] | awk -F. '{print $(NF-1)}') != tar
        set check_format gz_single
    end
    _check_archiver $check_format; or return 1

    switch $ext
        case tar # non-compressed, just bundled
            tar -xvf $argv[1]
        case gz
            if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar # tar bundle compressed with gzip
                tar -zxvf $argv[1]
            else # single gzip
                gunzip $argv[1]
            end
        case tgz # same as tar.gz
            tar -zxvf $argv[1]
        case bz2 # tar compressed with bzip2
            tar -jxvf $argv[1]
        case rar
            unrar x $argv[1]
        case zip
            unzip $argv[1]
        case 7z
            7z x $argv[1]
        case '*'
            echo "Unknown extension '$ext'. Supported formats: tar, tar.gz, tgz, tar.bz2, rar, zip, 7z"
            return 1
    end
end
