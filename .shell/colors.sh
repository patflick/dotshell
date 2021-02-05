############
#  colors  #
############
# sets custom color schemes for different programs

# grep highlight color (without \e[ code)
export GREP_COLOR='0;33'

# color for `ls` (via dircolors)
eval `dircolors $HOME/.shell/dir_colors`

# Load color names
source ${HOME}/.shell/color_names.sh

# Color manpages
export LESS_TERMCAP_mb=$BRed                # begin blinking
export LESS_TERMCAP_md=$BBlue               # begin bold
export LESS_TERMCAP_us=$UYellow             # begin underline
export LESS_TERMCAP_ue=$Color_Off           # end underline
export LESS_TERMCAP_me=$Color_Off           # end mode
export LESS_TERMCAP_se=$Color_Off           # end standout-mode
export LESS_TERMCAP_so=$BBlack$On_Yellow    # standout-mode (search & info)
