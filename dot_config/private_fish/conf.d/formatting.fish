# ANSI colors
set -g red '\033[0;31m'
set -g green '\033[0;32m'
set -g yellow '\033[0;33m'
set -g blue '\033[0;34m'
set -g cyan '\033[0;36m'
set -g bold '\033[1m'

# Clear formatting
set -g clear '\033[0m'

# Functions for color-coded status messages
function _print_colored --argument-names color
    argparse b/bold -- $argv
    set -l message (string join ' ' $argv[2..-1])

    if set -q _flag_bold
        echo -e "$color$bold$message$clear"
    else
        echo -e "$color$message$clear"
    end
end

function success
    _print_colored $green $argv
end

function error
    _print_colored $red $argv
end

function warning
    _print_colored $yellow $argv
end

function info
    _print_colored $blue $argv
end

# Pluralize
function pluralize --argument-names count word
    # Handle zero/negative counts
    if test $count -lt 0
        set count (math "abs($count)")
    end

    set -l result_word
    if test $count -eq 1
        set result_word $word
    else
        if string match -q "*y" $word; and not string match -q "*[aeiou]y" $word
            # city → cities, but boy → boys
            set result_word (string replace -r 'y$' 'ies' $word)
        else if string match -q "*[sxz]" $word; or string match -q "*[cs]h" $word
            # class → classes, box → boxes, buzz → buzzes, church → churches
            set result_word "$word"es
        else if string match -q "*[^aeiou]o" $word
            # potato → potatoes, but radio → radios
            set result_word "$word"es
        else if string match -q "*f" $word
            # leaf → leaves
            set result_word (string replace -r 'f$' 'ves' $word)
        else if string match -q "*fe" $word
            # knife → knives
            set result_word (string replace -r 'fe$' 'ves' $word)
        else
            # Default: add 's'
            set result_word "$word"s
        end
    end

    echo "$count $result_word"
end

# Format duration
function format_duration --argument-names total_seconds
    set -l minutes (math --scale=0 "$total_seconds / 60")
    set -l seconds (math "$total_seconds % 60")

    if test $minutes -eq 0
        echo (pluralize $seconds second)
    else if test $seconds -eq 0
        echo (pluralize $minutes minute)
    else
        echo (pluralize $minutes minute)" and "(pluralize $seconds second)
    end
end
