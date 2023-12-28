#######################################################################
#                        zsh config using zgen                        #
#######################################################################
# load zgen [plugin manager]
source "${HOME}/.dotfiles/ext/zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

  # oh-my-zsh plugins (loaded without loading all of omz)
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/command-not-found
  zgen oh-my-zsh plugins/colorize
  zgen oh-my-zsh plugins/fzf

  # cloud
  zgen oh-my-zsh plugins/gcloud
  zgen oh-my-zsh plugins/kubectl

  # better VIM bindings
  #zgen load softmoth/zsh-vim-mode  [deprecated]
  zgen load jeffreytse/zsh-vi-mode

  # syntax highlighting
  #zgen load zdharma/fast-syntax-highlighting   [deprecated]
  #zgen load zsh-users/zsh-syntax-highlighting  [deprecated]
  zgen load zdharma-continuum/fast-syntax-highlighting

  # history search using CTRL+R (use fzf CTRL+R instead)
  #zgen oh-my-zsh plugins/history-substring-search
  #zgen load zdharma/history-search-multi-word  # replaced with fzf
  #zgen load joshskidmore/zsh-fzf-history-search

  # prefill line with suggestions
  zgen load zsh-users/zsh-autosuggestions # (doesn't work with multi-word hist)

  # color manpages
  zgen load ael-code/zsh-colored-man-pages

  # theme: powerlevel 10k
  zgen load romkatv/powerlevel10k powerlevel10k

  # fzf tab completion
  zgen load Aloxaf/fzf-tab

  # generate the init script from plugins above
  zgen save
fi

## use CTRL+Space to fill in autosuggestion
bindkey '^ ' autosuggest-accept

#############################
#  load own config
#############################
# loading the config after plugins enables overwriting of plugin defaults

# load all config dot files from .shell/*.sh and .shell/*.zsh
for f in ~/.shell/*.sh; do
  source "$f"
done
for f in ~/.shell/*.zsh; do
  source "$f"
done

# cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Powerlevel10k:
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#########
#  FZF  #
#########
# zsh tab completion using fzf for selection
enable-fzf-tab

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# Load FZF config and default keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/doc/fzf/examples/completion.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh


