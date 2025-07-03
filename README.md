# dotfiles

Welcome to my dotfiles repo, where I keep not just dotfiles but scripts and utilities I've written as well. These are maintained using [Chezmoi](https://www.chezmoi.io/). Most of the prefixes on files and folders indicate how Chezmoi should treat them. For example, `private_` means it should `chmod 600`, `executable_` means it should `chmod +x`, and so on. Check out Chezmoi's [user guide](https://www.chezmoi.io/user-guide/command-overview/) for more. I'm also using Chezmoi's [age encryption](https://www.chezmoi.io/user-guide/encryption/age/) for more sensitive files like SSH keys and environment variables.

## What's What

### Shell Stuff

- I tried to do shell stuff in a smart way by moving anything that wasn't shell-specific (i.e. Bash or Zsh) into [`.profile`](dot_profile) and then having [`.bashrc`](dot_bashrc), [`.bash_profile`](dot_bash_profile), and [`.zshrc`](dot_zshrc) all just `source` from that as much as possible while keeping only shell-specific stuff in each.
- [`dot_aliases`](dot_aliases) also contains all my shell aliases. Kind of overloaded, but lots of good stuff in there.

### Scripts and Utilities

- [`dot_local/bin/`](dot_local/bin): This is where I keep all my scripts and utilities, which I have in my `$PATH`.

Now that I'm a bona fide Python wizard, almost everything's been ported from Bash to Python, except some stuff in the `retired` folder which isn't currently under active use.

It's also worth noting that I have a script called [`lsbin`](dot_local/bin/executable_lsbin) whose purpose is literally to remind me what all my scripts are. It reads a docstring or comment at the beginning of each file to populate the list.

### Chezmoi Stuff

- `.tmpl` files are templates using Chezmoi's [templating](https://www.chezmoi.io/user-guide/templating/) syntax.
- [`.chezmoi.toml.tmpl`](.chezmoi.toml.tmpl): Chezmoi config.
- [`.chezmoiignore`](.chezmoiignore): Files for Chezmoi to disregard in here. Works like [`.gitignore`](.gitignore).
- [`run_once_before-decrypt-private-key.sh.tmpl`](run_once_before_decrypt-private-key.sh.tmpl): Decrypts encrypted stuff on first setup.
- [`run_once_install-packages.sh`](run_once_install-packages.sh): Handy script to install utilities I commonly use on first setup.

### Other Folders and Files of Interest

- [`dot_config/`](dot_config): General configuration files, including for [`youtube-dl`](dot_config/youtube-dl.conf) and [`yt-dlp`](dot_config/yt-dlp.conf), plus [`kitty`](https://sw.kovidgoyal.net/kitty/) terminal and `htop`
- [`.gitattributes`](.gitattributes): Helps define syntax for files with different/no extensions
- [`.tmux_cheat_sheet`](.tmux_cheat_sheet): Just a text file with hints and reminders about using `tmux`
- [`dot_gitconfig.tmpl`](dot_gitconfig.tmpl): Git configuration
- [`dot_hyper.js`](dot_hyper.js): Config for [Hyper](https://hyper.is/) terminal
- [`dot_p10k.zsh`](dot_p10k.zsh): Config for [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [`dot_tmux.conf`](dot_tmux.conf): Config for `tmux`
