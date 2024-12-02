FROM debian:bookworm AS build

LABEL org.opencontainers.image.authors="Ilya Kogan <ikogan@flarecode.com>"
LABEL org.opencontainers.image.authors="MAINTAINER Alex Lennon <ajlennon@dynamicdevices.co.uk>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y; apt-get install --yes gpg wget
RUN wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key | gpg --dearmor --yes --output "/usr/share/keyrings/openmediavault-archive-keyring.gpg"

# Add the OpenMediaVault repository
COPY openmediavault.list /etc/apt/sources.list.d/

# Fix resolvconf issues with Docker
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections


# Install OpenMediaVault packages and dependencies
RUN apt-get update -y; apt-get install nano openmediavault-keyring postfix locales python-is-python3 -y --force-yes --allow-unauthenticated

RUN apt-get update -y; apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option DPkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install openmediavault

COPY systemctl3.py /usr/bin/systemctl
RUN chmod +x /usr/bin/systemctl

CMD ["/usr/bin/systemctl"]

# We need to make sure rrdcached uses /data for it's data
COPY defaults/rrdcached /etc/default

# Add our startup script last because we don't want changes
# to it to require a full container rebuild
COPY omv-startup /usr/sbin/omv-startup
RUN chmod +x /usr/sbin/omv-startup
COPY sleep.sh /usr/sbin/sleep.sh
RUN chmod +x /usr/sbin/sleep.sh
COPY fake-shared-folders.sh /usr/sbin/fake-shared-folders.sh
RUN chmod +x /usr/sbin/fake-shared-folders.sh

EXPOSE 21:21 443:443 445:445 80:80

VOLUME /data

COPY data-startup.sh /data/startup.sh

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT /usr/sbin/omv-startup
#ENTRYPOINT /usr/sbin/sleep.sh
