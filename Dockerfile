FROM debian:9.2

ENV DEBIAN_FRONTEND noninteractive
ENV IMAGE_NAME debian-base
ENV IMAGE_VERSION 1.0
ENV ROOTPASS=root
LABEL docker.image.name=$IMAGE_NAME
LABEL docker.image.version=$IMAGE_VERSION
STOPSIGNAL SIGTERM

# common basic config

RUN echo "root:${ROOTPASS}" | chpasswd

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    dpkg-reconfigure -f noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install procps wget unzip

# service: ssh

RUN apt-get install -y --no-install-recommends openssh-server
RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# motd

RUN echo "\n\
Welcome inside $IMAGE_NAME $IMAGE_VERSION container.\n\
If you want to use JDK with this container please install it with /root/install-jdkX.sh.\n\
\n\
Working services:\n\
    22 ssh" >> /etc/motd

# copy scripts and run container

COPY resources/bootstrap.sh /
RUN chmod +x /bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]

EXPOSE 22
