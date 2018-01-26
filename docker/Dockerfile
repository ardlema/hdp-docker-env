FROM centos:7

MAINTAINER Alberto Rodriguez <alberto.rodriguez@ust-global.com>

RUN yum install -y sudo && \
    adduser hortonworks && \
    echo "hortonworks ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/hortonworks && \
    chmod 0440 /etc/sudoers.d/hortonworks

RUN su - hortonworks -c "touch mine"
CMD ["su", "-", "hortonworks", "-c", "/bin/bash"]
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y java-1.8.0-openjdk-devel
RUN yum install -y ntp
RUN yum install -y wget
RUN yum install -y unzip
RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O /usr/share/java/postgresql-jdbc.jar
RUN chmod 644 /usr/share/java/postgresql-jdbc.jar

RUN wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
RUN yum install -y ambari-server
RUN yum install -y ambari-agent
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN yum install -y mysql-connector-java
RUN yum install -y snappy
RUN ssh-keygen -A -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN cp /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/authorized_keys
RUN ssh-keygen -t rsa -f /hortonworks/.ssh/id_rsa -N ''
RUN cp /hortonworks/.ssh/id_rsa.pub /hortonworks/.ssh/authorized_keys
RUN chmod 600 /etc/ssh/authorized_keys
RUN chmod 600 /hortonworks/.ssh/authorized_keys
RUN /usr/sbin/sshd

COPY scripts/start.sh /start.sh

EXPOSE 22 8080

ENTRYPOINT ["/start.sh"]