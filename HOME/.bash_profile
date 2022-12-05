
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -s "/etc/profile.d/git-prompt.sh" ]] && source "/etc/profile.d/git-prompt.sh"

# Powerline (command line prompt) - https://www.freecodecamp.org/news/jazz-up-your-bash-terminal-a-step-by-step-guide-with-pictures-80267554cb22/
# export PATH=$PATH:$HOME/Library/Python/2.7/bin
# In .bashrc now and source at bottom of file
# powerline-daemon -q
# POWERLINE_BASH_CONTINUATION=1
# POWERLINE_BASH_SELECT=1
# 
# 
# PL=~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
# [[ -s $PL ]] && source $PL
#. ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh

# Extras
# Use homebrew version of ruby rather than default MacOSX one (since can't seem to modify it - 
# https://stackoverflow.com/questions/51664716/you-dont-have-write-permissions-for-the-library-ruby-gems-2-3-0-directory)
export PATH="/usr/local/opt/ruby/bin:$PATH"	

# Java
export JAVA_FX=~/lib/javaFx/javafx-sdk
# https://stackoverflow.com/a/47699905/1019307
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
export PATH="$HOME/.jenv/shims:$PATH"

# Other
[[ -s ~/.iterm2_shell_integration.bash ]] && source ~/.iterm2_shell_integration.bash
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "$HOME/.bash_flightcentre" ]] && . "$HOME/.bash_flightcentre"

export LESSOPEN="lessopen.sh %s"
export LESSCLOSE="lessclose.sh %s %s"
export HISTCONTROL=ignoreboth
source ~/.android_bash
source ~/.bashrc

export PATH="/Users/bbos/.local/share/solana/install/active_release/bin:$PATH"
