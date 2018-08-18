# Bijan Sondossi

# Default configuration files ------------------------------------------

# Machine specific stuff
if [ -f $HOME/.config/tmp/bash-config.bash ]
then
    source $HOME/.config/tmp/bash-config.bash
else
    echo "BASH configuration file not found. Exiting..." >&2
    return
fi

# Variables, aliases and default settings
if [ -f $SH_CONFIG_DIR/bash/defaults.bash ]
then
    source $SH_CONFIG_DIR/bash/defaults.bash
else
    echo "Defaults file not found. Exiting..." >&2
    return
fi

# Functions
if [ -f $SH_CONFIG_DIR/bash/functions.bash ]
then
    source $SH_CONFIG_DIR/bash/functions.bash
else
    echo "Functions file not found. Exiting..." >&2
    return
fi

# Other configuration files --------------------------------------------

# Settings database
if [ -f $SH_ROOT_DIR/modules/kv-bash/kv-bash ]
then
    source $SH_ROOT_DIR/modules/kv-bash/kv-bash
    if [ -f $SH_CONFIG_DIR/bash/kv-helpers.bash ]
    then
        source $SH_CONFIG_DIR/bash/kv-helpers.bash
    fi
else
    echo "Config depends on kv-bash. Exiting..." >&2
    return
fi

# OS specific
if [ "$OS" == $OS_LINUX ]
then
    if [ -f $SH_CONFIG_DIR/bash/linux.bash ]
    then
        source $SH_CONFIG_DIR/bash/linux.bash
    else
        echo "Linux config file not found." >&2
    fi
elif [ "$OS" == $OS_DARWIN ]
then
    if [ -f $SH_CONFIG_DIR/bash/macos.bash ]
    then
        source $SH_CONFIG_DIR/bash/macos.bash
    else
        echo "MacOS config file not found." >&2
    fi
fi
