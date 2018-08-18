# Bijan Sondossi

# Constants ------------------------------------------------------------

readonly OS_DARWIN="darwin" &> /dev/null
readonly OS_LINUX="linux" &> /dev/null

# Variables ------------------------------------------------------------

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# Detecting OS - just going to assume linux or macos
export OS=$OS_LINUX
export lsArgs='-mh --color=always'
export llArgs='-logk'
if [[ "$OSTYPE" == $OS_DARWIN* ]]
then
    export OS=$OS_DARWIN
    export lsArgs='-mhG'
    export llArgs='-logk'
fi

# Return value definitions
export RETURN_YES=0
export RETURN_NO=1
export RETURN_SKIP=2

# Path
if [ -d ~/.bin ]
then
    export PATH=~/.bin:$PATH
fi

# Prompt - https://goo.gl/MnWMgw
# You can set PROMPT_COMMAND to commands you want to be executed
# before the prompt is displayed.
# Couldn't get PROMPT_COMMAND to work on Arch so: https://goo.gl/qG3kjk
PS1="\[$(tput setaf 6)\]"
PS1+="\W "
PS1+="\$("
PS1+="VALUE=\$?;"
PS1+="if [ \$VALUE == 0 ];"
PS1+="then"
PS1+="    printf \[$(tput setaf 2)\];"
PS1+="else"
PS1+="    printf \[$(tput setaf 1)\];"
PS1+="fi"
PS1+=")"
PS1+=">\[$(tput sgr0)\] "
export PS1
export PS2="\[$(tput setaf 6)\]\W \[$(tput setaf 4)\]>\[$(tput sgr0)\] "

# Listing
# Useful links:
#  http://geoff.greer.fm/lscolors/
#  https://gist.github.com/smutnyleszek/c44124908a9b737e372c28aaf0048b44
export CLICOLOR=1
export LSCOLORS=gxfxCxDxBxegedabagaced
export LS_COLORS="di=36:ln=35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43"
export LS_COLORS="$LS_COLORS:su=30;41:sg=30;46:tw=30;42:ow=34;43"

# Editors
export VISUAL='command emacs'
export EDITOR='vim'
export ALTERNATE_EDITOR='command emacs -nw'

# BASH files
export HISTFILE=$HOME/.local/.bash_history

# Shopt settings -------------------------------------------------------

shopt -s extglob
shopt -s cdspell

# Aliases --------------------------------------------------------------

# Emacs
alias emacs='emacs -nw'
alias emaqs='emacs -q'
alias semaq='semac -q'

# File handling
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias rmf='rm -f'
alias clean='rmf *~;'
alias grep='grep --colour=always'

# Listing
alias ls='ls $lsArgs'
alias lsa='ls -A'

# Long listing
alias ll='ls $llArgs'
alias lla='ll -A'

# List one file per line
alias ols='ls -1'
alias olsa='ols -A'

# Make
alias make='make -s'

# Other
alias ascii='man ascii | cat'
alias motd='cat /etc/motd'
alias j='jobs -l'
