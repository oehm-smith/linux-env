source ~/.bashrc
export PATH=~/bin:$PATH

if [ -e /Users/boss/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/boss/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export PATH="/Users/bbos/.local/share/solana/install/active_release/bin:$PATH"

[ -s "/Users/bbos/.svm/svm.sh" ] && source "/Users/bbos/.svm/svm.sh"
