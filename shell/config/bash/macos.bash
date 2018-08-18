# Bijan Sondossi
# MacOS specific configurations.

# TODO:
# - Make this faster

# Variables ------------------------------------------------------------

USER_FONT_DIR="$HOME/Library/Fonts"

# Aliases --------------------------------------------------------------

alias imessage="osascript $SH_MISC_DIR/scripts/iMessage.scpt"

# Homebrew -------------------------------------------------------------

if kv-y-n-or-s "homebrew-config" "Run homebrew config?"
then
    if [ -f $SH_CONFIG_DIR/bash/brew.bash ]
    then
        source $SH_CONFIG_DIR/bash/brew.bash

        if kv-y-n-or-s "install-iosevka" "Install Iosevka font?"
        then
            if ! ( brew list | grep -q "iosevka" )
            then
                IOSEVKA_TAP="robertgzr/tap"
                IOSEVKA_DIR="$(brew --prefix iosevka)"
                IOSEVKA_ARGS="--with-asterisk-low"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-at-long"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-brace-straight"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-dollar-open"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-g-doublestorey"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-term"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-tilda-low"
                IOSEVKA_ARGS="$IOSEVKA_ARGS --with-zero-slashed"
                if ! ( brew tap | grep -q "$IOSEVKA_TAP" )
                then
                    brew tap $IOSEVKA_TAP
                fi
                if brew install iosevka "$IOSEVKA_ARGS"
                then
                    cp -rf $IOSEVKA_DIR/share/ $USER_FONT_DIR/iosevka
                fi
            fi
        fi

        # Up to date emacs
        if kv-y-n-or-s "install-brew-emacs" "Install emacs-plus?"
        then
            if ! [ -e "$(brew --prefix emacs-plus 2> /dev/null)" ]
            then
                if ! ( brew tap | grep -q "d12frosted/emacs-plus" )
                then
                    brew tap d12frosted/emacs-plus
                fi

                EMACS_OPTIONS="--without-spacemacs-icon"
                if ! y-or-n "Use titlebar?"
                then
                    EMACS_OPTIONS="$EMACS_OPTIONS --with-no-title-bars"
                fi
                brew install emacs-plus $EMACS_OPTIONS
            fi
            export PATH=$(brew --prefix emacs-plus)/bin:$PATH
        fi

        # Chunkwm
        if kv-y-n-or-s "install-chunkwm" "Install chunkwm?"
        then
            if ! [ -e "$(brew --prefix chunkwm 2> /dev/null)" ]
            then
                if ! brew tap | grep -q "crisidev/chunkwm"
                then
                    brew tap crisidev/chunkwm
                fi
                brew install chunkwm
                ln -s $SH_CONFIG_DIR/chunkwm/chunkwm.conf \
                   $HOME/.chunkwmrc
            fi
        fi

        # skhd
        if kv-y-n-or-s "install-skhd" "Install skhd?"
        then
            if ! [ -e "$(brew --prefix skhd 2> /dev/null)" ]
            then
                if ! brew tap | grep -q "koekeishiya/formulae"
                then
                    brew tap koekeishiya/formulae
                fi
                brew install skhd
                ln -s $SH_CONFIG_DIR/skhd/skhd.conf \
                   $HOME/.skhdrc
            fi
        fi

        # kitty
        if kv-y-n-or-s "install-kitty" "Install Kitty?"
        then
            if ! brew cask list | grep -iq "^kitty$"
            then
                brew cask install kitty

                MACOS_KITTY_DIR=~/Library/Preferences/kitty
                ! [ -e $MACOS_KITTY_DIR ] && mkdir -p $MACOS_KITTY_DIR
                ln -s $SH_CONFIG_DIR/kitty/kitty.conf $MACOS_KITTY_DIR
            fi
        fi
    else
        echo "Homebrew config file not found." >&2
    fi
fi
