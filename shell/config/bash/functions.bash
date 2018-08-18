# Bijan Sondossi

##
#  @brief cd to the containing directory of a symbolic link
#  @param $1 The symbolic link to follow.
#  @returns true if we successfully change to the link's directory,
#           false otherwise.
#
function cdl()
{
    if ! empty-string $1
    then
        if [ -L $1 ]
        then
            dir="$(dirname $1)/"
            file_dir="$(dirname $(readlink $1))"
            if [ "$dir" = "." ] || [[ "$file_dir" = "/"* ]]
            then
                dir=""
            fi

            if [ -e $dir$file_dir ]
            then
                cd $dir$file_dir
                return
            fi
        else
            echo "File: '$1' does not exist." >&2
        fi
    else
        print-usage "cdl <link>"
    fi

    false
}

##
#  @brief Runs gui emacs with all specified arguments
#         as a background process.
#
function semac()
{
    command emacs "$@" &> /dev/null &
}
