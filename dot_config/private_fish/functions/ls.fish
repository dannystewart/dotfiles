function ls --description="ls replacement wrapper using exa with smart fallback"
    if command -v eza &>/dev/null
        command eza --no-quotes --time-style='+%Y.%m.%d %I:%M %p' --group-directories-first --icons $argv
    else
        command ls --color=auto $argv
    end
end
