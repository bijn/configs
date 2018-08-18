# Bijan Sondossi

# setxkbmap -layout dvorak

# if [ -e $HOME/documents/bash/settings/config/x/xmodmap ]
# then
#     xmodmap $HOME/documents/bash/settings/config/x/xmodmap
# fi

if [ -f $HOME/.config/tmp/bash-config.bash ]
then
    source $HOME/.config/tmp/bash-config.bash
else
    exec i3
    exit
fi

if [ -f $SH_TMP_DIR/xrandr.bash ]
then
    source $SH_TMP_DIR/xrandr.bash
fi

if [ $SH_MOODULE_DIR/xresources/Xresources ]
then
    xrdb -merge $SH_MODULE_DIR/xresources/Xresources
    xrdb -merge $SH_CONFIG_DIR/x/xresources
fi

if which feh
then
    command="feh --no-fehbg"

    if [ -e $HOME/pictures/wallpaper.jpg ]
    then
        command+=" --bg-max $HOME/pictures/wallpaper.jpg"
        command+=" --image-bg #282a36"
    fi

    if [ -e $HOME/pictures/wallpaper_2.jpg ]
    then
        command+=" --bg-max $HOME/pictures/wallpaper_2.jpg"
        command+=" --image-bg #282a36"
    fi

    $command
else
    xsetroot -solid \#282a36
fi

exec i3
