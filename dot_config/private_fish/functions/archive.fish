function archive --description "Create bundled and compressed archives from directories"
    if test (count $argv) -ne 2
        info "Usage: archive <directory> <extension>"
        info "Example: archive my_folder zip"
        info "Supported extensions: tar, gz, tgz, bz2, rar, zip, 7z"
        return
    end

    set --local source_dir (string trim -r -c '/' $argv[1]) # Remove trailing slash
    set --local ext $argv[2]

    if not test -d $source_dir
        error "Error: '$source_dir' is not a directory"
        return 1
    end

    # Check for required commands early
    _check_archiver $ext; or return

    # Generate output filename based on extension
    set --local output_file
    if test $ext = gz
        set output_file "$source_dir.tar.gz"
    else if test $ext = bz2
        set output_file "$source_dir.tar.bz2"
    else if contains $ext tar tgz rar zip 7z
        set output_file "$source_dir.$ext"
    else
        error "Unknown extension '$ext'. Supported formats: tar, gz, tgz, bz2, rar, zip, 7z"
        return
    end

    # Check if output file already exists
    if test -e $output_file
        error "Error: '$output_file' already exists"
        return
    end

    # Create archive
    switch $ext
        case tar
            tar -cvf $output_file $source_dir
        case gz tgz
            tar -czvf $output_file $source_dir
        case bz2
            tar -cjvf $output_file $source_dir
        case rar
            rar a $output_file $source_dir
        case zip
            zip -r $output_file $source_dir
        case 7z
            7z a $output_file $source_dir
    end

    success "Created: $output_file"
end
