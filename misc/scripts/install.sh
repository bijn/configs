# Helpers --------------------------------------------------------------

function dotfile()
{
    file=$1

    echo $HOME/.$(basename ${file%.*})
}

function link_file()
{
    src_file=$1
    dst_file=$2
    install_manifest=$3

    ln -s $src_file $dst_file
    echo $dst_file >> $install_manifest
}

function uninstall()
{
    install_manifest=$1/shell/config/tmp/install.manifest

    if [ -f $install_manifest ]
    then
        for file in $(cat $install_manifest)
        do
            rm -f $file
        done

        rm -f $install_manifest
    fi
}

function usage_exit()
{
    echo "USAGE: install.sh [-cgu] [--] path" >&2 && false
    exit
}

# Setup ----------------------------------------------------------------

initial_dir=$PWD
args=$(getopt "cpu" $*)

if [ "$?" != "0" ]
then
    usage_exit
fi

set -- $args
for arg
do
    case "$arg"
    in
        -c) shift; do_clone=yes;;
        -g) shift; do_git_setup=yes;;
        -u) shift; do_uninstall=yes;;
        --) shift; config_dir=$*;;
        *) shift;;
    esac
done

if [ -z "$config_dir" ]
then
    usage_exit
fi

if ! [ -z "$do_uninstall" ]
then
    uninstall $config_dir
    exit
fi

if ! [ -z "$do_clone" ]
then
    if ! git clone --recursive https://github.com/bijn/configs $1
    then
        echo "Unable to clone repository. Exiting..." >&2 && false
        exit
    fi
fi

# Top level stuff ------------------------------------------------------

shell_dir=$config_dir/shell

if ! [ -e "$shell_dir" ]
then
    echo "$shell_dir does not exist. Exiting install... " >&2 && false
    exit
fi

link_file \
    $PWD/$config_dir/misc/bash-git-prompt/my-theme.bgptheme \
    $config_dir/modules/bash-git-prompt/themes/my-theme.bgptheme \
    $shell_dir/config/tmp/install.manifest

cd $shell_dir

for file in $PWD/*
do
    if [ -e "$(dotfile $file)" ]
    then
        echo "$(dotfile $file) exists. Exiting install..." >&2 && false
        exit
    fi
done

install_file=config/tmp/install.manifest

for file in $PWD/*
do
    link_file $file $(dotfile $file) $install_file
done

# Temp files -----------------------------------------------------------

cd config/tmp

echo "export SH_ROOT_DIR=$initial_dir/$config_dir" > bash-config.bash
echo "export SH_MISC_DIR=\$SH_ROOT_DIR/misc" >> bash-config.bash
echo "export SH_MODULE_DIR=\$SH_ROOT_DIR/modules" >> bash-config.bash
echo "export SH_SETTINGS_DIR=\$SH_ROOT_DIR/shell" >> bash-config.bash
echo "export SH_CONFIG_DIR=\$SH_SETTINGS_DIR/config" >> bash-config.bash
echo "export SH_TMP_DIR=\$SH_CONFIG_DIR/tmp" >> bash-config.bash

if ! [ -z "$do_git_setup" ]
then
    read -p "enter git name: " name
    read -p "enter git email: " email
    read -p "enter github username: " user
    echo "[user]" > git-user.config
    echo "    name = $name" >> git-user.config
    echo "    email = $email" >> git-user.config
    echo "[github]" >> git-user.config
    echo "    user = $user" >> git-user.config
    echo "[core]" >> git-user.config
    echo "    editor = emacs" >> git-user.config
fi
