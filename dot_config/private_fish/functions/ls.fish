function ls --description="ls replacement wrapper using exa with smart fallback"
    if command -q eza
        command eza --no-quotes --time-style='+%Y.%m.%d %I:%M %p' $argv
    else
        command ls --color=auto $argv
    end
end
