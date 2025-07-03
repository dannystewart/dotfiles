# Skip if already loaded this session
set -q PYENV_INITIALIZED; and return
set -gx PYENV_INITIALIZED 1

# Initialize pyenv
set -l pyenv_cache ~/.cache/fish/pyenv_init
if not test -f $pyenv_cache; or test (which pyenv) -nt $pyenv_cache
    if command -v pyenv &>/dev/null
        mkdir -p (dirname $pyenv_cache)
        pyenv init - >$pyenv_cache
    end
end
test -f $pyenv_cache; and source $pyenv_cache
