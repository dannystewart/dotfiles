function archive --description "Create bundled and compressed archives from directories"
    if test (count $argv) -ne 2
        echo "Usage: archive <directory> <extension>"
        echo "Example: archive my_folder zip"
        echo "Supported extensions: tar, gz, tgz, bz2, rar, zip, 7z"
        return
    end

    set --local source_dir (string trim -r -c '/' $argv[1]) # Remove trailing slash
    set --local ext $argv[2]

    if not test -d $source_dir
        echo "Error: '$source_dir' is not a directory"
        return 1
    end

    # Check for required commands early
    _check_archiver $ext; or return

    # Generate output filename
    set --local output_file
    switch $ext
        case tar
            set output_file "$source_dir.tar"
        case gz
            set output_file "$source_dir.tar.gz"
        case tgz
            set output_file "$source_dir.tgz"
        case bz2
            set output_file "$source_dir.tar.bz2"
        case rar
            set output_file "$source_dir.rar"
        case zip
            set output_file "$source_dir.zip"
        case 7z
            set output_file "$source_dir.7z"
        case '*'
            echo "Unknown extension '$ext'. Supported formats: tar, gz, tgz, bz2, rar, zip, 7z"
            return
    end

    # Check if output file already exists
    if test -e $output_file
        echo "Error: '$output_file' already exists"
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

    echo "Created: $output_file"
end
