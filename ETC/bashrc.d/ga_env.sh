# Proxy settings not needed on Staff Wifi
#export http_proxy=http://sun-web-intdev.ga.gov.au:2710
#export https_proxy=http://sun-web-intdev.ga.gov.au:2710
SONAR_LOGIN=349534fa2b721cb2b539bba8bff59184f8e4c0f8
export MAVEN_OPTS="$MAVEN_OPTS -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Djavax.net.ssl.trustStore=/Users/brookes/.keystore -Djavax.net.ssl.trustStorePassword=changeit -DSONAR_LOGIN=$SONAR_LOGIN"

