# Skip if already loaded this session
set -q HOMEBREW_INITIALIZED; and return
set -gx HOMEBREW_INITIALIZED 1

# Initialize Homebrew
if not set -q HOMEBREW_PREFIX
    if test -f /opt/homebrew/bin/brew
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else if test -f /usr/local/bin/brew
        eval "$(/usr/local/bin/brew shellenv)"
    else if test -f /home/linuxbrew/.linuxbrew/bin/brew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    end
end
