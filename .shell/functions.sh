#######################################################################
#                bash/zsh functions (extended aliases)                #
#######################################################################

# extract a bunch of different file types by file extension
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)        tar xjf $1        ;;
            *.tar.gz)         tar xzf $1        ;;
            *.bz2)            bunzip2 $1        ;;
            *.rar)            unrar x $1        ;;
            *.gz)             gunzip $1         ;;
            *.tar)            tar xf $1         ;;
            *.tbz2)           tar xjf $1        ;;
            *.tgz)            tar xzf $1        ;;
            *.zip)            unzip $1          ;;
            *.7z)             p7zip -d $1       ;;
            *.Z)              uncompress $1     ;;
            *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# process info
psgrep() {
  ps aux | grep -v grep | grep "$@" -i --color=auto;
}
# returns PIDs of processes matching the given name
getpids() {
  ps aux | grep -v "grep" | grep "$@" | awk '{print $2}'
}

# killit:
# More-gracefully kills a process by trying signals in increasing toughness:
#  (SIGTERM SIGINT SIGKILL). Waits in between signals to see if it worked
#  before moving to next one.
# https://unix.stackexchange.com/questions/8916/when-should-i-not-kill-9-a-process
killit() {
  for kill_sig in SIGTERM SIGINT SIGKILL
  do
    # get processes
    arr=($(echo ${$(getpids $@)//$'\n'/ }))
    if [ -z "$arr" ]
    then
      echo "No more processes"
      break
    else
      echo "Sending $kill_sig to ${#arr[@]} processes"
      for process in ${arr[@]}
      do
        kill -$kill_sig $process
      done
    fi
    # wait a second bnefore sending next (more evil) signal
    sleep 1
  done
}

vimls() {
  # list all open files of vim instances
  # used to identify the corrent vim instance to attach to
  # (via tmus-stealpid)
  homeesc=$(echo $HOME | sed 's/\//\*/g' | sed 's/\*/\\\//g')
  lsof -c vim | grep "$HOME" | grep "REG" | grep -v ".vim" |
  awk '{print $1, $2, $9}' | sed "s/$homeesc/~/" | sed "s/\/\.([a-zA-Z_-\.]+)"
}

# wraps tmux around current background process
# Prereq: `reptyr`
tmux-wrapfg() {
  # get pid of current running job
  pid=`jobs -l | grep -Po "\d\d+" --color=none`
  jobid=`jobs -l | grep -Po "\d" --color=none`
  bg
  disown %$jobid
  tmux new-session "reptyr $pid"
}

tmux-stealpid() {
  # `steals` the process with the given PID into a new tmux session
  tmux new-session "reptyr $@"
}

# svg 2 pdf using inkscape cmd
function svg2pdf() {
  for f in $@
  do
    echo "converting $f"
    inkscape -D -z --file=$f --export-pdf=$f.pdf
  done
}

# my external IP
exip () {
    # gather external ip address
    echo -n "ext: "
    #wget http://ipecho.net/plain -O - -q ; echo
    curl ifconfig.me/ip
    curl ifconfig.me/host
}

# print local and external ip
ips () {
    # determine local IP address
    ifconfig | grep "inet " | awk '{ print $2 }'
    # also print external ip
    exip
}

macs () {
    # print MAC addresses of all interfaces
    ifconfig | grep 'HWaddr' | awk '{print $1, ":\t", $5}'
}

shell () {
    # returns the name of the shell executing this
    ps | grep `echo $$` | awk '{ print $4 }'
}

# if `tree` doesn't exist, make our own:
if [ -z "\${which tree}" ]; then
  tree () {
      find $@ -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
  }
fi

# print battery info
bat () {
    # get and print battery state
    bats=$(upower --enumerate | grep BAT)

    echo $bats | while read bat
    do
        bat_idx=$(echo -n $bat | sed -n 's/.*_BAT//p')

        bat_info=$(upower -i $bat)
        echo "Battery Status:"
        echo "  Battery $bat_idx"
        # TODO properly extract all info about the power device
        echo $bat_info | grep "state"
        echo $bat_info | grep "time to empty"
        echo $bat_info | grep "time to full"
        echo $bat_info | grep "percentage"
    done
}

# bash inline python expression
calc () {
    # executes the given arguments as python code and prints the results
    python -c "print(eval(\"`echo $@`\"))"
}

# poll_git_pull: every 5 minutes: git pull and show new changes on terminal
# I used this when colaboratively writing overleaf latex docs.
poll_git_pull() {
while [ 1 ]
do
    hr
    git fetch origin
    # show log of difference
    git --no-pager log --pretty=format:"%C(yellow)%h\\ %Cgreen(%ad)%C(auto)%d\\ %Cblue[%an]\\ %Creset%s" HEAD..origin/master 
    # show actual diff
    git --no-pager diff --word-diff --minimal HEAD..origin/master
    git merge origin/master
    sleep 300
done
}

#######################################################################
#                         Color tests scripts                         #
#######################################################################

test_colors_16() {
    # taken from:
    # http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
    T='gYw'   # The test text
    echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";
    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
        do echo -en "$EINS \033[$FG\033[$BG  $T \033[0m\033[$BG \033[0m";
        done
        echo;
    done
    echo
}

test_colors_256(){
# the following is licenced with CC-BY (CC 3.0)
# source:
# http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux
    echo -en "\n   +  "
    for i in {0..35}; do
        printf "%2b " $i
    done
    printf "\n\n %3b  " 0
    for i in {0..15}; do
        echo -en "\033[48;5;${i}m  \033[m "
    done
    #for i in 16 52 88 124 160 196 232; do
    for i in {0..6}; do
        let "i = i*36 +16"
        printf "\n\n %3b  " $i
        for j in {0..35}; do
            let "val = i+j"
            echo -en "\033[48;5;${val}m  \033[m "
        done
    done
    echo -e "\n"
}

test_colors() {
    # just a simple alias
    test_colors_16
}

test_truecolor() {
  local i r g b
  for ((i = 0; i <= 79; i++)); do
    b=$((i*255/79))
    g=$((2*b))
    r=$((255-b))
    if [[ $g -gt 255 ]]; then
      g=$((2*255 - g))
    fi
    printf -- '\e[48;2;%d;%d;%dm \e[0m' "$r" "$g" "$b"
  done
  printf -- '\n'
}


###############################
#  hr: print horizontal line  #
###############################

# from https://github.com/LuRsT/hr
# modified to turn script into bash function
# Published under The MIT License

# the author's original hr function
function hrline() {
    space_character=$1
    line=''
    columns=$(tput cols)

    for (( i=1; i<columns; i++ ))
    do
        line+="${space_character}"
    done

    echo $line
}

# the author's original hr main script
function hr() {
    if [[ -n $1 ]]; then
        space_string=$1
        string_size=${#space_string};

        for (( char_index=1; char_index<=${string_size}; char_index++ ))
        do
            # for bash/zsh interoperability
            c=$(expr substr $space_string $char_index 1)
            hrline "$c"
        done
    else
        # default: use unicode U+2501
        # for more see: https://en.wikipedia.org/wiki/Box-drawing_character
        hrline "━"
    fi
}

############################################
#  pdf functions (mostly for compression)  #
############################################

# compress pdf files via ghostscript
#  - make sure to have installed tts-mscorefonts-installer
function compresspdf_inplace() {
  # quality settings: /ebook: 150 dpi, /screen: 72dpi
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
      -dDetectDuplicateImages=true \
       -dCompatibilityLevel=1.4 \
      -dPDFSETTINGS=/ebook \
      -sOutputFile=/tmp/out.pdf $1 && cp /tmp/out.pdf $1 && rm /tmp/out.pdf
}

# usage compresspdf infile.pdf outfile.pdf [DPI]
#    DPI:   (optional, default=150)
function compresspdf() {
    if [ $# -lt 2 ]
    then
      echo "usage: compresspdf input.pdf output.pdf [dpi (optional, default=150)]"
      return -1;
    fi

    DPI=${3:-150}
    echo "Compressing with DPI: $DPI"
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
       -dDetectDuplicateImages=true \
       -dCompatibilityLevel=1.4 \
       -dConvertCMYKImagesToRGB=true \
       -dDownsampleColorImages=true \
       -dDownsampleGrayImages=true \
       -dDownsampleMonoImages=true \
       -dColorImageResolution=$DPI \
       -dGrayImageResolution=$DPI \
       -dMonoImageResolution=$DPI \
       -dCompressFonts=true \
       -sOutputFile=$2 $1
}

# Turns pdf into black-and-white, and compresses.
# NOTE:
# needs adaptations for the different parameters, might be slow
# use as hints for snippets, requires playing around with parameters
function pdf_to_bw() {
    if [ $# -lt 2 ]
    then
      echo "usage: compresspdf input.pdf output.pdf [dpi (optional, default=150)]"
      return -1;
    fi

    DPI=${3:-150}
    convert -density $DPI $1 -gravity center \ 
    # cropping not always necessary, can use -fuzz and -trim instead!
    -crop 85%\! \
    # color corrections
    -auto-level -colorspace gray -normalize -contrast-stretch 0.15x0.1 \
    # sharpen helps the thresholding
    -sharpen 0x2.0 \
     # thresholding (local adaptive thresholding in read size, then convert more towards white!)
    -negate -lat 500x500+20% -negate \
    $2
}

function compresspdf_screen() {
  # quality settings: /ebook: 150 dpi, /screen: 72dpi
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
      -dDetectDuplicateImages=true \
      -dPDFSETTINGS=/screen \
      -sOutputFile=/tmp/out.pdf $1 && cp /tmp/out.pdf $1 && rm /tmp/out.pdf
}

# use to aggressively downsample images (eg for notes etc)
# usage:
#    compresspdfimg file.pdf [DPI]
#       [DPI] (optional, default=72)
function compresspdfimg() {
  DPI=${2:-72}
  convert -density $DPI -compress JPEG $1 /tmp/cout.pdf
  compresspdf /tmp/cout.pdf
  cp /tmp/cout.pdf $1
}

function splitpdf() {
  gs -sDEVICE=pdfwrite -dFILTERIMAGE -dFILTERVECTOR -o ${1%%.*}_text.pdf $1
  gs -sDEVICE=pdfwrite -dFILTERTEXT -dFILTERVECTOR -o ${1%%.*}_img.pdf $1
  gs -sDEVICE=pdfwrite -dFILTERTEXT -dFILTERIMAGE -o ${1%%.*}_vec.pdf $1
}

# use gs to split pdf into `images`, `text`, and `vector` graphics
# then rasterizes the vector graphics and combines all three files
# back together
function compressvecpdf() {
  # split into text, images and vector
  mkdir -p /tmp/pdfcomp
  gs -sDEVICE=pdfwrite -dFILTERIMAGE -dFILTERVECTOR -o /tmp/pdfcomp/text.pdf $1
  gs -sDEVICE=pdfwrite -dFILTERTEXT -dFILTERVECTOR -o /tmp/pdfcomp/img.pdf $1
  gs -sDEVICE=pdfwrite -dFILTERTEXT -dFILTERIMAGE -o /tmp/pdfcomp/vec.pdf $1

  # rasterizing vector images at 300 DPI, will be further compressed below
  DPI=72
  convert -density $DPI -quality 100 /tmp/pdfcomp/vec.pdf /tmp/pdfcomp/cvec.pdf
  #convert -density 72 -quality 100 /tmp/pdfcomp/vec*.png /tmp/pdfcomp/cvec.pdf

  # combine images and vector files back together
  pdftk /tmp/pdfcomp/img.pdf multistamp /tmp/pdfcomp/cvec.pdf output /tmp/pdfcomp/imgvec.pdf

  # compress all images
  gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dDetectDuplicateImages=true -dPDFSETTINGS=/ebook -sOutputFile=/tmp/pdfcomp/cimgvec.pdf /tmp/pdfcomp/imgvec.pdf

  # add text backinto combined pdf
  pdftk /tmp/pdfcomp/cimgvec.pdf multistamp /tmp/pdfcomp/text.pdf output /tmp/pdfcomp/all.pdf

  # print stats (via ls sizes)
  ls -lah /tmp/pdfcomp
  cp /tmp/pdfcomp/all.pdf $1
  rm -r /tmp/pdfcomp
}

