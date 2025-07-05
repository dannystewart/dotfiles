# Tmux Complete Reference

- **Prefix key:** Ctrl-R (tmux default: Ctrl-B)
- Mouse mode can be toggled with Ctrl-R M.
  - ON: normal mouse behavior but bad text selection
  - OFF: normal text selection but no scrolling

## Sessions (Instances)

| Action              | Command                       |
|---------------------|-------------------------------|
| List sessions       | `tmux ls`                     |
| New session         | `tmux new -s [name]`          |
| Attach to last      | `tmux a`                      |
| Attach to specific  | `tmux a -t` [name]            |
| Kill session        | `tmux kill-session -t` [name] |
| Detach from session | Ctrl-R D                      |

## Session Management

| Action              | Key                               |
|---------------------|-----------------------------------|
| Command prompt      | Ctrl-R :                          |
| Reload config       | Ctrl-R Ctrl-R                     |
| Reload from Chezmoi | Ctrl-R Shift-R                    |
| Rename session      | Ctrl-R Ctrl-S                     |
| Session picker      | Ctrl-R  S                         |
| Previous window     | Alt+J                             |
| Next window         | Alt+K                             |
| Window numbering    | Ctrl-R `:movew -r` (as a command) |

## Windows (Tabs)

| Action           | Key                 |
|------------------|---------------------|
| New window       | Ctrl-R C            |
| Next window      | Ctrl-R N (or Alt+K) |
| Previous window  | Ctrl-R P (or Alt+J) |
| Switch to window | Ctrl-R [number]     |
| Rename window    | Ctrl-R R            |
| Kill window      | Ctrl-R &            |
| List windows     | Ctrl-R W            |

## Panes (Splits)

| Action                 | Key                |
|------------------------|--------------------|
| Split vertically       | Ctrl-R V           |
| Split horizontally     | Ctrl-R H           |
| Navigate panes         | Ctrl-R Arrows      |
| Resize panes           | Ctrl-R Ctrl-Arrows |
| Even vertical layout   | Ctrl-R Ctrl-H      |
| Even horizontal layout | Ctrl-R Ctrl-V      |
| Kill pane              | Ctrl-R X           |
| Break pane to window   | Ctrl-R Ctrl-J      |
| Join pane (prompted)   | Ctrl-R J           |
| Sync panes             | Ctrl-R Ctrl-\      |

## Copy Mode (for scrolling/searching)

| Action          | Prefix                |
|-----------------|-----------------------|
| Enter copy mode | Ctrl-R [              |
| Exit copy mode  | q (or Escape)         |
| Search up       | ?                     |
| Search down     | /                     |
| Page up/down    | Page Up (or Ctrl-B)   |
| Page up/down    | Page Down (or Ctrl-F) |
