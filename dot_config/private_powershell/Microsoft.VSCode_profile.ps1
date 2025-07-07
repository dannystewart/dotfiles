# Set timezone and environment variables
$env:TZ = "America/New_York"
$env:EZA_CONFIG_DIR = "$HOME/.config/eza"
$env:LESSHISTFILE = "/dev/null"
$env:HOMEBREW_NO_ENV_HINTS = "true"

# ls replacement wrapper using eza if available
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza --no-quotes --time-style='+%Y.%m.%d %I:%M %p' --icons @args }
}

# Chezmoi functions
function czu { chezmoi update }
function cza { chezmoi apply }

# ls functions
function l { ls -1 --group-directories-first @args }
function ll { ls -l --no-user --group-directories-first @args }
function lt { ls --tree --level=1 --group-directories-first @args }
function la { ls -la --no-user --group-directories-first @args }
function lz { ls -la --no-user --total-size -rs size @args }
function lv { ls -lga --git --group-directories-first @args }
function lvz { ls -lga --git --total-size -rs size @args }

# Initialize oh-my-posh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config ~/.config/powershell/powerlevel10k.json | Invoke-Expression
}
