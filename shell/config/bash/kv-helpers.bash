# Bijan Sondossi
# KV helper functions.

##
#  @brief Check if a key exists.
#  @param $1 The key name to check.
#  @returns true if the key exists, false otherwise.
#
function kv-exists()
{
    if ! empty-string "$1"
    then
        if kvget "$1" &> /dev/null
        then
           return
        fi
    fi

    false
}

##
#  @brief Check if a key's value.
#  @param $1 The key name to check.
#  @param $2 The value to compare.
#  @returns true if the key's value matches the argument value, false
#           otherwise.
#
function kv-check()
{
    if ! empty-string "$1"
    then
        if kv-exists "$1"
        then
            if [ "$(kvget $1)" == "$2" ]
            then
                return
            fi
        fi
    else
        print-usage "kv-check <key> <value>"
    fi

    false
}

##
#  @brief Prompts the user with a message and sets the specified key to
#         yes or no.
#  @param $1 The key to set.
#  @param $2 The prompt.
#  @returns true if the key value is yes, false otherwise.
#
#  @todo Change this function to overwrite old value and add a wrapper
#        that does not clobber.
#
function kv-y-or-n ()
{
    if ! [ -z "$1" ] && ! [ -z "$2" ]
    then
        if ! kv-exists "$1"
        then
            if y-or-n "$2"
            then
                kvset $1 yes
                return
            else
                kvset $1 no
            fi
        fi

        if kv-check "$1" "yes"
        then
            return
        fi
    else
        print-usage "kv-y-n-or-s <key> <prompt>"
    fi

    false
}

##
#  @brief Prompts the user with a message that can be skipped. If the
#         user responds sets the specified key to yes or no.
#  @param $1 The key to set.
#  @param $2 The prompt.
#  @returns true if the key value is yes, false otherwise.
#
#  @todo Change this function to overwrite old value and add a wrapper
#        that does not clobber.
#
function kv-y-n-or-s ()
{
    if ! [ -z "$1" ] && ! [ -z "$2" ]
    then
        if ! kv-exists "$1"
        then
            response=$(y-n-or-s "$2")
            if [ $response -eq $RETURN_YES ]
            then
                kvset $1 yes
            elif [ $response -eq $RETURN_NO ]
            then
                kvset $1 no
            fi
        fi

        if kv-check "$1" "yes"
        then
            return
        fi
    else
        print-usage "kv-y-n-or-s <key> <prompt>"
    fi

    false
}
