FROM debian:stretch-slim

MAINTAINER Adriel Kloppenburg

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -qy --no-install-recommends --no-install-suggests install curl wget gnupg2 \
 && echo "deb http://www.vanbest.org/reprepro/ unstable main contrib non-free" >> /etc/apt/sources.list \
 && wget -qO - http://www.vanbest.org/janpascal/debian-archive-key.asc | apt-key add - \
 && apt-get update \
 && apt-get -qy --no-install-recommends --no-install-suggests install denyhosts-server \
 && apt-get -qy purge wget gnupg2 \
 && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/denyhosts-server/denyhosts-server.log

HEALTHCHECK --interval=5m --timeout=3s --start-period=5s \
  CMD curl -f http://localhost:9911/ || exit 1

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 9911

ENTRYPOINT ["/run.sh"]
