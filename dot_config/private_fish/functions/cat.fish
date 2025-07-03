function cat --description "cat replacement wrapper using bat with smart fallback"
    if command -q bat
        command bat -p $argv
    else
        command cat $argv
    end
end
