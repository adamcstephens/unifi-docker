FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 06E85760C0A52C50
RUN echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/unifi.list
RUN apt update && apt -y upgrade && apt -y install openjdk-8-jre-headless unifi wget && apt clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb
RUN dpkg -i dumb-init_*.deb

RUN ln -s /var/lib/unifi /usr/lib/unifi/data
RUN mkdir -vp /var/lib/unifi /var/run/unifi /var/lib/unifi/logs
RUN ln -s /var/lib/unifi/logs /usr/lib/unifi/logs
RUN chown -R nobody:nogroup /usr/lib/unifi && \
    chown -R nobody:nogroup /var/lib/unifi && \
    chown -R nobody:nogroup /var/log/unifi && \
    chown -R nobody:nogroup /var/run/unifi
USER nobody


EXPOSE 8080/tcp 8443/tcp 3478/udp
VOLUME ["/var/lib/unifi"]
WORKDIR /var/lib/unifi

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
