# Clear and rebuild PATH
set -e fish_user_paths # Clear user paths
set -g fish_user_paths # Reset to empty

# Add paths in reverse order (fish prepends)
set possible_paths \
    /opt/homebrew/opt/openjdk/bin \
    /opt/homebrew/opt/findutils/libexec/gnubin \
    /usr/local/opt/findutils/libexec/gnubin \
    /var/lib/snapd/snap/bin \
    ~/.lmstudio/bin \
    ~/.cargo/bin \
    ~/.rbenv/bin \
    ~/.pyenv/shims \
    ~/.pyenv/bin \
    ~/bin \
    ~/.bin \
    ~/.local/bin \
    ~/.local/bin/node \
    /usr/local/bin \
    /usr/libexec \
    /Library/Apple/usr/bin \
    /System/Cryptexes/App/usr/bin \
    /sbin \
    /opt/local/bin

for path in $possible_paths
    if test -d $path
        fish_add_path $path
    end
end
