FROM phusion/baseimage
MAINTAINER Ashley Penney <apenney@ntoggle.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV CUMULUSLINUX_VERSION 2.5

RUN apt-get update --fix-missing && apt-get -y upgrade && \
    apt-get -y install python-pip iproute bridge-utils && apt-get -y clean

COPY cumulus.list /etc/apt/sources.list.d/cumulus.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FF5F9260CC1FE3E2

RUN apt-get update && \
    apt-get -y --allow-unauthenticated install quagga python-clcmd && \
    apt-get -y clean

# Temporary workaround for timing bug.  DEBUG release.
#COPY quagga_0.99.23.1-1+cl2.5+10_amd64.deb /tmp/quagga_0.99.23.1-1+cl2.5+10_amd64.deb
#RUN dpkg -i /tmp/quagga_0.99.23.1-1+cl2.5+10_amd64.deb

# Setup Quagga
RUN pip install ipaddr
RUN sed -i 's/\/bin\/cat/more/g' /etc/environment # No idea what this is for
RUN echo 'export VTYSH_PAGER=more' >> /etc/bash.bashrc

# Start Quagga itself.
COPY start_quagga.sh /etc/my_init.d/00-start_quagga.sh

# Start the custom Cumulus cl-cmd service.
RUN mkdir /etc/service/clcmd
RUN mkdir /usr/share/cumulus/
ADD start_clcmd.sh /etc/service/clcmd/run

CMD ["/sbin/my_init"]
