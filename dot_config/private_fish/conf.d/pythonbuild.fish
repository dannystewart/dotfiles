# Configure Python and Ruby to use Homebrew dependencies
# Prerequisites: brew install openssl@3 readline sqlite3 zlib gettext tcl-tk libb2

# Set BREW_PREFIX based on the system
if test -f /opt/homebrew/bin/brew
    set -gx BREW_PREFIX /opt/homebrew
else if test -f /usr/local/bin/brew
    set -gx BREW_PREFIX /usr/local
else # No Homebrew, skip everything
    exit 0
end

# Set paths
set -gx OPENSSL_ROOT_DIR "$BREW_PREFIX/opt/openssl@3"
set -gx BREW_READLINE "$BREW_PREFIX/opt/readline"
set -gx BREW_SQLITE "$BREW_PREFIX/opt/sqlite"
set -gx BREW_ZLIB "$BREW_PREFIX/opt/zlib"
set -gx BREW_GETTEXT "$BREW_PREFIX/opt/gettext"
set -gx BREW_TCLTK "$BREW_PREFIX/opt/tcl-tk"

# Build flags
set -gx LDFLAGS "-L$BREW_READLINE/lib -L$OPENSSL_ROOT_DIR/lib -L$BREW_SQLITE/lib -L$BREW_ZLIB/lib -L$BREW_GETTEXT/lib -lintl"
set -gx CPPFLAGS "-I$BREW_READLINE/include -I$OPENSSL_ROOT_DIR/include -I$BREW_SQLITE/include -I$BREW_ZLIB/include -I$BREW_GETTEXT/include"
set -gx PKG_CONFIG_PATH "$BREW_READLINE/lib/pkgconfig:$OPENSSL_ROOT_DIR/lib/pkgconfig:$BREW_SQLITE/lib/pkgconfig:$BREW_ZLIB/lib/pkgconfig:$BREW_GETTEXT/lib/pkgconfig"

# Ruby configuration
set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$OPENSSL_ROOT_DIR"

function python_build_mode
    set -l mode_file "$HOME/.python_build_mode"
    set -l tcltk_libs_option "--with-tcltk-libs=-L$BREW_TCLTK/lib -ltcl8.6 -ltk8.6"

    if test "$argv[1]" = optimized
        set -gx LDFLAGS "$LDFLAGS -L$BREW_PREFIX/opt/libb2/lib"
        set -gx CPPFLAGS "$CPPFLAGS -I$BREW_PREFIX/opt/libb2/include"
        set -gx PYTHON_CONFIGURE_OPTS "--enable-framework --with-openssl=$OPENSSL_ROOT_DIR --with-tcltk-includes=-I$BREW_TCLTK/include '$tcltk_libs_option' --with-readline=edit"
        set -gx PYTHON_CFLAGS "-march=native -mtune=native"

        if not test -f "$mode_file"; or test "$argv[1]" != (cat "$mode_file" 2>/dev/null)
            echo "Switched to optimized Python build mode"
        end
    else
        set -gx PYTHON_CONFIGURE_OPTS "--enable-framework --with-openssl=$OPENSSL_ROOT_DIR --with-tcltk-includes=-I$BREW_TCLTK/include '$tcltk_libs_option' --with-readline=homebrew"
        set -e PYTHON_CFLAGS

        if not test -f "$mode_file"; or test "$argv[1]" != (cat "$mode_file" 2>/dev/null)
            echo "Switched to standard Python build mode"
        end
    end

    echo "$argv[1]" >"$mode_file"
end

# Initialize with saved mode or default to standard
set -l saved_mode
if test -f "$HOME/.python_build_mode"
    set saved_mode (cat "$HOME/.python_build_mode")
    python_build_mode $saved_mode
else
    python_build_mode standard
end
