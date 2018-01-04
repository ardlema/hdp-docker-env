FROM centos:7

MAINTAINER Alberto Rodriguez <alberto.rodriguez@ust-global.com>

ENV http_proxy proxy.tcpsi.es:8080
ENV https_proxy proxy.tcpsi.es:8080
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN ssh-keygen -A -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN cp /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/authorized_keys
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /etc/ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN /usr/sbin/sshd

COPY scripts/start.sh /start.sh

EXPOSE 22

ENTRYPOINT ["/start.sh"]