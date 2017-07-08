alias dirs='dirs -v'
alias ls='ls -G'
alias l='ls -la'
alias ll='ls -latr'
# Use this to find external ip.  Good to know if VPN is working.
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
# Use this one to run on rabbit
alias waniprabbit="ssh rabbit 'dig +short myip.opendns.com @resolver1.opendns.com'"
alias grep="grep --color"
alias git-gui='/usr/local/Cellar/git/2.12.2/share/git-gui/lib/Git\ Gui.app/Contents/MacOS/Wish'
alias showDotFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideDotFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
