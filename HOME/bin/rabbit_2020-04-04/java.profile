# file: java.bashrc
# created: Brooke Smith 6/6/2004
# purpose: To house Java environment settings

#############################################
# Environment variables
#############################################
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export JAVA_HOME=/Library/Java/Home
export JUNIT_HOME=/Library/site_library/java_thirdparty/junit

#############################################
# Java CLASSPATH
#############################################
export CLASSPATHBASE=/home/site_java

pathAppend $JUNIT_HOME/junit.jar, CLASSPATH
pathAppend . CLASSPATH

# Put my stuff in a central location known to java
pathAppend `javaconfig DefaultClasspath` CLASSPATH

# Chart2D
#export CLASSPATH=$CLASSPATH:$CLASSPATHBASE/Chart2D/Chart2D.jar
#echo Java.profile CLASSPATH: $CLASSPATH
