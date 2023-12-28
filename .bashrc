# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# load all config dot files
for f in ~/.shell/*.sh; do
  source "$f"
done
for f in ~/.shell/*.bash; do
  source "$f"
done

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
