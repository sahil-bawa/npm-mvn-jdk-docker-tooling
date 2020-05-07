FROM openjdk:8-slim
##### avoid start of interactive input
ARG DEBIAN_FRONTEND=noninteractive
ARG MAVEN_VERSION=3.5.3
ENV MAVEN_HOME /usr/apache-maven-$MAVEN_VERSION
ARG NODE_VERSION=12.16.2
ENV PATH $PATH:$MAVEN_HOME/bin:/opt/node-v${NODE_VERSION}-linux-x64/bin
RUN apt-get update && \
    ##### Install Python 3
    apt-get install -y --no-install-reccomends curl net-tools build-essential software-properties-common libsqlite3-dev sqlite3 bzip2 \
    libbz2-dev git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy python3-scipy python3-pandas python3-matplotlib \
    && ln -s /usr/bin/python3 /usr/bin/python && rm -rf /var/lib/apt/lists/* && \
    #### Install Maven 3
    curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | gunzip \
    | tar x -C /usr/ \
    && ln -s $MAVEN_HOME /usr/maven && \
    #### Install Node
    cd && \
    curl -Lkvvv https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz -o node-v${NODE_VERSION}-linux-x64.tar.xz && \
    tar -xvf node-v${NODE_VERSION}-linux-x64.tar.xz && \
    mv node-v${NODE_VERSION}-linux-x64 /opt && \
    rm node-v${NODE_VERSION}-linux-x64.tar.xz && \
    npm install -g node-gyp && \
    ## bring in m2-settings.xml
    cd / && \
    ## in case you have an m2 settings file, use it
    #  cp m2-settings.xml $MAVEN_HOME/conf/settings.xml||true && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && apt-get autoclean
# Please add shell/bash commands w/o creating new RUN layers unless absolutely necessary
