# PATH variable
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# Limit default available memory for each bash/zsh session to 4GB
# This is to avoid thrashing and OOM instead.
#ulimit -v 4000000

# set default apps
export EDITOR=vim
export BROWSER=google-chrome

# TODO: looks like I don't need the hosts defined in there atm, why keep this?
# set user level hosts (/etc/hosts replacement)
export HOSTALIASES=$HOME/.hosts

# TODO: clean-up hist config: history between bash and zsh, share history with zsh, etc
# history settings
export HISTCONTROL=erasedups:ignorespace  # Ignore duplicate entries in history
export HISTFILE=$HOME/.histfile
export HISTSIZE=10000         # Increases size of history
export HISTFILESIZE=10000
export SAVEHIST=10000
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g"

# further shell options
SHOPT=`which shopt`
if [ -z SHOPT ]; then
    shopt -s histappend        # Append history instead of overwriting
    shopt -s cdspell           # Correct minor spelling errors in cd command
    shopt -s dotglob           # includes dotfiles in pathname expansion
    shopt -s checkwinsize      # If window size changes, redraw contents
    shopt -s cmdhist           # Multiline commands are a single command in history.
    shopt -s extglob           # Allows basic regexps in bash.
fi

# settings for stty (turn off XOFF and XON from Ctrl+S and Ctrl+Q respectively)
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef
