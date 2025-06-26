# Configure Python and Ruby to use Homebrew dependencies
# Prerequisites: brew install openssl@3 readline sqlite3 zlib gettext tcl-tk libb2

# Function to switch between standard and optimized Python builds
function python_build_mode
    set -l mode_file "$HOME/.python_build_mode"

    if not test -f "$mode_file"; or test "$argv[1]" != (cat "$mode_file")
        if test "$argv[1]" = "optimized"
            set -l BREW_LIBB2 "$BREW_PREFIX/opt/libb2"
            set -gx LDFLAGS "$LDFLAGS -L$BREW_LIBB2/lib"
            set -gx CPPFLAGS "$CPPFLAGS -I$BREW_LIBB2/include"
            set -gx PYTHON_CONFIGURE_OPTS "--enable-framework" "--with-openssl=$OPENSSL_ROOT_DIR" "--with-tcltk-includes=-I$BREW_TCLTK/include" "--with-tcltk-libs=-L$BREW_TCLTK/lib -ltcl8.6 -ltk8.6" "--with-readline=edit"
            set -gx PYTHON_CFLAGS "-march=native -mtune=native"

            test -f "$mode_file"; and echo "Switched to optimized Python build mode"
        else
            set -gx PYTHON_CONFIGURE_OPTS "--enable-framework" "--with-openssl=$OPENSSL_ROOT_DIR" "--with-tcltk-includes=-I$BREW_TCLTK/include" "--with-tcltk-libs=-L$BREW_TCLTK/lib -ltcl8.6 -ltk8.6" "--with-readline=homebrew"
            set -e PYTHON_CFLAGS

            test -f "$mode_file"; and echo "Switched to standard Python build mode"
        end

        echo "$argv[1]" > "$mode_file"
    end
end

if command -v brew &>/dev/null
    # Cache brew --prefix results
    set -l BREW_PREFIX (brew --prefix)
    set -l BREW_READLINE "$BREW_PREFIX/opt/readline"
    set -l BREW_OPENSSL "$BREW_PREFIX/opt/openssl@3"
    set -l BREW_SQLITE "$BREW_PREFIX/opt/sqlite"
    set -l BREW_ZLIB "$BREW_PREFIX/opt/zlib"
    set -l BREW_GETTEXT "$BREW_PREFIX/opt/gettext"
    set -l BREW_TCLTK "$BREW_PREFIX/opt/tcl-tk"

    # Common flags for both standard and optimized builds
    set -gx LDFLAGS "-L$BREW_READLINE/lib -L$BREW_OPENSSL/lib -L$BREW_SQLITE/lib -L$BREW_ZLIB/lib -L$BREW_GETTEXT/lib"
    set -gx CPPFLAGS "-I$BREW_READLINE/include -I$BREW_OPENSSL/include -I$BREW_SQLITE/include -I$BREW_ZLIB/include -I$BREW_GETTEXT/include"
    set -gx PKG_CONFIG_PATH "$BREW_READLINE/lib/pkgconfig:$BREW_OPENSSL/lib/pkgconfig:$BREW_SQLITE/lib/pkgconfig:$BREW_ZLIB/lib/pkgconfig:$BREW_GETTEXT/lib/pkgconfig"

    set -gx OPENSSL_ROOT_DIR (brew --prefix openssl@3)
    set -gx LDFLAGS "-L$OPENSSL_ROOT_DIR/lib $LDFLAGS"
    set -gx CPPFLAGS "-I$OPENSSL_ROOT_DIR/include $CPPFLAGS"
    set -gx PKG_CONFIG_PATH "$OPENSSL_ROOT_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

    # Default to standard build mode if not set
    if not test -f "$HOME/.python_build_mode"
        python_build_mode standard
    else
        python_build_mode (cat "$HOME/.python_build_mode")
    end

    # Ruby configuration
    set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$BREW_OPENSSL"
end
