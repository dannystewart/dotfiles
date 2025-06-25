function dsinstall --description 'Install my packages from PyPI or GitHub'
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
