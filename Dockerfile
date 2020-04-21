FROM sapmachine:latest

#### copy context if necessary
# use COPY

##### avoid start of interactive input
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION=${JAVA_VERSION:-8}
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV MAVEN_VERSION 3.5.3
ENV MAVEN_HOME /usr/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
ENV NODE_VERSION 12.16.2
ENV PATH ${PATH}:/opt/node-v${NODE_VERSION}-linux-x64/bin
ARG OPENJDK_PACKAGE=${OPENJDK_PACKAGE:-openjdk-${JAVA_VERSION}-jdk}
ARG OPENJDK_INSTALL_LIST="${OPENJDK_PACKAGE} ${OPENJDK_SRC}"

##### update OS and Install Python 3
RUN apt-get update \
	&& apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev \
	&& apt-get install -y curl net-tools build-essential software-properties-common libsqlite3-dev sqlite3 bzip2 libbz2-dev git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy python3-scipy python3-pandas python3-matplotlib \
	&& ln -s /usr/bin/python3 /usr/bin/python \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* && \
	#### Override system JDK to JDK8 for compatibility reasons
	apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

RUN apt-get update -y && \
    apt-get install -y ${OPENJDK_INSTALL_LIST} && \
    rm -rf /var/lib/apt/lists/* && \
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
	update-alternatives --query java | grep -q 'Status: manual' && \
	
	#### Install Maven 3
	curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
	| gunzip \
	| tar x -C /usr/ \
	&& ln -s $MAVEN_HOME /usr/maven && \
	
	#### Install Node
	cd &&\
	curl -Lkvvv https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz -o node-v${NODE_VERSION}-linux-x64.tar.xz &&\
	tar -xvf node-v${NODE_VERSION}-linux-x64.tar.xz &&\
	mv node-v${NODE_VERSION}-linux-x64 /opt &&\
	rm node-v${NODE_VERSION}-linux-x64.tar.xz && \
	
	#### Update everything
	apt-get update -y && \
	npm install -g node-gyp && \
	
	# bring in m2-settings.xml
	pwd && \
	ls && \
	cd / && \
	cp m2-settings.xml $MAVEN_HOME/conf/settings.xml||true

# Please add shell/bash commands w/o creating new RUN layers unless absolutely necessary
