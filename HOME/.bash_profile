
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -s "/etc/profile.d/git-prompt.sh" ]] && source "/etc/profile.d/git-prompt.sh"

# Powerline (command line prompt) - https://www.freecodecamp.org/news/jazz-up-your-bash-terminal-a-step-by-step-guide-with-pictures-80267554cb22/
export PATH=$PATH:$HOME/Library/Python/2.7/bin
which powerline-daemon
if [[ $? -eq 0 ]]; then
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1

	PL=~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
	[[ -s $PL ]] && source $PL
	#. ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
fi
