# ImConfig.py (c) 2015 Canonical
# Author: Gunnar Hjalmarsson <gunnarhj@ubuntu.com>
#
# Released under the GPL
#
# File: /etc/profile.d/cedilla-brazil.sh
# 
# The desired behavior when typing in certain languages is that
# '+c results in the ç character, and not ć. In Portuguese this
# can be achieved by setting LC_CTYPE to pt_BR.UTF-8.
# Related file:
# /usr/share/X11/locale/pt_BR.UTF-8/Compose
#
# When the selected display language is Brazilian Portuguese,
# LC_CTYPE inherits the desired value from LANG. Due to this
# file, setting the Regional Formats value to Brazilian Portuguese
# is sufficient to enable the just mentioned desired behavior,
# even if the display language is something else but Brazilian
# Portuguese.
#
if [ -n $LC_IDENTIFICATION ] && [ "${LC_IDENTIFICATION%.*}" = 'pt_BR' ]; then
    export LC_CTYPE="$LC_IDENTIFICATION"
fi
