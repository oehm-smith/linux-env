source /etc/bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/bbos/.nvm/versions/node/v12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /Users/bbos/.nvm/versions/node/v12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/bbos/.nvm/versions/node/v12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /Users/bbos/.nvm/versions/node/v12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /Users/bbos/.nvm/versions/node/v12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.bash ] && . /Users/bbos/.nvm/versions/node/v12.6.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.bash

export PATH=$PATH:$HOME/Library/Python/2.7/bin
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1


PL=~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
[[ -s $PL ]] && source $PL
#. ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh

source ~/.bash_alias
