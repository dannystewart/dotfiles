function duds --description 'Display disk usage sorted by size'
    du -d 1 -h $argv | sort -hr
end
