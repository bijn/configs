# linux.bash
# Linux config file

alias zathura='zathura --fork'

alias startx='startx $HOME/.config/x/xinitrc.bash'

alias xrandr-primary='xrandr | command grep -o ".* connected primary" \
                             | sed "s/\([^ \n]*\).*/\1/g" \
                             | tr -d [:space:]'

alias xrandr-native='xrandr | command grep -o "^[ \t]*[0-9]*x[0-9]*" \
                            | head -1 \
                            | tr -d [:space:]'

alias fullscreen='xrandr --output $(xrandr-primary) \
                         --mode $(xrandr-native)'

# bash-git-prompt
if [ -f /usr/lib/bash-git-prompt/gitprompt.sh ]
then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_THEME=my-theme
    source /usr/lib/bash-git-prompt/gitprompt.sh
fi
