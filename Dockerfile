FROM ubuntu:latest

MAINTAINER jharmn

# Starting steam with validate is slow, lets make it an option
ENV CHECKFILES "false"
# Variable to enable RCON, enabled by default
ENV RCON "true"
# Set arkremote password
ENV REMOTEPASSWORD "arkremote"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y install lib32gcc1 wget mono-complete unzip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && mkdir -p /data/ark/backup \
    && useradd -d /data/ark -s /bin/bash --uid 1000 ark \
    && chown -R ark: /data/ark \
    && wget -P /tmp http://arklauncher.sadface.co.uk/Download/Remote/ARKRemote.zip \
    && mkdir /data/arkremote \
    && chown -R ark: /data/arkremote \
    && unzip -d /data/arkremote /tmp/ARKRemote.zip \
    && rm -rf /tmp/* \

EXPOSE 27015/udp 7778/udp
EXPOSE 32330/tcp
EXPOSE 1337/tcp

COPY ARKRemoteConfig.json /data/arkremote/ARKRemoteConfig.json
COPY arkremote.sh /usr/local/bin/ark

USER ark
VOLUME /data/ark
WORKDIR /data/ark
CMD ["/usr/local/bin/ark"]
