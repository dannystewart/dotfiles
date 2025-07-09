# Set timezone and environment variables
$env:TZ = "America/New_York"
$env:EZA_CONFIG_DIR = "$HOME/.config/eza"
$env:LESSHISTFILE = "/dev/null"
$env:HOMEBREW_NO_ENV_HINTS = "true"

# ls replacement wrapper using eza if available
function ls {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        eza --no-quotes --group-directories-first --icons @args
    }
    else {
        Get-ChildItem @args
    }
}

# Chezmoi functions
function czu { chezmoi update }
function cza { chezmoi apply }

# ls functions
function l { ls -1 @args }
function ll { ls -l --no-user @args }
function lt { ls --tree --level=1 @args }
function la { ls -la --no-user @args }
function lz { ls -la --no-user --total-size -rs size @args }
function lv { ls -lga --git @args }
function lvz { ls -lga --git --total-size -rs size @args }

# Initialize starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
