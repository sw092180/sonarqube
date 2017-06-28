FROM jboss/base-jdk:8
MAINTAINER Stephen Kolar <stephen.kolar@hpe.com>

ENV SONAR_VERSION=6.0 \
    SONARQUBE_HOME=/opt/sonarqube

USER root
EXPOSE 9000
ADD root /
RUN cd /tmp \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && cd /opt \
    && unzip /tmp/sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm /tmp/sonarqube.zip*
COPY run.sh $SONARQUBE_HOME/bin/

RUN sed -i "s|#http.proxyHost=|http.proxyHost=170.97.167.20 |g" $SONARQUBE_HOME/conf/sonar.properties \
    && sed -i "s|#http.proxyPort=|http.proxyPort=8080 |g" $SONARQUBE_HOME/conf/sonar.properties \
    && sed -i "s|#https.proxyHost=|https.proxyHost=170.97.167.20 |g" $SONARQUBE_HOME/conf/sonar.properties \
    && sed -i "s|#https.proxyPort=|https.proxyPort=8443 |g" $SONARQUBE_HOME/conf/sonar.properties
  
RUN chmod 777 /usr/bin/fix-permissions
  
RUN useradd -r sonar
RUN /usr/bin/fix-permissions /opt/sonarqube \
    && chmod 775 $SONARQUBE_HOME/bin/run.sh

USER sonar
WORKDIR $SONARQUBE_HOME
ENTRYPOINT ["./bin/run.sh"]
