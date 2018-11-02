# install.bats

CONFIGS_INSTALLER=$CONFIGS_DIR/misc/scripts/install.sh
CONFIGS_BGPTHEMES=$CONFIGS_DIR/modules/bash-git-prompt/themes
INSTALLER_CMD="$(cat $CONFIGS_INSTALLER)"

function does_exist()
{
    file_type=$1; file=$2; should_exist=$3

    if [ "$should_exist" = "yes" ]
    then
        [ $file_type $file ]
    else
        ! [ $file_type $file ]
    fi
}

function check_installed()
{
    should_exist=$1

    does_exist "-L" $CONFIGS_BGPTHEMES/my-theme.bgptheme $should_exist
    does_exist "-L" $HOME/.bash_login $should_exist
    does_exist "-L" $HOME/.bash_logout $should_exist
    does_exist "-L" $HOME/.bashrc $should_exist
    does_exist "-L" $HOME/.bin $should_exist
    does_exist "-L" $HOME/.config $should_exist
    does_exist "-L" $HOME/.ssh $should_exist
    does_exist "-f" $HOME/.config/tmp/bash-config.bash $should_exist
    does_exist "-f" $HOME/.config/tmp/install.manifest $should_exist
}

@test "Clean local install." {
    # run /bin/bash -c "$(curl -fsL https://git.io/fxKQ2)" -- $CONFIGS_DIR
    run /bin/bash -c "$INSTALLER_CMD" -- $CONFIGS_DIR
    [ $status -eq 0 ] && check_installed yes
}

@test "Attempt to reinstall." {
    run /bin/bash -c "$INSTALLER_CMD" -- $CONFIGS_DIR
    [ $status -ne 0 ] && check_installed yes
}

@test "Uninstall." {
    run /bin/bash -c "$INSTALLER_CMD" -- -u $CONFIGS_DIR
    [ $status -eq 0 ] && check_installed no
}

@test "Install with local path." {
    run /bin/bash -c "$INSTALLER_CMD" -- $(basename $CONFIGS_DIR)
    [ $status -eq 0 ] && check_installed yes
}
