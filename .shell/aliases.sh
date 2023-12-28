#######################################################################
#                          bash/zsh aliases                           #
#######################################################################

# Filesystem
alias ..='cd ..'            # Go up one directory
alias ...='cd ../..'        # Go up two directories
alias ....='cd ../../..'    # And for good measure
alias ls='ls --color=auto'
alias l='ls -1F --group-directories-first'      # most readable format (single column, dirs first)
alias la='ls -AhlF --group-directories-first'   # Long view, show hidden
alias ll='ls -lFh --group-directories-first'    # Long view, no hidden

# Helpers
alias df='df -h'            # Disk free, in gigabytes, not bytes
alias du='du -h -c'         # Calculate total disk usage for a folder
alias usage="du -h --max-depth=2 | sort -rh" # same as before, but sort and only one depth
alias path='echo -e ${PATH//:/\\n}' # print $PATH in a readable format
alias now='date +"%T"'               # print out the current time
alias shut='sudo shutdown -h now'   # immediate shutdown
alias xo='xdg-open'     # open file with X application matching it's MIME type
alias rmempty='find . -depth -type d -empty -exec rmdir {} \;' # recursively remove emtpy subdirectories
alias grep='grep --color=auto'
alias texclear='rm *.aux *.log *.toc *.out *.nav *.snm'

# fun aliases
alias bye='exit'
alias cya='exit'
alias please='sudo'
alias fucking='sudo'

# development
alias gdbrun='gdb -ex run --args'
alias mpitest4='mpirun -np 4 urxvt -hold -e'
alias mpigdb='mpirun -np 4 urxvt -hold -e gdb -ex run --args'

# easily kill current qsub jobs
qkill(){
  qstat -a | grep $USER | awk '{ print $1 }' | xargs qsig -s SIGKILL
}

# clipboard management PRIMARY <-> CLIPBOARD (relying on xsel)
alias p2c='xsel | xsel -b'
alias c2p='xsel -b | xsel'
alias clips='echo "=== PRIMARY ==="; xsel; echo ""; echo "== CLIPBOARD =="; xsel -b; echo  ""'

# kill easier
alias killfg='pkill -9 -P $$'
# kill chromium
alias kill-chrome='killall -s SIGKILL chromium-browser'

# Pretti-fy default `pstree` command
alias pstree='pstree --highlight-all --color age'

#############
#  apt-get  #
#############
# post grep (colors output)
function apts() {
    apt-cache search $1 | grep $1
}
alias apti='sudo apt-get install'
alias aptu='sudo apt-get update && sudo apt-get upgrade'
# list files contained in a package
alias aptls='dpkg-query -L'
# print all packages that have been installed
aptlog(){
aptgotten=$(cat <(zcat /var/log/apt/history.log.*.gz) <(cat /var/log/apt/history.log) | grep "apt-get install" | sed "s/Commandline: apt-get install //g" | sed 's/ /\n/g' | sort -u)
allcurpkgs=$(dpkg --get-selections | grep '\s\+install' | awk '{ print $1 }' | sort -u)
comm -12 <(echo $aptgotten) <(echo $allcurpkgs)
comm -23 <(echo $aptgotten) <(echo $allcurpkgs) | awk '{ print "*" $0 "\t(not installed)" }' | column -t
}

############
#  python  #
############

# python aliases
alias py='python'
alias ipy='ipython'
alias ipynb='ipython notebook'
alias py3='python3'
alias ipy3='ipython3'
alias ipy3nb='ipython3 notebook'
alias servethis="python3 -m http.server"
alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'
alias pycclean='find . -name "*.pyc" -exec rm {} \;'
# colorized cat based on pygments
alias ccat='pygmentize -g'

##########
#  Misc  #
##########

# curl for useragents (masquerading curl as a different user agent)
alias iecurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)\""
alias ffcurl="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.8) Gecko/2009032609 Firefox/3.0.0 (.NET CLR 3.5.30729)\""

# Add an "alert" alias for long running commands.  Use like so:
# Creates a popup message when command completes
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# lock screen
alias lock='gnome-screensaver-command -l'

# show open ports
alias ports='netstat -tulanp'

#####################
# Safety:
#####################

# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'

# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
