if [ -z "$1" ]
then
    exit 1
fi

if git clone --recursive https://github.com/bijn/bash $1 && cd $1
then
    for file in $PWD/shell/*
    do
        ln -sf $file $HOME/.$(basename ${file%.*})
    done

    echo "export SH_ROOT_DIR=\$HOME/$1" \
         > shell/config/tmp/bash-config.bash
    echo 'export SH_MISC_DIR=$SH_ROOT_DIR/misc' \
         >> shell/config/tmp/bash-config.bash
    echo 'export SH_MODULE_DIR=$SH_ROOT_DIR/modules' \
         >> shell/config/tmp/bash-config.bash
    echo 'export SH_SETTINGS_DI=$SH_ROOT_DIR/shell' \
         >> shell/config/tmp/bash-config.bash
    echo 'export SH_CONFIG_DIR=$SH_SETTINGS_DIR/config' \
         >> shell/config/tmp/bash-config.bash
    echo 'export SH_TMP_DIR=$SH_CONFIG_DIR/tmp' \
         >> shell/config/tmp/bash-config.bash

    read -p "enter git name: " name
    read -p "enter git email: " email
    read -p "enter github username: " user
    echo "[user]" > shell/config/tmp/git-user.config
    echo "    name = $name" >> shell/config/tmp/git-user.config
    echo "    email = $email" >> shell/config/tmp/git-user.config
    echo "[github]" >> shell/config/tmp/git-user.config
    echo "    user = $user" >> shell/config/tmp/git-user.config
    echo "[core]" >> shell/config/tmp/git-user.config
    echo "    editor = emacs" >> shell/config/tmp/git-user.config
fi
