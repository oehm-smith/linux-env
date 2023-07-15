ZSH
====

# https://unix.stackexchange.com/questions/692913/temporarily-disable-history-in-zsh
$ zsh
$ unset HISTFILE
$ echo secret_password
$ ...
$ exit

or

$ zsh
$ fc -p
$ exit

BASH
====

$ bash
$ set -o HISTORY
$ echo secret_password
$ ...
$ exit
