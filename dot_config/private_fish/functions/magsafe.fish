function magsafe --description "Control MagSafe charging light color"
    if test (uname) != "Darwin"
        echo "Error: magsafe only works on macOS."
        return 1
    end

    set -l green '\033[0;32m'
    set -l yellow '\033[0;33m'
    set -l nc '\033[0m'
    set -l color $argv[1]

    if test "$color" = "green"
        sudo smc -k ACLC -w 03
        echo -e "MagSafe set to $green"green"$nc"
    else if test "$color" = "orange"
        sudo smc -k ACLC -w 04
        echo -e "MagSafe set to $yellow"orange"$nc"
    else
        sudo smc -k ACLC -w 00
        echo -e "MagSafe set to default behavior"
    end
end
