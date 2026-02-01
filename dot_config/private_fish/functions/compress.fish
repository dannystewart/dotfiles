function compress --description "Compress or bundle files and directories"
    if test (count $argv) -lt 2
        info "Usage: compress <format> <target>"
        info "Supported formats: tar, tar.gz, tgz, tar.bz2, zip, 7z"
        info "Example: compress zip folder → folder.zip"
        return 1
    end

    set --local format $argv[1]
    set --local target $argv[2]

    if not test -e $target
        error "Error: '$target' does not exist"
        return 1
    end

    # Check for required commands early
    _check_archiver $format; or return 1

    # Generate output filename
    set --local basename (basename $target)
    set --local extension

    # Determine the file extension
    switch $format
        case tar
            set extension ".tar"
        case tar.gz gz
            set extension ".tar.gz"
        case tgz
            set extension ".tgz"
        case tar.bz2 bz2
            set extension ".tar.bz2"
        case zip
            set extension ".zip"
        case 7z
            set extension ".7z"
        case '*'
            error "Unknown format '$format'. Supported formats: tar, tar.gz, tgz, tar.bz2, zip, 7z"
            return 1
    end

    # Find an available filename
    set --local output "$basename$extension"
    set --local counter 1
    while test -e $output
        set output "$basename.$counter$extension"
        set counter (math $counter + 1)
    end

    # Perform compression
    switch $format
        case tar
            tar -cvf $output $target
        case tar.gz gz
            tar -zcvf $output $target
        case tgz
            tar -zcvf $output $target
        case tar.bz2 bz2
            tar -jcvf $output $target
        case zip
            zip -r $output $target
        case 7z
            # @fish-lsp-disable-next-line 7001
            7z a $output $target
    end

    if test $status -eq 0
        info "Created: $output"
    end
end
