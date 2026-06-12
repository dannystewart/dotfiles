# Clear and rebuild PATH
set -e fish_user_paths # Clear user paths
set -g fish_user_paths # Reset to empty

# Add paths in reverse order (fish prepends)
set possible_paths \
    /Applications/Obsidian.app/Contents/MacOS \
    /opt/homebrew/opt/openjdk/bin \
    /opt/homebrew/opt/findutils/libexec/gnubin \
    /usr/local/bin \
    /var/lib/snapd/snap/bin \
    ~/.lmstudio/bin \
    ~/.omlx/bin \
    ~/.rbenv/bin \
    ~/.npm-global/bin \
    ~/.cargo/bin \
    ~/.bun/bin \
    ~/.volta/bin \
    ~/.vite-plus/bin \
    ~/Library/pnpm \
    ~/.pyenv/shims \
    ~/.pyenv/bin \
    ~/.mint/bin \
    ~/bin \
    ~/.bin \
    ~/.local/bin \
    ~/.local/bin/node \
    /usr/libexec \
    /Library/Apple/usr/bin \
    /System/Cryptexes/App/usr/bin \
    /sbin \
    /opt/local/bin \
    /opt/homebrew/sbin \
    /opt/homebrew/bin

for path in $possible_paths
    if test -d $path
        fish_add_path $path
    end
end
