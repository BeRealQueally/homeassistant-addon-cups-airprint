FROM ghcr.io/hassio-addons/debian-base:7.6.1

LABEL io.hass.version="1.0" io.hass.type="addon" io.hass.arch="aarch64|amd64"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y \
        cups \
        cups-client \
        cups-filters \
        cups-pdf \
        foomatic-db-compressed-ppds \
        gsfonts \
        gutenprint-locales \
        hp-ppd \
        hpijs-ppds \
        hplip \
        magicfilter \
        openprinting-ppds \
        printer-driver-all \
        printer-driver-brlaser \
        printer-driver-c2050 \
        printer-driver-c2esp \
        printer-driver-cjet \
        printer-driver-cups-pdf \
        printer-driver-dymo \
        printer-driver-escpr \
        printer-driver-foo2zjs \
        printer-driver-fujixerox \
        printer-driver-gutenprint \
        printer-driver-hpcups \
        printer-driver-hpijs \
        printer-driver-m2300w \
        printer-driver-min12xxw \
        printer-driver-pnm2ppa \
        printer-driver-postscript-hp \
        printer-driver-ptouch \
        printer-driver-pxljr \
        printer-driver-sag-gdi \
        printer-driver-splix \
    && apt-get install -y --no-install-recommends \
        sudo \
        locales \
        avahi-daemon \
        libnss-mdns \
        dbus \
        colord \
        gnupg2 \
        lsb-release \
        nano \
        samba \
        bash-completion \
        procps \
        whois \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

EXPOSE 631

RUN chmod a+x /run.sh

CMD ["/run.sh"]
