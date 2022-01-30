FROM ubuntu:20.04

ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

RUN apt-get update && apt-get install -y ssh rsync openjdk-11-jdk
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz
RUN tar -xzf hadoop-3.3.1.tar.gz
RUN mv hadoop-3.3.1 $HADOOP_HOME 
RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys

ADD configs/*xml $HADOOP_HOME/etc/hadoop/
ADD configs/ssh_config /root/.ssh/config
ADD bootstrap.sh bootstrap.sh

EXPOSE 8088 50070 50075 50030 50060

CMD bash bootstrap.sh
