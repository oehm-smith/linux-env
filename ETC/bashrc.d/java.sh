#!/bin/bash

# http://www.onehippo.com/en/resources/blogs/2013/09/The+mystery+of+the+Bootstrap+application+during+a+Maven+build+on+Mac+OS_x0020_.html
# Specifically the java.awt.headless stops surefire starting an app called ForkedBooter, which steals the focus.

#### MMMMM, see profile.d/env.sh
export MAVEN_OPTS="$MAVEN_OPTS -Xms256m -Xmx512m -XX:PermSize=64m -XX:MaxPermSize=256m -Djava.awt.headless=true"

# JAVA_HOME=/opt/java/current
JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH

