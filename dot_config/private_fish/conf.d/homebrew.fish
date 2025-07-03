# Skip if already loaded this session
set -q HOMEBREW_INITIALIZED; and return
set -gx HOMEBREW_INITIALIZED 1

# Initialize Homebrew
if not set -q HOMEBREW_PREFIX
    test -f /usr/local/bin/brew; and eval "$(/usr/local/bin/brew shellenv)"
    test -f /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"
    test -f /home/linuxbrew/.linuxbrew/bin/brew; and eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end
