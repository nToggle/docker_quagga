FROM debian:jessie
MAINTAINER Ashley Penney <apenney@ntoggle.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update --fix-missing && apt-get -y upgrade && \
    apt-get -y install python-pip iproute bridge-utils && apt-get -y clean

COPY cumulus.list /etc/apt/sources.list.d/cumulus.list

RUN apt-get update && \
    apt-get -y --allow-unauthenticated install quagga=1.0.0+cl3u11 python-clcmd && \
    apt-get -y clean

# Setup Quagga
RUN pip install -U pip
RUN pip install ipaddr
#RUN sed -i 's/\/bin\/cat/more/g' /etc/environment # No idea what this is for
RUN echo 'export VTYSH_PAGER=more' >> /etc/bash.bashrc

# Start Quagga itself.
COPY start_quagga.sh /start_quagga.sh

RUN mkdir -p /usr/share/cumulus/
CMD ["/start_quagga.sh"]
