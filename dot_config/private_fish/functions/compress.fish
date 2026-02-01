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

    # Find an available filename in current directory
    set --local output "$basename$extension"
    set --local counter 1
    while test -e $output
        set output "$basename.$counter$extension"
        set counter (math $counter + 1)
    end

    # Convert to absolute path for the output file
    set --local output_abs (pwd)/$output

    # Perform compression
    # For directories, compress contents without nesting the folder name
    # For files, compress the file directly
    if test -d $target
        # Directory: cd into it and compress contents
        switch $format
            case tar
                tar -cvf $output_abs -C $target .
            case tar.gz gz
                tar -zcvf $output_abs -C $target .
            case tgz
                tar -zcvf $output_abs -C $target .
            case tar.bz2 bz2
                tar -jcvf $output_abs -C $target .
            case zip
                pushd $target; and zip -r $output_abs .; and popd
            case 7z
                pushd $target; and 7z a $output_abs .; and popd
        end
    else
        # File: compress directly
        switch $format
            case tar
                tar -cvf $output_abs $target
            case tar.gz gz
                tar -zcvf $output_abs $target
            case tgz
                tar -zcvf $output_abs $target
            case tar.bz2 bz2
                tar -jcvf $output_abs $target
            case zip
                zip $output_abs $target
            case 7z
                7z a $output_abs $target
        end
    end

    if test $status -eq 0
        info "Created: $output"
    end
end
