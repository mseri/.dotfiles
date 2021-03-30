alias 'where'='rg -p'  #'grep -nrw'

# make path and enter
take() { mkdir -p "$1" && cd "$1" }

# draw a horizontal line
function rule {
    if [ -z "$1" ]
    then
        V="-"
    else
        V="$1"
    fi

    V=$V bash -c 'printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${V--}}'
}

export TIMEFMT='%J    %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %K MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

export TERM_ITALICS=true
export CLICOLOR=true

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

# OPAM configuration
. $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

if [ -f "$(which patdiff-git-wrapper)" ]; then
    export GIT_EXTERNAL_DIFF=$(which patdiff-git-wrapper)
fi
