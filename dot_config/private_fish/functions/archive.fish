function archive --description "Create bundled and compressed archives from directories"
    if test (count $argv) -ne 2
        echo "Usage: archive <directory> <extension>"
        echo "Example: archive my_folder zip"
        echo "Supported extensions: tar, gz, tgz, bz2, rar, zip, 7z"
        return
    end

    set --local source_dir $argv[]
    set --local ext $argv[2]

    if not test -d $source_dir
        echo "Error: '$source_dir' is not a directory"
        return
    end

    # Check for required commands early
    _check_archiver $ext; or return

    # Generate output filename and create archive
    switch $ext
        case tar
            set --local output_file "$source_dir.tar"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            tar -cvf $output_file $source_dir
        case gz
            set --local output_file "$source_dir.tar.gz"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            tar -czvf $output_file $source_dir
        case tgz
            set --local output_file "$source_dir.tgz"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            tar -czvf $output_file $source_dir
        case bz2
            set --local output_file "$source_dir.tar.bz2"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            tar -cjvf $output_file $source_dir
        case rar
            set --local output_file "$source_dir.rar"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            rar a $output_file $source_dir
        case zip
            set --local output_file "$source_dir.zip"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            zip -r $output_file $source_dir
        case 7z
            set --local output_file "$source_dir.7z"
            if test -e $output_file
                echo "Error: '$output_file' already exists"
                return
            end
            7z a $output_file $source_dir
        case '*'
            echo "Unknown extension '$ext'. Supported formats: tar, gz, tgz, bz2, rar, zip, 7z"
            return
    end

    echo "Created: $output_file"
end
