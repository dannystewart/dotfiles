# Update pip packages
function pip
    if test "$argv[1]" = "update"
        printf "\033[0;36m==> \033[1;36mUpdating pip packages...\033[0m\n"
        # Get list of packages and update them
        set packages (command pip freeze | grep -v '@' | cut -d'=' -f1)
        command pip install -U pip $packages 2>&1 | \
            grep -v "Requirement already satisfied:" | \
            grep -v -E "dulwich|keyring"
        printf "\033[0;32m==> \033[1;32mUpdates complete!\033[0m\n"
    else
        command pip $argv
    end
end

# Install DS packages from PyPI or GitHub
function dsinstall
    set package $argv[1]
    if test -z "$package"
        set package "dsbin"
    end

    echo -e "$GREEN""Installing $package...$NC"
    pip uninstall -y "$package" 2>/dev/null

    echo -e "$GREEN""Attempting to install $package from PyPI...$NC"
    if pip install -U "$package" 2>/dev/null
        echo -e "$GREEN""$package installed successfully from PyPI$NC"
    else
        echo -e "$YELLOW""Package not found on PyPI, installing from GitHub...$NC"
        if pip install -U "git+ssh://git@github.com/dannystewart/$package.git"
            echo -e "$GREEN""$package installed successfully from GitHub$NC"
        else
            echo "Failed to install $package"
            return 1
        end
    end
end

# Alias to clean Python junk files
function pyclean
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".idea" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".tox" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".coverage" -exec rm -rf {} + 2>/dev/null
    and find . -type f -name ".coverage" -delete 2>/dev/null
    and find . -type f -name "*.pyc" -delete 2>/dev/null
    echo "Python cache and temporary files cleaned!"
end

# Function to uninstall and reinstall multiple packages with pip
function pip-reinstall
    if test (count $argv) -eq 0
        echo "Usage: pip-reinstall package_name [package_name2 ...]"
        return 1
    end

    # Uninstall all packages first
    for package_name in $argv
        echo "Uninstalling $package_name..."
        pip uninstall -y "$package_name"
    end

    # Then reinstall all packages
    for package_name in $argv
        echo "Reinstalling $package_name..."
        pip install "$package_name"
    end
end
