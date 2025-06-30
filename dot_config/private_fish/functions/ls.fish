function ls --description="ls replacement wrapper using exa with smart fallback"
    if command -v eza &>/dev/null
        command eza --no-quotes --time-style='+%Y.%m.%d %I:%M %p' --icons $argv
    else
        command ls --color=auto $argv
    end
end

# ls command abbreviations
abbr -a l ls -1
abbr -a ll ls -l --no-user
abbr -a lf ls -1 --group-directories-first # directories first
abbr -a lt ls --tree --level=1 # tree view
abbr -a la ls -la --no-user # same as above, just with hidden files
abbr -a laf ls -la --no-user --group-directories-first # directories first
abbr -a lz ls -l --no-user --total-size -rs size # with folder sizes, sorted by size
abbr -a lv ls -lga --git # verbose (includes user, group, and git status)
abbr -a lvf ls -lga --git --group-directories-first # verbose with directories first
abbr -a lvz ls -lga --git --total-size -rs size # with folder sizes, sorted by size
