function archive --description "Create bundled and compressed archives from directories"
    if test (count $argv) -ne 2
        echo "Usage: archive <directory> <extension>"
        echo "Example: archive my_folder zip"
        echo "Supported extensions: tar, gz, tgz, bz2, rar, zip"
        return 1
    end

    set --local source_dir $argv[1]
    set --local ext $argv[2]

    if not test -d $source_dir
        echo "Error: '$source_dir' is not a directory"
        return 1
    end

    # Generate output filename based on extension
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
        case '*'
            echo "Unknown extension '$ext'. Supported formats: tar, gz, tgz, bz2, rar, zip"
            return 1
    end

    # Check if output file already exists
    if test -e $output_file
        echo "Error: '$output_file' already exists"
        return 1
    end

    # Check for required commands and create archive
    switch $ext
        case tar
            if not command -v tar >/dev/null
                echo "Error: 'tar' command not found. Please install tar."
                return 1
            end
            tar -cvf $output_file $source_dir
        case gz tgz
            if not command -v tar >/dev/null
                echo "Error: 'tar' command not found. Please install tar."
                return 1
            end
            tar -czvf $output_file $source_dir
        case bz2
            if not command -v tar >/dev/null
                echo "Error: 'tar' command not found. Please install tar."
                return 1
            end
            tar -cjvf $output_file $source_dir
        case rar
            if not command -v rar >/dev/null
                echo "Error: 'rar' command not found. Please install rar (try: brew install rar)."
                return 1
            end
            rar a $output_file $source_dir
        case zip
            if not command -v zip >/dev/null
                echo "Error: 'zip' command not found. Please install zip."
                return 1
            end
            zip -r $output_file $source_dir
    end

    echo "Created: $output_file"
end
