FROM phusion/baseimage
MAINTAINER Ashley Penney <apenney@ntoggle.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV CUMULUSLINUX_VERSION 2.5
ENV QUAGGA_VERSION 0.99.23.1-1+cl2.5+2
ENV CLCMD_VERSION 0.01-cl2.5

RUN apt-get update --fix-missing && apt-get -y upgrade && \
    apt-get -y install python-pip iproute && apt-get -y clean

# Install a custom version of Quagga from Cumulus Networks
RUN curl -o /tmp/quagga.deb http://repo.cumulusnetworks.com/pool/CumulusLinux-${CUMULUSLINUX_VERSION}/main/quagga_${QUAGGA_VERSION}_amd64.deb && dpkg -i /tmp/quagga.deb && rm /tmp/quagga.deb
RUN curl -o /tmp/clcmd.deb http://repo.cumulusnetworks.com/pool/CumulusLinux-${CUMULUSLINUX_VERSION}/main/python-clcmd_${CLCMD_VERSION}_all.deb && dpkg -i /tmp/clcmd.deb && rm /tmp/clcmd.deb

# Setup Quagga
RUN pip install ipaddr
RUN sed -i 's/\/bin\/cat/more/g' /etc/environment # No idea what this is for
RUN echo 'export VTYSH_PAGER=more' >> /etc/bash.bashrc
RUN mkdir /usr/share/cumulus

COPY start.sh /start.sh

CMD ["/start.sh"]
