FROM gitlab/gitlab-runner:latest

ENV GRADLE_VERSION 3.4.1
ENV SONAR_SCANNER_VERSION 3.1.0.1141

USER root
# Installing JAVA #

RUN \
        echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
        apt-get update && \
        apt-get install -y software-properties-common && \
        add-apt-repository -y ppa:webupd8team/java && \
        apt-get update && \
        apt-get install -y oracle-java8-installer


# Installing tools #
RUN \
        apt-get update -y && \
        apt-get upgrade -y && \
        apt-get install -y wget unzip && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
RUN mkdir /temp
WORKDIR /temp


# Gradle #
RUN \
        wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
        mkdir /opt/gradle && \
        unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip
ENV PATH="${PATH}:/opt/gradle/gradle-${GRADLE_VERSION}/bin"


# Sonar Scanner #
RUN \
        wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
        mkdir /opt/sonarscanner && \
        unzip -d /opt/sonarscanner sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip
ENV PATH="${PATH}:/opt/sonarscanner/sonar-scanner-${SONAR_SCANNER_VERSION}/bin"


# Node #
RUN \
        curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - && \
        apt-get install -y nodejs

# Yarn #
RUN \
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
        apt-get update && \
        sudo apt-get install yarn


# cleanup mess #
WORKDIR /
RUN \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /var/cache/oracle-jdk8-installer && \
        rm -rf /temp
