function demurrify --description "Scrape Murray Gold off a folder of MKV files"
    # Determine working directory
    if test (count $argv) -eq 0
        # No argument - use current directory
        set workdir "."
    else if test -d $argv[1]
        # Argument is a directory
        set workdir $argv[1]
    else if test -f $argv[1]
        # Argument is a file - use its directory
        set workdir (dirname $argv[1])
        set single_file (basename $argv[1])
    else
        error "Invalid argument: $argv[1] is not a file or directory"
        return 1
    end

    # Change to working directory
    set original_dir (pwd)
    cd $workdir

    # Build file list
    if set -q single_file
        # Process single file
        set files $single_file
    else
        # Process all .mkv files
        set files *.mkv
    end

    # Check if any .mkv files exist
    if not test -e $files[1]
        error "No MKV files found in $workdir"
        cd $original_dir
        return 1
    end

    # Count total files for progress tracking
    set total (count $files)
    set current 0

    for file in $files
        # Skip files that are already processed
        if string match -q "*_original.mkv" $file
            info "Skipping already-processed file: $file"
            continue
        end

        set current (math $current + 1)
        set basename (string replace -r '\.mkv$' '' $file)

        # Check if original already exists
        if test -e "$basename"_original.mkv
            warning "Original already exists for $file - skipping to avoid overwrite"
            continue
        end

        # Check audio channel layout
        set channels (ffprobe -v error -select_streams a:0 -show_entries stream=channels -of default=noprint_wrappers=1:nokey=1 $file)

        # Skip if not 6 channel
        if test "$channels" != 6
            set layout (ffprobe -v error -select_streams a:0 -show_entries stream=channel_layout -of default=noprint_wrappers=1:nokey=1 $file)
            warning "[$current/$total] Skipping $file - not 5.1/6ch (detected: $channels channels, layout: $layout)"
            continue
        end

        info "[$current/$total] Processing: $file (5.1 audio detected)"

        # Rename original file
        if not mv $file "$basename"_original.mkv
            error "Failed to rename $file - skipping"
            continue
        end

        # Process with ffmpeg (show progress but hide banner)
        if ffmpeg -hide_banner -i "$basename"_original.mkv \
                -map 0:v:0 -map 0:a:0 -map 0:s? \
                -c:v copy -c:s copy \
                -af "pan=stereo|c0=FC|c1=FC" \
                -c:a aac -b:a 192k \
                -max_muxing_queue_size 1024 \
                $file
            success "✓ Completed: $file"
        else
            error "✗ Failed to process: $file"
            # Restore original filename on failure
            if not mv "$basename"_original.mkv $file
                error "CRITICAL: Failed to restore original filename! Check $basename"_original.mkv" manually"
            end
        end
        echo ""
    end

    # Return to original directory
    cd $original_dir

    success "All files processed! ($current/$total)"
end
