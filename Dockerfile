FROM tomcat:7
USER root

ADD https://github.com/HCL-TECH-SOFTWARE/AltoroJ/releases/download/v3.4/altoromutual.war /usr/local/tomcat/webapps
EXPOSE 8080

CMD /usr/local/tomcat/bin/catalina.sh run

FROM ubuntu:kinetic

LABEL maintainer "Ram Gopinathan"

ARG SONARQUBE_SCANNER_CLI_VERSION="4.6.0.2311"

ENV SONARQUBE_SCANNER_HOME /opt/sonar-scanner-${SONARQUBE_SCANNER_CLI_VERSION}-linux
ENV SONARQUBE_SCANNER_BIN ${SONARQUBE_SCANNER_HOME}/bin
ENV SONAR_SCANNER_CLI_DOWNLOAD_URL "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARQUBE_SCANNER_CLI_VERSION}-linux.zip"

RUN apt-get update \
	&& apt-get -y upgrade \
	&& apt-get install -y ca-certificates \
	&& update-ca-certificates \
	&& apt-get install -y openjdk-11-jdk-headless tzdata curl unzip bash \
	&& rm -rf /var/cache/apt/* \
    && mkdir -p /tmp/sonar-scanner  \
	&& curl -L --silent ${SONAR_SCANNER_CLI_DOWNLOAD_URL} >  /tmp/sonar-scanner/sonar-scanner-cli-${SONARQUBE_SCANNER_CLI_VERSION}-linux.zip  \
    && mkdir -p /opt  \
	&& unzip /tmp/sonar-scanner/sonar-scanner-cli-${SONARQUBE_SCANNER_CLI_VERSION}-linux.zip -d /opt  \
	&& rm -rf /tmp/sonar-scanner


ENV PATH $PATH:$SONARQUBE_SCANNER_BIN

COPY launch.sh /

WORKDIR ${SONARQUBE_SCANNER_HOME}

ENTRYPOINT ["/launch.sh"]
