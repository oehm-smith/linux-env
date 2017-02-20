source ~/.bashrc
export PATH=~/bin:$PATH

if [ -e /Users/boss/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/boss/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
