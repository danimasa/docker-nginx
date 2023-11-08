FROM ubuntu

MAINTAINER "Daniel Masarin" <daniel.masarin@gmail.com>

WORKDIR /tmp

# Install prerequisites for Nginx compile
RUN apt-get update -y && \
	apt-get install -y \
        nginx \
	certbot \
	python3-certbot-nginx \
	cron

# Configure filesystem to support running Nginx

# Apply Nginx configuration
ADD config/nginx.conf /etc/nginx/nginx.conf

# This script gets the linked PHP-FPM container's IP and puts it into
# the upstream definition in the /etc/nginx/nginx.conf file, after which
# it launches Nginx.
ADD config/nginx-start.sh /opt/bin/nginx-start.sh
RUN mkdir -p /var/lib/nginx
RUN chmod u=rwx /opt/bin/nginx-start.sh

# DATA VOLUMES
RUN mkdir -p /data
VOLUME ["/data"]

# PORTS
EXPOSE 80
EXPOSE 443

WORKDIR /opt/bin
ENTRYPOINT ["/opt/bin/nginx-start.sh"]
