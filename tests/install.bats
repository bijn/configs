# install.bats

# todo
# - long options
# - check for git-user && bash-config backups every time
# - test -fk (f should take precedence?).

CONFIGS_INSTALLER=$CONFIGS_DIR/misc/scripts/install.sh
CONFIGS_BACKUP=$CONFIGS_DIR/shell/config/tmp/backup

GIT_INSTALLER="echo -e \"name\nemail\nusername\n\" | $CONFIGS_INSTALLER"

function check_installed()
{
    [ -L $CONFIGS_BGPTHEMES/my-theme.bgptheme ]
    [ -L $HOME/.bash_login ]
    [ -L $HOME/.bash_logout ]
    [ -L $HOME/.bashrc ]
    [ -L $HOME/.bin ]
    [ -d $HOME/.config ]
    [ -d $HOME/.ssh ]
    [ -f $HOME/.config/tmp/bash-config.bash ]
    [ -f $HOME/.config/tmp/install.manifest ]
}

function check_uninstalled()
{
    ! [ -L $CONFIGS_BGPTHEMES/my-theme.bgptheme ]
    ! [ -L $HOME/.bash_login ]
    ! [ -L $HOME/.bash_logout ]
    ! [ -L $HOME/.bashrc ]
    ! [ -L $HOME/.bin ]
    ! [ -d $HOME/.config ]
    ! [ -d $HOME/.ssh ]
    ! [ -f $HOME/.config/tmp/bash-config.bash ]
    ! [ -f $HOME/.config/tmp/git-user.config ]
    ! [ -f $HOME/.config/tmp/install.manifest ]
}

function check_has_backup()
{
    [ -e $CONFIGS_BACKUP/my-theme.bgptheme ]
    [ -e $CONFIGS_BACKUP/.bash_login ]
    [ -e $CONFIGS_BACKUP/.bash_logout ]
    [ -e $CONFIGS_BACKUP/.bashrc ]
    [ -e $CONFIGS_BACKUP/.bin ]
    [ -e $CONFIGS_BACKUP/.config ]
    [ -e $CONFIGS_BACKUP/.ssh ]
    [ -f $CONFIGS_BACKUP/bash-config.bash ]
}

function check_no_backup()
{
    ! [ -e $CONFIGS_BACKUP/my-theme.bgptheme ]
    ! [ -e $CONFIGS_BACKUP/.bash_login ]
    ! [ -e $CONFIGS_BACKUP/.bash_logout ]
    ! [ -e $CONFIGS_BACKUP/.bashrc ]
    ! [ -e $CONFIGS_BACKUP/.bin ]
    ! [ -e $CONFIGS_BACKUP/.config ]
    ! [ -e $CONFIGS_BACKUP/.ssh ]
    ! [ -f $CONFIGS_BACKUP/bash-config.bash ]
    ! [ -f $CONFIGS_BACKUP/git-user.config ]
}

@test "Clean install." {
    run $CONFIGS_INSTALLER $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_installed
}

@test "Reinstall fail." {
    run $CONFIGS_INSTALLER $CONFIGS_DIR
    [ "$status" -ne 0 ] && check_installed
}

@test "Uninstall." {
    run $CONFIGS_INSTALLER -u $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_uninstalled
}

@test "Install with relative path." {
    run $CONFIGS_INSTALLER $(basename $CONFIGS_DIR)
    [ "$status" -eq 0 ] && check_installed
}

@test "Uninstall with relative path." {
    run $CONFIGS_INSTALLER -u $(basename $CONFIGS_DIR)
    [ "$status" -eq 0 ] && check_uninstalled
}

@test "Force install." {
    run $CONFIGS_INSTALLER -f $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_installed && check_no_backup

    run $CONFIGS_INSTALLER -f $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_installed && check_has_backup
}

@test "Install with Git." {
    run $CONFIGS_INSTALLER -u $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_uninstalled

    run /bin/bash -c "$GIT_INSTALLER -g $CONFIGS_DIR"
    [ "$status" -eq 0 ]

    check_installed
    [ -f $HOME/.config/tmp/git-user.config ]
}

@test "Uninstall with Git option." {
    run $CONFIGS_INSTALLER -gu $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_uninstalled
}

@test "Force install with Git." {
    run /bin/bash -c "$GIT_INSTALLER -fg $CONFIGS_DIR"
    [ "$status" -eq 0 ]

    run /bin/bash -c "$GIT_INSTALLER -fg $CONFIGS_DIR"
    [ "$status" -eq 0 ]

    check_installed
    [ -f $HOME/.config/tmp/git-user.config ]

    check_has_backup
    [ -f $CONFIGS_BACKUP/git-user.config ]
}

@test "Keep going." {
    run $CONFIGS_INSTALLER -u $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_uninstalled

    mkdir $HOME/.config
    mkdir $HOME/.ssh

    run $CONFIGS_INSTALLER -k $CONFIGS_DIR
    [ "$status" -eq 0 ] && check_installed

    ls -la $HOME

    run $CONFIGS_INSTALLER -u $CONFIGS_DIR
    [ "$status" -eq 0 ]

    ls -la $HOME

    ! [ -L $CONFIGS_BGPTHEMES/my-theme.bgptheme ]
    ! [ -L $HOME/.bash_login ]
    ! [ -L $HOME/.bash_logout ]
    ! [ -L $HOME/.bashrc ]
    ! [ -L $HOME/.bin ]
    [ -d $HOME/.config ]
    [ -d $HOME/.ssh ]
    ! [ -f $HOME/.config/tmp/bash-config.bash ]
    ! [ -f $HOME/.config/tmp/git-user.config ]
    ! [ -f $HOME/.config/tmp/install.manifest ]

    run ls $HOME/.config
    [ -z "$output" ]

    run ls $HOME/.ssh
    [ -z "$output" ]
}
