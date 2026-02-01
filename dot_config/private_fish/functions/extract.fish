function extract --description "Expand or extract bundled and compressed files"
    if test (count $argv) -eq 0
        info "Usage: extract <archive_file>"
        info "Supported formats: tar, tar.gz, tgz, tar.bz2, rar, zip, 7z"
        return 1
    end

    if not test -f $argv[1]
        error "Error: '$argv[1]' is not a file or does not exist"
        return 1
    end

    set --local ext (echo $argv[1] | awk -F. '{print $NF}')
    set --local archive_path $argv[1]

    # Check for required commands early
    set --local check_format $ext
    if test $ext = gz -a (echo $archive_path | awk -F. '{print $(NF-1)}') != tar
        set check_format gz_single
    end
    _check_archiver $check_format; or return 1

    # Determine extraction directory name (strip extensions)
    set --local basename (basename $archive_path)
    set --local extract_dir

    # Remove known extensions to get the folder name
    if string match -qr '\.tar\.gz$' $basename
        set extract_dir (string replace -r '\.tar\.gz$' '' $basename)
    else if string match -qr '\.tar\.bz2$' $basename
        set extract_dir (string replace -r '\.tar\.bz2$' '' $basename)
    else
        set extract_dir (string replace -r '\.[^.]+$' '' $basename)
    end

    # Create extraction directory
    set --local counter 1
    set --local target_dir $extract_dir
    while test -e $target_dir
        set target_dir "$extract_dir.$counter"
        set counter (math $counter + 1)
    end
    mkdir -p $target_dir

    # Convert to absolute path
    set --local abs_archive (realpath $archive_path)

    # Extract into the directory
    switch $ext
        case tar
            tar -xvf $abs_archive -C $target_dir
        case gz
            if test (echo $archive_path | awk -F. '{print $(NF-1)}') = tar
                tar -zxvf $abs_archive -C $target_dir
            else
                # Single gzip files are extracted in place, not into a directory
                gunzip $abs_archive
                return
            end
        case tgz
            tar -zxvf $abs_archive -C $target_dir
        case bz2
            tar -jxvf $abs_archive -C $target_dir
        case rar
            unrar x $abs_archive $target_dir/
        case zip
            unzip $abs_archive -d $target_dir
        case 7z
            # @fish-lsp-disable-next-line 7001
            7z x $abs_archive -o$target_dir
        case '*'
            error "Unknown extension '$ext'. Supported formats: tar, tar.gz, tgz, tar.bz2, rar, zip, 7z"
            rmdir $target_dir 2>/dev/null
            return 1
    end

    if test $status -eq 0
        info "Extracted to: $target_dir/"
    else
        rmdir $target_dir 2>/dev/null
    end
end
