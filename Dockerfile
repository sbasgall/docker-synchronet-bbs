FROM ubuntu:14.04
#FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Debian Jessie
#COPY sources.list /etc/apt/sources.list
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install make g++ linux-libc-dev libncurses5-dev libnspr4-dev unzip zip cvs libcap-dev gdb xorg-dev libgtk-3-dev lrzsz gkermit libsdl1.2-dev dosemu

RUN apt-get update &&\
    apt-get -y install \
      software-properties-common &&\
    add-apt-repository multiverse &&\
    apt-get update &&\
    apt-get -y install \
      cvs \
      dosemu \
      g++ \
      gdb \
      gkermit \
      libcap2-dev \
      libncurses5-dev \
      libnspr4-dev \
      linux-libc-dev \
      lrzsz \
      make \
      patch \
      python2.7 \
      unzip \
      wget \
      zip

RUN wget 'http://cvs.synchro.net/cgi-bin/viewcvs.cgi/*checkout*/install/terminfo' &&\
    tic terminfo &&\
    wget 'http://cvs.synchro.net/cgi-bin/viewcvs.cgi/*checkout*/install/termcap' &&\
    cat termcap >> /etc/termcap

RUN useradd -c 'sbbs' -m -d /home/sbbs -s /bin/bash sbbs

USER sbbs
WORKDIR /home/sbbs
RUN wget 'http://cvs.synchro.net/cgi-bin/viewcvs.cgi/*checkout*/install/GNUmakefile' &&\
    make install SYMLINK=1 USE_DOSEMU=1

COPY sbbs.ini /home/sbbs/ctrl/sbbs.ini
COPY services.ini /home/sbbs/ctrl/services.ini

EXPOSE 2323
EXPOSE 2222
EXPOSE 8443
ENV SBBSCTRL /home/sbbs/ctrl
ENV SBBSROOT /home/sbbs
#VOLUME ["/home/sbbs/data", "/home/sbbs/ctrl"]
CMD ["/home/sbbs/exec/sbbs"]
