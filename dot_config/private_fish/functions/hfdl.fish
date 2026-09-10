function hfdl
    if test (count $argv) -eq 0
        echo "Usage: hfdl owner/model-name"
        return 1
    end

    set model_id $argv[1]
    set model_name (string split "/" $model_id)[-1]
    set base_url "https://huggingface.co/$model_id/resolve/main"
    set token_file "$HOME/.cache/huggingface/token"
    set start_dir (pwd)

    if not test -d $model_name
        echo "→ Cloning repo structure for $model_id..."
        GIT_LFS_SKIP_SMUDGE=1 git clone "https://huggingface.co/$model_id" $model_name
        if test $status -ne 0
            echo "✗ Clone failed"
            return 1
        end
    else
        echo "→ Directory $model_name already exists, skipping clone..."
    end

    cd $model_name
    if test $status -ne 0
        echo "✗ Failed to cd into $model_name"
        return 1
    end

    echo "→ Building file list..."
    git lfs ls-files -n | while read -l file
        echo "$base_url/$file"
        echo "  out=$file"
    end > files.txt

    echo "→ Creating subdirectories..."
    git lfs ls-files -n | while read -l file
        set dir (path dirname $file)
        if test $dir != "."
            mkdir -p $dir
        end
    end

    echo "→ Removing LFS pointer placeholders..."
    git lfs ls-files -n | while read -l file
        if test -f $file && test (wc -c < $file) -lt 200
            rm $file
        end
    end

    set aria_args -j 4 -i files.txt --file-allocation=none --continue=true

    if test -f $token_file
        echo "→ Using HuggingFace auth token..."
        set aria_args $aria_args --header="Authorization: Bearer "(cat $token_file)
    end

    echo "→ Downloading..."
    aria2c $aria_args
    if test $status -ne 0
        echo "✗ Download failed or incomplete, skipping verification"
        cd $start_dir
        return 1
    end

    echo "→ Verifying hashes..."
    git lfs ls-files -l | while read -l oid dash filename
        echo "$oid  $filename" > "$filename.sha256"
    end
    set cpu_count (sysctl -n hw.logicalcpu)
    find . -name "*.sha256" | sort | parallel -j $cpu_count "sha256sum -c {} 2>&1" | tee sha256sum.log

    echo ""
    echo "Results:"
    sort sha256sum.log | nl

    set failures (grep -v ': OK$' sha256sum.log | wc -l | string trim)
    if test "$failures" -eq 0
        echo "✓ All files verified successfully!"
    else
        echo "✗ $failures file(s) failed verification — check sha256sum.log"
    end

    cd $start_dir
end
