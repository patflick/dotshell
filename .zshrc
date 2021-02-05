#######################################################################
#                        zsh config using zgen                        #
#######################################################################
# load zgen [plugin manager]
source "${HOME}/.dotfiles/ext/zsh/zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

  # oh-my-zsh plugins (loaded without loading all of omz)
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/command-not-found
  #zgen oh-my-zsh plugins/history-substring-search
  zgen oh-my-zsh plugins/colorize
  zgen oh-my-zsh plugins/fzf

  # better VIM bindings
  zgen load softmoth/zsh-vim-mode

  # syntax highlighting
  zgen load zdharma/fast-syntax-highlighting  #(doens't work with history-search-multi-word)
  #zgen load zsh-users/zsh-syntax-highlighting

  # history search using CTRL+R
#  zgen load zdharma/history-search-multi-word

  # prefill line with suggestions
  zgen load zsh-users/zsh-autosuggestions # (doesn't work with multi-word hist)

  # color manpages
  zgen load ael-code/zsh-colored-man-pages

  # theme: powerlevel 10k
  zgen load romkatv/powerlevel10k powerlevel10k

  # generate the init script from plugins above
  zgen save
fi

## use CTRL+Space to fill in autosuggestion
bindkey '^ ' autosuggest-accept

#############################
#  load own config
#############################
# loading the config after oh-my-zsh enables overwriting of OMZ defaults

# -- shared zsh/bash settings --
. $HOME/.shell/aliases.sh
. $HOME/.shell/functions.sh
. $HOME/.shell/variables.sh

# Powerlevel10k:
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# Load FZF config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
