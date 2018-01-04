FROM centos:7

MAINTAINER Alberto Rodriguez <alberto.rodriguez@ust-global.com>

ENV http_proxy proxy.tcpsi.es:8080
ENV https_proxy proxy.tcpsi.es:8080
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

COPY scripts/start.sh /start.sh

ENTRYPOINT ["/start.sh"]