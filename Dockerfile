FROM debian:buster-slim

MAINTAINER Adriel Kloppenburg

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
 && apt -qy --no-install-recommends --no-install-suggests install curl gnupg2 \
 && echo "deb http://www.vanbest.org/reprepro/ unstable main contrib non-free" >> /etc/apt/sources.list \
 && curl http://www.vanbest.org/janpascal/debian-archive-key.asc | apt-key add - \
 && apt update \
 && apt -qy --no-install-recommends --no-install-suggests install denyhosts-server \

RUN ln -sf /dev/stdout /var/log/denyhosts-server/denyhosts-server.log

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 9911

ENTRYPOINT ["/run.sh"]
