FROM debian:jessie
MAINTAINER Tobias Lindholm <tobias.lindholm@antob.se>

# Set the time zone
ENV TZ Europe/Stockholm
RUN echo "Europe/Stockholm" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y cron vim postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
ADD backups-cron /etc/cron.d/backups-cron

# Forward cron logs to docker log collector
RUN ln -sf /dev/stdout /var/log/cron.log

ADD backups.sh /backups.sh
ADD start.sh /start.sh

CMD ["/start.sh"]
