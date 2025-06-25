function pip --description 'Enhanced pip with update and reinstall commands'
    switch "$argv[1]"
        case "update"
            printf "\033[0;36m==> \033[1;36mUpdating pip packages...\033[0m\n"
            # Get list of packages and update them
            set packages (command pip freeze | grep -v '@' | cut -d'=' -f1)
            command pip install -U pip $packages 2>&1 | \
                grep -v "Requirement already satisfied:" | \
                grep -v -E "dulwich|keyring"
            printf "\033[0;32m==> \033[1;32mUpdates complete!\033[0m\n"
        case "reinstall"
            set packages $argv[2..-1]  # Get all arguments except the first (reinstall)

            if test (count $packages) -eq 0
                echo "Usage: pip reinstall package_name [package_name2 ...]"
                return 1
            end

            # Uninstall all packages first
            for package_name in $packages
                echo "Uninstalling $package_name..."
                command pip uninstall -y "$package_name"
            end

            # Then reinstall all packages
            for package_name in $packages
                echo "Reinstalling $package_name..."
                command pip install "$package_name"
            end
        case '*'
            command pip $argv
    end
end
