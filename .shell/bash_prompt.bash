# import colors
if [[ -f $HOME/.shell/color_names.sh ]]; then
  source $HOME/.shell/color_names.sh
fi

# my custom bash PROMPT_COMMAND:
prompt() {
    #PS1="\[${Yellow}\]\u\h:$ \n $"
    user="$(id -un)"
    host="$(hostname --short)"
    date="$(date +'%F %T')"
    curdir="${PWD/#$HOME/~}"
    lefttop_size="$((${#user}+${#host}+${#curdir}+4))"
    lefttop="\[${Green}${On_Black}\]${user}@${host} : \[${Blue}${On_Black}\]${curdir}\[${Red}${On_Black}\]"
    righttop="${date}"
    righttop_size="${#date}"

    numspaces=$(($(tput cols) - ${lefttop_size}))
    righttop2=$(printf "%${numspaces}s" "${righttop}")
    toprow="${lefttop}${righttop2}"
    PS1="\[${On_Black}\]${toprow}\[${Color_Off}\]\n \\$ "
}

PROMPT_COMMAND=prompt

cat << EOF > ~/.inputrc
  set editing-mode vi
  set show-mode-in-prompt on
  set vi-ins-mode-string "\1${Green}\2[i]\1${Color_Off}\e[5 q\2"
  set vi-cmd-mode-string "\1${Red}\2[n]\1${Color_Off}\e[1 q\2"
EOF

#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
