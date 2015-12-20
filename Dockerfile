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

# Setup Quagga
RUN pip install ipaddr
RUN sed -i 's/\/bin\/cat/more/g' /etc/environment # No idea what this is for
RUN echo 'export VTYSH_PAGER=more' >> /etc/bash.bashrc

COPY start.sh /start.sh

CMD ["/start.sh"]
