# Bijan Sondossi
# Hombrew config file.

# Check for Homebrew
if ! [ -e $HOME/.brew ] && ! ( command -v brew )
then
    if kv-y-n-or-s "install-brew" "Clone homebrew from GitHub?"
    then
        git clone https://github.com/Homebrew/brew.git ~/.brew
    else
        echo "ERROR: Homebrew must be installed." >&2
        return
    fi
fi

# Variables ------------------------------------------------------------

# export HOMEBREW_NO_ANALYTICS=1
export PATH=$HOME/.brew/bin:$PATH
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"

# API tokens and stuff
if [ -f $SH_CONFIG_DIR/tmp/homebrew-vars.bash ]
then
    source $SH_CONFIG_DIR/tmp/homebrew-vars.bash
fi

# Packages with setup --------------------------------------------------

# Bash Git Prompt
if kv-y-n-or-s "install-brew-bgp" "Install bash-git-prompt?"
then
    BGP_PREFIX=$(brew --prefix bash-git-prompt)/share
    if ! [ -f $BGP_PREFIX/gitprompt.sh ]
    then
        brew install bash-git-prompt
    fi

    MY_BGP_THEME="$SH_ROOT_DIR/misc/bgp/my-theme.bgptheme"
    if kv-y-n-or-s "use-my-bgp-theme" "Use my-theme?"
    then
        if ! [ -f $BGP_PREFIX/themes/my-theme.bgptheme ]
        then
            cp $MY_BGP_THEME $BGP_PREFIX/themes
        fi
        if [ -f $BGP_PREFIX/gitprompt.sh ]
        then
            GIT_PROMPT_ONLY_IN_REPO=1
            GIT_PROMPT_THEME=my-theme
            source $BGP_PREFIX/gitprompt.sh
        fi
    fi
fi

# CCat
if kv-y-n-or-s "install-brew-ccat" "Install ccat?"
then
   if ! [ -e $(brew --prefix ccat) ]
   then
       brew install ccat
   fi

   if [ -x $(brew --prefix ccat)/bin/ccat ]
   then
       alias cat='ccat --bg=dark'
   fi
fi

# Formulas with no config ----------------------------------------------

# Only want to run this once so we set brew-installer-ran to yes no
#  matter what. Use kvclear or kvdel to remove brew-installer-ran from
#  the db and rerun the installer on the next login
if ! kv-exists "brew-installer-ran"
then
    if [ -f $SH_MISC_DIR/brew/default-formulas.txt ]
    then
        if kv-y-or-n \
               "install-brew-formulas" \
               "Install additional formulas?"
        then
            for f in $(cat $SH_MISC_DIR/brew/default-formulas.txt)
            do
                if kv-y-or-n "install-brew-$f" "Install $f?"
                then
                    if ! [ -e $(brew --prefix $f) ]
                    then
                        brew install "$f"
                    fi
                fi
            done
        fi
    fi
    kvset brew-installer-ran yes
fi

# Casks
if ! kv-exists "cask-installer-ran"
then
    if ! brew tap | grep "caskroom/cask" &> /dev/null
    then
        brew tap caskroom/cask
    fi

    if [ -f $SH_MISC_DIR/brew/default-casks.txt ]
    then
        if kv-y-or-n "install-casks" "Install casks?"
        then
            for cask in $(cat $SH_MISC_DIR/brew/default-casks.txt)
            do
                if kv-y-or-n "install-cask-$cask" "Install $cask?"
                then
                    if ! ( brew cask list | grep "$cask" &> /dev/null )
                    then
                        brew cask install "$cask"
                    fi
                fi
            done
        fi
    fi
    kvset cask-installer-ran yes
fi
