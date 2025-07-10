function archive --description "Create bundled and compressed archives from directories"
  if test (count $argv) -ne 2
    echo "Usage: archive <directory> <output_file>"
    return 1
  end

  set --local source_dir $argv[1]
  set --local output_file $argv[2]

  if not test -d $source_dir
    echo "Error: '$source_dir' is not a directory"
    return 1
  end

  set --local ext (echo $output_file | awk -F. '{print $NF}')
  switch $ext
    case tar  # non-compressed, just bundled
      tar -cvf $output_file $source_dir
    case gz
      if test (echo $output_file | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        tar -czvf $output_file $source_dir
      else  # single gzip (compress directory as tar.gz)
        tar -czvf $output_file.tar.gz $source_dir
        echo "Note: Created $output_file.tar.gz instead (gzip requires tar for directories)"
      end
    case tgz  # same as tar.gz
      tar -czvf $output_file $source_dir
    case bz2  # tar compressed with bzip2
      tar -cjvf $output_file $source_dir
    case rar
      rar a $output_file $source_dir
    case zip
      zip -r $output_file $source_dir
    case '*'
      echo "Unknown extension '$ext'. Supported formats: tar, tar.gz, tgz, tar.bz2, rar, zip"
      return 1
  end
end
