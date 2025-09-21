#### HISTORY SETUP ####

if [ -z $HISTFILE ]; then
    HISTFILE=$HOME/.zsh_history
fi
HISTSIZE=100000
SAVEHIST=100000
HISTCONTROL=ignoredups

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

#### AUTOCOMPLETE SETUP ####
if [ -d "$HOME/.zsh/completions" ] ; then
  fpath=($HOME/.zsh/completions $fpath)
fi

autoload -U compinit
compinit

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist

# case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

zstyle ':completion:*' users off

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

#### FOLDER STACK ####

DIRSTACKSIZE=8
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'

#### MAIN ####

export TERM_ITALICS=true
export CLICOLOR=true

if command -v fasd >/dev/null 2>&1; then
  eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install posix-alias)"
fi

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

# OPAM configuration
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# if [ -f "$(which patdiff-git-wrapper)" ]; then
#     export GIT_EXTERNAL_DIFF=$(which patdiff-git-wrapper)
# fi

export TIMEFMT='%J    %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %K MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'


#### CUSTOM FUNCTIONS ####

alias 'where'='rg -p'  #'grep -nrw'

# make path and enter
take() { mkdir -p "$1" && cd "$1" }

# watch tex files for rebuild
texwatch() { fd ".*.tex" | entr tectonic --synctex "$1" }
texmkwatch() { fd ".*.tex" | entr latexmk -pdf "$1" }

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

# wrap the ollama command, if the parameter is pull with no other parameters pull all models
# function ollama() {
#   if [[ $1 == "pull" ]] && [[ $# -eq 1 ]]; then
#     echo "pulling all models..."
#     ollama list | awk '$1 !~ /^registry.local/ {print $1}' | while read -r model; do
#       echo "Pulling $model"
#       ollama pull "$model"
#     done
#   else
#     command ollama "$@"
#   fi
# }

function html_to_md () {
  if [[ $# -eq 2 ]]; then
    curl "https://r.jina.ai/$1" > "$2".md
    echo "Content saved to \"$2\".md"
  else
    curl "https://r.jina.ai/$@"
  fi
}

# from https://github.com/davidgasquez/dotfiles/blob/bb9df4a369dbaef95ca0c35642de491c7dd41269/shell/zshrc#L50-L99
#
qh() {
  local url="$1"
  local question="$2"

  # Fetch the URL content through Jina
  local content=$(curl -s "https://r.jina.ai/$url")

  # Check if the content was retrieved successfully
  if [ -z "$content" ]; then
    echo "Failed to retrieve content from the URL."
    return 1
  fi

  system="
  You are a helpful assistant that can answer questions about the content.
  Reply concisely, in a few sentences.

  The content:
  ${content}
  "

  # Use llm with the fetched content as a system prompt
  llm prompt "$question" -s "$system"
}

qv() {
  local url="$1"
  local question="$2"
  local model="${3:-groq-llama-3.3-70b}"

  # Fetch the URL content through Jina
  local subtitle_url=$(yt-dlp -q --skip-download --convert-subs srt --write-sub --sub-langs "en" --write-auto-sub --print "requested_subtitles.en.url" "$url")
  local content=$(curl -s "$subtitle_url" | sed '/^$/d' | grep -v '^[0-9]*$' | grep -v '\-->' | sed 's/<[^>]*>//g' | tr '\n' ' ')

  # Check if the content was retrieved successfully
  if [ -z "$content" ]; then
    echo "Failed to retrieve content from the URL."
    return 1
  fi

  system="
  You are a helpful assistant that can answer questions about YouTube videos.
  Reply concisely, in a few sentences.

  The content:
  ${content}
  "

  # Use llm with the fetched content as a system prompt
  llm prompt -m "$model" "$question" -s "$system"
}
