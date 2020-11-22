#!/bin/sh
# Brooke Smith 22nd January 2005
# Now using Apache2 installed under /sw (ie through Fink)
#export APACHE_DIR=/System/Library/Apache
#export APACHE_HOME=/usr/local/apache2
#pathAppend $APACHE_HOME/bin
# BS 2008 09 19 - start again.  Now will have apache Documents, httpd and CGI-Executables under vc at ~/lib/apache
#		and this will be used as the resource for setting installation specific variables
export APACHE_HOME=/usr/local/apache2
export DOCUMENT_ROOT=/Library/WebServer/Documents
export HTTPDDIR=/etc/httpd
export SERVERADMIN=brooke@tintuna.com
export SERVERNAME=tintuna
export LOGDIR=/var/log/httpd
export SCRIPTDIR=/Library/WebServer/CGI-Executables
export ICONDIR=/Library/Documents/icons
export APACHEMAN=/Library/Documents/manual
export USERDIR=public_html
