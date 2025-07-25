# Fish shell completions for prismlens
# Copy this file to ~/.config/fish/completions/prismlens.fish

# Actions (first argument)
set -l actions start restart stop

# Instances (second argument, only valid after an action)
set -l instances prod dev all

# Complete actions as first argument
complete -c prismlens -n "not __fish_seen_subcommand_from $actions" -a "$actions" -d "action to perform"

# Complete 'dev' as standalone argument for logs
complete -c prismlens -n "test (count (commandline -opc)) -eq 1" -a "dev" -d "show dev logs"

# Complete instances as second argument after actions
complete -c prismlens -n "__fish_seen_subcommand_from $actions; and test (count (commandline -opc)) -eq 2" -a "$instances" -d "target instance"

# Specific descriptions for actions
complete -c prismlens -n "not __fish_seen_subcommand_from $actions" -a "start" -d "start Prism instance/s"
complete -c prismlens -n "not __fish_seen_subcommand_from $actions" -a "restart" -d "restart Prism instance/s"
complete -c prismlens -n "not __fish_seen_subcommand_from $actions" -a "stop" -d "stop Prism instance/s"

# Specific descriptions for instances
complete -c prismlens -n "__fish_seen_subcommand_from start restart stop; and test (count (commandline -opc)) -eq 2" -a "prod" -d "prod instance only"
complete -c prismlens -n "__fish_seen_subcommand_from start restart stop; and test (count (commandline -opc)) -eq 2" -a "dev" -d "dev instance only"
complete -c prismlens -n "__fish_seen_subcommand_from start restart stop; and test (count (commandline -opc)) -eq 2" -a "all" -d "full stack (prod + dev + services)"
