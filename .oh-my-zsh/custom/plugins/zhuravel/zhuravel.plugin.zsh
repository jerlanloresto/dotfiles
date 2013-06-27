p() { cd ~/Projects/$1; }
_p() { _files -W ~/Projects -/; }
compdef _c c

h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# autocorrect is more annoying than helpful
unsetopt correct_all

# command line history
bindkey '^R' history-incremental-search-backward

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"

# a few aliases I like
alias ptt='rake parallel:test'
alias pts='rake parallel:spec'
alias combo='rake db:migrate parallel:migrate db:schema:dump'
alias mysql='mysql -u root'
alias mysql-dir='cd /usr/local/var/mysql/'
alias psql='psql -U bohdan postgres'
alias redis-status='redis-cli ping'
for dbname in mysql postgresql couchdb redis; do
  eval "${dbname}-start() { launchctl load ~/Library/LaunchAgents/homebrew.mxcl.${dbname}.plist }"
  eval "${dbname}-stop() { launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.${dbname}.plist }"
done

# who is listening on a given TCP port?
# $ onport 5984
# $ onport 5984 --pid
onport() {
  if [ $# -eq 2 ]; then
    lsof -i TCP:$1 -t
  else
    lsof -i TCP:$1 | grep LISTEN
  fi
}

# helps me figure out what I can delete to free some space on SSD
find_large_files() {
  if [ ! -z $1 ]; then
    sudo find $1 -type f -size +${2:-100M} -exec du -h {} \; 2> /dev/null
  else
    echo "Usage: find_large_files /path 100M"
  fi
}