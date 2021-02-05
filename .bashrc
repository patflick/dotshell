# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# load all config dot files
. $HOME/.shell/*.sh
. $HOME/.shell/*.bash

# load powerline
#. $HOME/.shell/load_powerline

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
