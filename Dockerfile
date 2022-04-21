FROM foxdalas/kafka:3.1.0
USER root

RUN apt-get update
RUN apt-get install -y gettext

ADD configs/config.template /opt/mirrormaker/config.template
ADD ./run.sh /opt/mirrormaker/run.sh
ADD ./connect-mirror-maker.sh /opt/kafka/bin/connect-mirror-maker.sh
ADD configs/exporter.yml /opt/jmx-exporter/kafka-connect.yml
RUN chmod +x /opt/mirrormaker/run.sh
RUN chmod +x /opt/kafka/bin/connect-mirror-maker.sh

RUN mkdir -p /var/run/mirrormaker
RUN chown 1234 /var/run/mirrormaker

ENV TOPICS .*
ENV DESTINATION "source-cluster:9092"
ENV SOURCE "localhost:9092"
ENV REPLICATION_FACTOR 1
ENV ACLS_ENABLED "false"
ENV TASKS_MAX 10


ENTRYPOINT ["/opt/mirrormaker/run.sh"]
