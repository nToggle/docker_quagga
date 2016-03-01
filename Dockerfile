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

COPY quagga_0.99.23.1-1+cl2.5+10_amd64.deb /tmp/quagga_0.99.23.1-1+cl2.5+10_amd64.deb
RUN dpkg -i /tmp/quagga_0.99.23.1-1+cl2.5+10_amd64.deb

# Setup Quagga
RUN pip install ipaddr
RUN sed -i 's/\/bin\/cat/more/g' /etc/environment # No idea what this is for
RUN echo 'export VTYSH_PAGER=more' >> /etc/bash.bashrc
# Ubuntu running 1.10.2 dies because of this.
RUN adduser root quaggavty

COPY start.sh /start.sh

CMD ["/start.sh"]
