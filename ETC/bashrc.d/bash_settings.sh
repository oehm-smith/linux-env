set -o vi
# http://askubuntu.com/questions/15926/how-to-avoid-duplicate-entries-in-bash-history
# https://superuser.com/questions/324874/execute-a-terminal-command-without-saving-it-to-bash-history-on-os-x
export HISTCONTROL=ignorespace:ignoreboth:erasedups
export TERM="xterm-256color"    # Tmux sets to "screen"
