autoload -U colors && colors

export PATH="$PATH:$HOME/.local/bin"

# utility functions

# contains(string, substring)
# ref: https://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-posix-sh
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
function contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

function nowbranch() {
  if command git status > /dev/null 2>&1; then
    echo "//$(git rev-parse --abbrev-ref HEAD)"
  else
    echo ""
  fi
}

alias lrc="source ~/.zshrc"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/shims:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# nvm path
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm use default > /dev/null

# deno path
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# flutter
export PATH="$HOME/dev/flutter/bin:$PATH"

# java
export PATH="/opt/android-studio/jre/bin:$PATH"

# arduino ide
export PATH="$HOME/arduino/:$PATH"

# fritzing
export PATH="$HOME/.fritzing/:$PATH"

# RL78
export PATH="$HOME/rl78/linux-x64/:$PATH"

# dotnet
export PATH="$HOME/.dotnet/:$PATH"

# inkscape
export PATH="$HOME/.inkscape/:$PATH"

# pandoc filter
export PATH="$HOME/.local/share/pandoc/filter:$PATH"

# mdr (markdown renderer)
# alias mdr="~/.mdr/mdr_linux_amd64"
export PATH="$HOME/.mdr:$PATH"

# lua
export PATH="$HOME/lua-5.4.6/src:$PATH"

# prompt
setopt Prompt_SUBST
PROMPT='
%F{magenta}python:$(pyenv version-name)@~${${${$(which python3)#*$(whoami)}%shims*}%/bin*}%f  %F{magenta}node:$(node -v)%f
%F{green}%n%f@%F{green}%m%f %F{yellow}%* %w%f %~%F{blue}$(nowbranch)%f
%F{cyan}%#%f '
TMOUT=1

TRAPALRM() {
    zle reset-prompt
}

# ls color
autoload -U compinit
compinit

export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias ls="ls -GF --color "
alias gls="gls --color "
alias history="history 1"

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# ls alias
alias la="ls -a "
alias ll="ls -l "

# history
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY

# thefuck
eval "$(thefuck --alias)"
alias f="fuck"

# git alias
alias glog="git log --graph --pretty=format:'%h %C(cyan)%an %Cgreen(%cr) %C(bold magenta)%d%C(reset) %n %s %n ' --first-parent "
alias glogn="git log --graph --pretty=format:'%h %C(cyan)%an %Cgreen(%cr) %C(bold magenta)%d%C(reset) %n %s %n ' --first-parent --name-status"
alias gch="git checkout "
alias gbr="git branch -v "
alias gvr="git branch -vva "
alias gs="git status -s"
alias gc="git commit "
alias gca="git commit -a "
alias gcaa="git commit -a --amend "
alias gst="git stash "
alias gsl="git stash list "
alias gsa="git stash apply "
alias gmpull="git checkout master && git pull"
alias gdlm="git branch --merged|egrep -v '\*|master'|xargs git branch -d"

# ハマりポイント
# - ファイル内で定義したfunctionはcommandでは実行できないのでベタ打ちになる
# - 返り値がreturnな関数は$()でうまくとってこれない というか多分これは標準出力をとってくるのでreturnはとれない
function showUnpushedChanges() {
  command git fetch -q
  local=$(git rev-parse --abbrev-ref HEAD)
  remote="remotes/origin/$local"
  branches=$(git branch -a --column)
  contains $branches $remote
  isContain="$?"
  if [ "$isContain" -eq 0 ]; then
    echo -e "\nthere are some changes pushed or branch point"
    command git diff -w --stat $remote
    return 0
  else
    echo "this branch is not pushed"
    return 0
  fi
  return 1
}
function git() {
  if [ "$#" -eq 1 -a "$1" = "push" ]; then
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo -e "push to \e[31;1m${current_branch}\e[m. ok? (y/N)"
    if read -q; then
      echo ""
      command git push
      return
    else
      echo -e "\npush abort."
      return
    fi
  fi
  if [ "$1" = "commit" ]; then
    command git "$@"
    if [[ "$?" == 0 ]]; then
      showUnpushedChanges
      return
    fi
    return
  fi
  if [ "$1" = "stash" -a "$2" = "delete" ]; then
    command git stash list
    echo -e "\e[31;1mDanger, this is LOSSY OPERATION!\e[m\ninput stash number which you want to delete"
    read indexes
    items=0
    # https://qiita.com/uasi/items/82b7708d5da213ba7c31
    for index in ${=indexes}
    do
      command git stash drop $index --quiet
    done
    echo -e "drop stashes indexed ${indexes}"
    return
  fi
  command git "$@"
}
function gac() {
  command git add $@
  command git commit
}
function gunlook() {
  command git update-index --skip-worktree "$1"
  command touch ~/Documents/.unlooked.lock
  echo "unlooking $1 now"
}
function glook() {
  command git update-index --no-skip-worktree "$1"
  echo "looking $1 now"
  echo "if you wanna completely looking all files now, PLS DELETE ~/Documents/.unlooked.lock"
}
function adbshot() {
  timestamp=$(date '+%y-%m-%d %H.%M.%S')
  command adb shell screencap -p /sdcard/screen.png && adb pull /sdcard/screen.png ~/Pictures/ && wait
  command mv ~/Pictures/screen.png ~/Pictures/adbshot\ ${timestamp}.png
  command adb shell rm /sdcard/screen.png
}

# other alias
# alias grep="grep -n "
alias wget="curl -O "

alias browsh="docker run -it --net=host --rm browsh/browsh"

# start tmux
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | $PERCOL | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :  # Start terminal normally
  fi
fi



# Load Angular CLI autocompletion.
source <(ng completion script)
