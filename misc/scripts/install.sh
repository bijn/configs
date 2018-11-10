#!/bin/bash

# todo
# - delete bash-config.bash and git-user.config on uninstall?
# - '-i' option (like rm).
# - config modules.

# Constants ------------------------------------------------------------

readonly SCRIPT_NAME="$0"
readonly CLI_OPTS="cfghiku"
readonly CONFIGS_REPO="https://github.com/bijn/configs"

# Helpers --------------------------------------------------------------

function cerr()
{
    echo "$1" >&2
}

function dotfile()
{
    file=$1

    echo $HOME/.$(basename ${file%.*})
}

function backup_file()
{
    backup_dir=$1/backup; target=$2

    if ! [ -e "$backup_dir" ]
    then
        mkdir $backup_dir
    fi

    if [ -e $target ]
    then
        mv -f $target $backup_dir
    fi
}

function link_file()
{
    src_file=$1; dst_file=$2; install_manifest=$3

    if ! [ -e "$dst_file" ]
    then
        if ln -s $src_file $dst_file >& /dev/null
        then
            echo $dst_file >> $install_manifest
            return
        fi
    else
        if [ -d "$src_file" ] && [ -d "$dst_file" ]
        then
            dst_dir=$dst_file
            for file in $src_file/*
            do
                link_file \
                    $file $dst_dir/$(basename $file) $install_manifest
            done
        fi
    fi

    false
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
    cerr "USAGE: $SCRIPT_NAME [-$CLI_OPTS] [--] path" && false
    # long options
    exit
}

# Setup ----------------------------------------------------------------

for arg in $@
do
    shift
    case "$arg"
    in
        --clone) set -- $@ -c;;
        --force) set -- $@ -f;;
        --git-setup) set -- $@ -g;;
        --help) set -- $@ -h;;
        --keep-going) set -- $@ -k;;
        --uninstall) set -- $@ -u;;
        *) set -- $@ $arg;;
    esac
done

do_clone=""
do_force=""
do_query=""
do_git_setup=""
keep_going=""
do_ininstall=""

while getopts "$CLI_OPTS" opt
do
    case "$opt"
    in
        c) do_clone=yes;;
        f) do_force=yes;;
        g) do_git_setup=yes;;
        h) usage_exit;;
        i) cerr "CLI option '-i' unimplemented."; usage_exit;;
        k) keep_going=yes;;
        u) do_uninstall=yes;;
        *) usage_exit;;
    esac
done

shift $((OPTIND-1))
configs_dir=$*

if [ -z "$configs_dir" ]
then
    usage_exit
fi

if [ "$do_uninstall" = "yes" ]
then
    uninstall $configs_dir
    exit
fi

if [ "$do_clone" = "yes" ]
then
    if ! git clone --recursive $CONFIGS_REPO $configs_dir
    then
        cerr "Unable to clone repository. Exiting..." && false
        exit
    fi
fi

case $configs_dir
in
    /*) config_path=$configs_dir;;
    *) config_path=$PWD/$configs_dir;;
esac

# Variables
bgp_src=$config_path/misc/bash-git-prompt/my-theme.bgptheme
bgp_dst=$config_path/modules/bash-git-prompt/themes/my-theme.bgptheme
shell_dir=$configs_dir/shell
tmp_dir=$shell_dir/config/tmp
bash_config=$tmp_dir/bash-config.bash
git_config=$tmp_dir/git-user.config
manifest=$tmp_dir/install.manifest

# Install --------------------------------------------------------------

if [ "$do_force" = "yes" ] && [ -e "$manifest" ]
then
    rm -rf "$manifest"
fi

if ! [ -e "$shell_dir" ]
then
    cerr "$shell_dir does not exist. Exiting install... " && false
    exit
fi

if [ "$do_force" = "yes" ]
then
    backup_file $tmp_dir $bgp_dst
fi

if ! link_file $bgp_src $bgp_dst $manifest
then
    cerr "Warning, unable to link my-theme.bgptheme..."
fi

if [ "$do_force" = "yes" ] || [ -z "$keep_going" ]
then
    for file in $shell_dir/*
    do
        if [ -e "$(dotfile $file)" ]
        then
            if [ "$do_force" = "yes" ]
            then
                backup_file $tmp_dir $(dotfile $file)
            else
                cerr "Error, $(dotfile $file) exists. Exiting..."
                false
                exit
            fi
        fi
    done
fi

for file in $shell_dir/*
do
    if ! link_file $file $(dotfile $file) $manifest
    then
        cerr "Warning, unable to link $file..."
    fi
done

# Temp files -----------------------------------------------------------

backup_file $tmp_dir $bash_config

echo "export SH_ROOT_DIR=$config_path" > $bash_config
echo "export SH_MISC_DIR=\$SH_ROOT_DIR/misc" >> $bash_config
echo "export SH_MODULE_DIR=\$SH_ROOT_DIR/modules" >> $bash_config
echo "export SH_SETTINGS_DIR=\$SH_ROOT_DIR/shell" >> $bash_config
echo "export SH_CONFIGS_DIR=\$SH_SETTINGS_DIR/config" >> $bash_config
echo "export SH_TMP_DIR=\$SH_CONFIGS_DIR/tmp" >> $bash_config

if [ "$do_git_setup" = "yes" ]
then
    backup_file $tmp_dir $git_config

    read -p "enter git name (First Last): " name
    read -p "enter git email: " email
    read -p "enter github username: " user
    echo "[user]" > $git_config
    echo "    name = $name" >> $git_config
    echo "    email = $email" >> $git_config
    echo "[github]" >> $git_config
    echo "    user = $user" >> $git_config
    echo "[core]" >> $git_config
    echo "    editor = emacs" >> $git_config
fi
