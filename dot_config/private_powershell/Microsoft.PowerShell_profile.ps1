# Set timezone and environment variables
$env:TZ = "America/New_York"
$env:EZA_CONFIG_DIR = "$HOME/.config/eza"
$env:LESSHISTFILE = "/dev/null"
$env:HOMEBREW_NO_ENV_HINTS = "true"
$env:STARSHIP_CONFIG = "$HOME/.config/powershell/starship_pwsh.toml"

# Simple path additions
$pathsToAdd = @(
    "$HOME/.local/bin",
    "$HOME/.pyenv/bin"
)

foreach ($path in $pathsToAdd) {
    if ((Test-Path $path) -and ($env:PATH -notlike "*$path*")) {
        $env:PATH = "$path$([IO.Path]::PathSeparator)$env:PATH"
    }
}

# Initialize Homebrew
if (-not $env:HOMEBREW_PREFIX) {
    $brewPaths = @(
        "C:/Program Files/Homebrew/bin/brew.exe",
        "/usr/local/bin/brew",
        "/opt/homebrew/bin/brew",
        "/home/linuxbrew/.linuxbrew/bin/brew"
    )

    foreach ($brewPath in $brewPaths) {
        if (Test-Path $brewPath) {
            $brewDir = Split-Path $brewPath
            $brewPrefix = Split-Path $brewDir
            $env:HOMEBREW_PREFIX = $brewPrefix
            $env:PATH = "$brewDir$([IO.Path]::PathSeparator)$env:PATH"
            break
        }
    }
}
else {
    function bru { brew update; brew upgrade; brew cleanup }
}

# Initialize pyenv
if (Get-Command pyenv -ErrorAction SilentlyContinue) {
    $pyenvRoot = pyenv root
    if ($pyenvRoot -and (Test-Path $pyenvRoot)) {
        $env:PYENV_ROOT = $pyenvRoot

        # Add shims to PATH if not already there
        $shimsPath = Join-Path $pyenvRoot "shims"
        if ((Test-Path $shimsPath) -and ($env:PATH -notlike "*$shimsPath*")) {
            $env:PATH = "$shimsPath$([IO.Path]::PathSeparator)$env:PATH"
        }
    }
}

# cat replacement wrapper using bat if available
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat {
        bat -p @args
    }
}

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

# Git functions
function gs { git status @args }
function ga { git add -A @args }
function gc { git commit -m @args }
function gp { git push @args }
function gpf { git push --force @args }
function gsc { git stash clear @args }
function grhh { git reset --hard HEAD @args }
function gfp { git fetch; git pull @args }
function gac { git add -A; git commit -m @args }

# Initialize starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
