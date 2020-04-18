FROM bde2020/hadoop-base:2.0.0-hadoop3.1.2-java8

ARG HIVE_VERSION
ENV HIVE_VERSION=${HIVE_VERSION:-3.1.2}

ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH

WORKDIR /opt

RUN apt-get update && apt-get install -y wget procps
RUN wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz
RUN mv apache-hive-$HIVE_VERSION-bin hive
RUN rm apache-hive-$HIVE_VERSION-bin.tar.gz
RUN apt-get --purge remove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

COPY conf/hive-site.xml $HIVE_HOME/conf
COPY conf/hive-env.sh $HIVE_HOME/conf
COPY startup.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 10000
EXPOSE 10002

# ENTRYPOINT ["entrypoint.sh"]
# CMD startup.sh