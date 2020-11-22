#!/bin/bash
# Test as gnucash when started doesn't have pathAppend() from bin/functions.profile in its environment any more

source /home2/bin/fink.profile
echo pathAppend a b
pathAppend a b
echo echo b
echo $b

# Now testing subversion jira plugin and connection to svnwebclient.  
# Another line and modification
# And another
