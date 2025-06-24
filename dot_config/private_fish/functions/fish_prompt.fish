function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l usercolor (set_color $fish_color_user)

    # Git prompt
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_use_informative_chars 1
    string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL
    and set -g __fish_git_prompt_char_dirtystate \U1F4a9
    set -g __fish_git_prompt_char_untrackedfiles " ?"
    set -g __fish_git_prompt_char_cleanstate " ✓"

    set -l vcs (fish_vcs_prompt '%s' 2>/dev/null)

    # OS icon
    set -l os_icon
    switch (uname)
        case Darwin
            set os_icon \uF179 # Apple logo
        case Linux
            set os_icon \uF17C # Linux penguin
        case '*'
            set os_icon \uF109 # Generic computer
    end

    # Delimiter
    set -l delim \u276F
    string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL; or set delim ">"
    fish_is_root_user; and set delim "#"

    # Desaturated colors
    set -l cwd (set_color $fish_color_cwd)
    if command -sq cksum
        set -l shas (pwd -P | cksum | string split -f1 ' ' | math --base=hex | string sub -s 3 | string pad -c 0 -w 6 | string match -ra ..)
        set -l col 0x$shas[1..3]

        # Desaturation magic: reduce the intensity by mixing with gray
        set col[1] (math --base=hex "($col[1] + 128) / 2") # Mix with 128 (mid-gray)
        set col[2] (math --base=hex "($col[2] + 128) / 2")
        set col[3] (math --base=hex "($col[3] + 128) / 2")

        # Still ensure readability
        while test (math 0.2126 x $col[1] + 0.7152 x $col[2] + 0.0722 x $col[3]) -lt 120
            set col[1] (math --base=hex "min(255, $col[1] + 30)")
            set col[2] (math --base=hex "min(255, $col[2] + 30)")
            set col[3] (math --base=hex "min(255, $col[3] + 30)")
        end

        set -l col (string replace 0x '' $col | string pad -c 0 -w 2 | string join "")
        set cwd (set_color $col)
    end

    # Prompt host
    if not set -q prompt_host
        set -g prompt_host ""
        if set -q SSH_TTY
            or begin
                command -sq systemd-detect-virt
                and systemd-detect-virt -q
            end
            set prompt_host $usercolor$USER$normal@(set_color $fish_color_host)$hostname$normal":"
        end
    end

    # Prompt pwd
    set -l pwd (prompt_pwd)

    # Prompt status
    set -l prompt_status
    test $last_status -ne 0; and set prompt_status (set_color $fish_color_status)"[$last_status]$normal"

    # Time display for the first line
    set -l time_display (set_color brgrey)\uF017" "(date "+%I:%M:%S %p")(set_color normal)

    # Build the actual left side content to measure accurately
    set -l git_info (fish_vcs_prompt '%s' 2>/dev/null)
    set -l left_content "$os_icon $prompt_host$pwd $git_info "

    # Strip all color codes and measure the actual visible length
    set -l left_visible (string replace -ra '\e\[[0-9;]*[mK]' '' $left_content)
    set -l time_visible (string replace -ra '\e\[[0-9;]*[mK]' '' $time_display)

    set -l terminal_width $COLUMNS

    set -l left_length (string length $left_visible)
    set -l time_length (string length $time_visible)

    # Account for Unicode clock icon taking 2 visual columns instead of 1
    set time_length (math $time_length + 1)

    # Add a few extra spaces to push time closer to the right edge
    set -l spaces_needed (math max 0, $terminal_width - $left_length - $time_length + 4)
    set -l spacing (string repeat -n $spaces_needed " ")

    # OS icon + path + spacing + time (first line)
    echo -s $os_icon " " $prompt_host $cwd $pwd $normal " " $git_info " " $spacing $time_display

    # Status + delimiter + space (second line)
    echo -n -s $prompt_status (set_color 00da00) $delim $normal " "
end
