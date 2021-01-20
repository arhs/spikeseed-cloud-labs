FROM amazonlinux:2

RUN set -ex \
    && yum install -y gcc glibc-devel zlib-devel tar gzip unzip

ENV JAVA_HOME="/opt/graalvm" \
    GRAALVM_HOME="/opt/graalvm" \
    GRAALVM_VERSION=20.3.0 \
    GRAALVM_DOWNLOAD_SHA256="557aafd6f4fb8c103ce853adda452a7dc3eeca2ef1af00940b70efafe00fb3d5" \
    MAVEN_HOME="/opt/maven" \
    MAVEN_VERSION=3.6.3 \
    MAVEN_DOWNLOAD_SHA512="c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0"

ARG MAVEN_CONFIG_HOME="/root/.m2"

RUN set -ex \
    # Install GraalVM - https://github.com/graalvm/graalvm-ce-builds/releases
    && mkdir -p $JAVA_HOME \
    && curl -LSso /var/tmp/graalvm-ce-java11-linux-amd64-$GRAALVM_VERSION.tar.gz https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-java11-linux-amd64-$GRAALVM_VERSION.tar.gz \
    && echo "$GRAALVM_DOWNLOAD_SHA256 /var/tmp/graalvm-ce-java11-linux-amd64-$GRAALVM_VERSION.tar.gz" | sha256sum -c - \
    && tar xzvf /var/tmp/graalvm-ce-java11-linux-amd64-$GRAALVM_VERSION.tar.gz -C $JAVA_HOME --strip-components=1 \
    && rm /var/tmp/graalvm-ce-java11-linux-amd64-$GRAALVM_VERSION.tar.gz \
    && for tool_path in $JAVA_HOME/bin/*; do \
          tool=`basename $tool_path`; \
          update-alternatives --install /usr/bin/$tool $tool $tool_path 10000; \
          update-alternatives --set $tool $tool_path; \
        done \
    # Install GraalVM Native image
    && $GRAALVM_HOME/bin/gu install native-image

RUN set -ex \
    # Install Maven - https://downloads.apache.org/maven/maven-3/
    && mkdir -p $MAVEN_HOME \
    && curl -LSso /var/tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz https://apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && echo "$MAVEN_DOWNLOAD_SHA512 /var/tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz" | sha512sum -c - \
    && tar xzvf /var/tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C $MAVEN_HOME --strip-components=1 \
    && rm /var/tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && update-alternatives --install /usr/bin/mvn mvn /opt/maven/bin/mvn 10000 \
    && mkdir -p $MAVEN_CONFIG_HOME

RUN set -ex \
    # Install AWS CLI V2
    && curl -LSso /var/tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip -q /var/tmp/awscliv2.zip -d /var/tmp \
    && ./var/tmp/aws/install -b /usr/bin \
    && rm /var/tmp/awscliv2.zip
