# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    rxvt-unicode-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# import colors
. $HOME/.shell/color_names.sh

# my custom bash PROMPT_COMMAND:
prompt() {
    #PS1="\[${Yellow}\]\u\h:$ \n $"
    user="$(id -un)"
    host="$(hostname -f)"
    date="$(date +'%F %T')"
    curdir="$(pwd)"
    lefttop_size="$((${#user}+${#host}+${#curdir}-14))"
    lefttop="\[${Green}${On_Black}\]${user}@${host} : \[${Blue}${On_Black}\]$(pwd)"
    righttop="\[${Red}${On_Black}\]${date}"

    numspaces=$(($(tput cols)-${lefttop_size}))
    righttop2=$(printf "%${numspaces}s" "${righttop}")
    toprow="${lefttop}${righttop2}"
    PS1="\[${On_Black}\]${toprow}\[${Color_Off}\]\n $ " 
}


if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PROMPT_COMMAND=prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac