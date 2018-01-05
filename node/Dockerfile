FROM centos:7

MAINTAINER Alberto Rodriguez <alberto.rodriguez@ust-global.com>

ENV http_proxy proxy.tcpsi.es:8080
ENV https_proxy proxy.tcpsi.es:8080
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y ntp
RUN yum install -y wget
RUN wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
RUN yum install -y ambari-server
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