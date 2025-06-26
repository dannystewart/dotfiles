function cat --description 'Smart cat with bat or fallback'
    if command -q bat
        bat -p $argv
    else
        command cat $argv
    end
end
