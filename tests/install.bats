# install.bats

CONFIGS_INSTALLER=$CONFIGS_DIR/misc/scripts/install.sh
CONFIGS_BGPTHEMES=$CONFIGS_DIR/modules/bash-git-prompt/themes

@test "Clean local install." {
    # run /bin/bash -c "$(curl -fsL https://git.io/fxKQ2)" -- $CONFIGS_DIR
    run /bin/bash -c "$(cat $CONFIGS_INSTALLER)" -- $CONFIGS_DIR
    [ $status -eq 0 ]

    [ -L $CONFIGS_BGPTHEMES/my-theme.bgptheme ]
    [ -L $HOME/.bash_login ]
    [ -L $HOME/.bash_logout ]
    [ -L $HOME/.bashrc ]
    [ -L $HOME/.bin ]
    [ -L $HOME/.config ]
    [ -L $HOME/.ssh ]
    [ -f $HOME/.config/tmp/bash-config.bash ]
    [ -f $HOME/.config/tmp/install.manifest ]
}

@test "Attempt to reinstall." {
    run /bin/bash -c "$(cat $CONFIGS_INSTALLER)" -- $CONFIGS_DIR
    [ $status -ne 0 ]
}

@test "Uninstall." {
    run /bin/bash -c "$(cat $CONFIGS_INSTALLER)" -- -u $CONFIGS_DIR
    [ $status -eq 0 ]

    ! [ -L $CONFIGS_BGPTHEMES/my-theme.bgptheme ]
    ! [ -L $HOME/.bash_login ]
    ! [ -L $HOME/.bash_logout ]
    ! [ -L $HOME/.bashrc ]
    ! [ -L $HOME/.bin ]
    ! [ -L $HOME/.config ]
    ! [ -L $HOME/.ssh ]
    ! [ -f $HOME/.config/tmp/bash-config.bash ]
    ! [ -f $HOME/.config/tmp/install.manifest ]
}
