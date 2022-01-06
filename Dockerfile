FROM ubuntu

RUN apt update
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN DEBIAN_FRONTEND=noninteractive apt install -y git openssh-server openssh-client
RUN DEBIAN_FRONTEND=noninteractive apt install -y rsync augeas-tools runoverssh
RUN DEBIAN_FRONTEND=noninteractive apt install -y vim net-tools

RUN mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    echo "Port 22" >> /etc/ssh/sshd_config && \
    echo >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
