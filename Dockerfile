FROM jboss/base-jdk:8
MAINTAINER Stephen Kolar <stephen.kolar@hpe.com>

ENV SONAR_VERSION=6.0 \
    SONARQUBE_HOME=/opt/sonarqube

USER root
EXPOSE 9000
RUN cd /tmp \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && cd /opt \
    && unzip /tmp/sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm /tmp/sonarqube.zip*
COPY run.sh $SONARQUBE_HOME/bin/

RUN sed -i "s|#http.proxyHost=|http.proxyHost=proxy.hud.gov |g" $SONARQUBE_HOME/conf/sonar.properties \
    && sed -i "s|#http.proxyPort=|http.proxyPort=8080 |g" $SONARQUBE_HOME/conf/sonar.properties \
    && sed -i "s|#https.proxyHost=|https.proxyHost=proxy.hud.gov |g" $SONARQUBE_HOME/conf/sonar.properties \
    && sed -i "s|#https.proxyPort=|https.proxyPort=8443 |g" $SONARQUBE_HOME/conf/sonar.properties
  
RUN useradd -r sonar
RUN chown -R sonar $SONARQUBE_HOME \
    && chgrp -R 0 $SONARQUBE_HOME \
    && chmod -R g+rw $SONARQUBE_HOME \
    && find $SONARQUBE_HOME -type d -exec chmod g+x {} + \
    && chmod 775 $SONARQUBE_HOME/bin/run.sh

USER sonar
WORKDIR $SONARQUBE_HOME
CMD ["echo $http_proxy"]
