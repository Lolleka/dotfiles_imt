# If not running interactively, don't do anything!
[[ $- != *i* ]] && return

autoload -Uz compinit
autoload -U colors && colors
compinit

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


setopt completealiases
setopt histignorealldups sharehistory

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

#source /usr/share/doc/pkgfile/command-not-found.zsh

DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

## This reverts the +/- operators.
setopt pushdminus

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS. Try to use the external file
# first to take advantage of user additions. Use internal bash
# globbing instead of external grep binary.

# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

#PROMPT="[%{$fg[yellow]%}%*%{$reset_color%}] %{$fg[red]%}%n@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}$ "
ucolor="red"
if [ "$USERNAME" = "root" ]; then
        ucolor="blue"         # root is blue, user isred
fi; 
alias printpwd="pwd | sed 's|$HOME|~|' | sed -r 's|([^/]{3})[^/]*/|\1/|g'"
alias printcl="cat /tmp/cheerlight | cut -d \"%\" -f 1"
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
CHEERLIGHT=$(cat /tmp/cheerlight)
setopt PROMPT_SUBST
PROMPT='[%{$fg[$(cat /tmp/cheerlight)]%}%*%{$reset_color%}] %{$fg[$ucolor]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}$(printpwd) %{$fg_bold[yellow]%}$(parse_git_branch)%{$reset_color%}$ '
#RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
#$(pwd  | sed -r 's|\/([^/]{3})[^/]*\/|\/\1\/|g')

export EDITOR=vim
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


alias ls="ls --color=auto -X --group-directories-first"
#loads lscolors
eval `dircolors -b ~/.lscolors`
#alias ll="ls -lh"
alias ll="ls++ -X --potsf"
alias rm="rm -r"
alias du="du -h"
alias df="df -h"
alias dir="dir --color=auto"
alias grep="grep --color=auto"
alias dmesg='dmesg --color'
alias findps='ps -ef --forest | grep -B 3 -A 3'
alias mount='sudo mount'
alias umount='sudo umount'
alias pacman='sudo pacman' 
#alias ne="TERM=gnome ne"
#alias sune="TERM=gnome sudo ne"
alias sune="sudo ne"
alias vi='vim'
alias fim='FBFONT=/usr/share/kbd/consolefonts/LatGrkCyr-8x16.psfu.gz fim'
alias kit='cd /home/Seafile/KIT-IMT'
alias litplay='CACA_DRIVER=ncurses mplayer -vo caca -quiet'
alias feh='feh -. -g 1000x800'
#alias ssh="TERM=gnome ssh"
#alias st="transmission-remote --auth lolleka:helluva -torrent all -status"
#alias sshpi="TERM=xterm ssh root@lolleka.no-ip.biz"
#alias sshpi="ssh root@lolleka.no-ip.biz"

##Set some keybindings
###############################################
typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
bindkey '^[[2~' overwrite-mode
[[ -n $TMUX ]] && bindkey '\e[1~' beginning-of-line
[[ -n $TMUX ]] && bindkey '\e[4~' end-of-line
#################################################

#Start X server automatically
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
#
PATH=$PATH:~/.cabal/bin
