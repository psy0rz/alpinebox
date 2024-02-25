export DTAP_ROLE="prod"
if [ "$PS1" ]; then
    export PS1="[\u@\h \W]\\$ "
    if [ "$DTAP_ROLE" == "dev" ]; then
        PS1="\[\033[1;32m\]$PS1\[\033[0m\]"
    elif [ "$DTAP_ROLE" == "test" ]; then
        PS1="\[\033[1;33m\]$PS1\[\033[0m\]"
    elif [ "$DTAP_ROLE" == "acc" ]; then
        PS1="\[\033[1;33m\]$PS1\[\033[0m\]"
    elif [ "$DTAP_ROLE" == "prod" ]; then
        PS1="\[\033[1;31m\]$PS1\[\033[0m\]"
    fi
fi
