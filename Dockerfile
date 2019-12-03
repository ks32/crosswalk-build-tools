FROM       ubuntu:16.04
MAINTAINER Asif Hisam "https://github.com/ks32"

RUN apt-get update

RUN apt-get install -y openssh-server git vim nano software-properties-common python screen sudo locales software-properties-common whiptail bzip2
RUN mkdir /var/run/sshd

# RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /src/depot_tools
# copy old depot_toos instead of latest
ADD depot_tools.tgz /src/depot_tools.tgz
RUN cd /src
RUN tar xvfz depot_tools.tgz 

ENV PATH "$PATH:/src/depot_tools"
ENV DEPOT_TOOLS_UPDATE "0"
RUN git config --global user.name "Asif Hisam" && \
    git config --global user.email "asif@email.com" && \
    git config --global core.autocrlf false && \
    git config --global core.filemode false && \
    git config --global color.ui true


RUN echo 'root:Mrroot12345' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
ADD set /root/set

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
