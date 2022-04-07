FROM bitnami/kafka:2.8
USER root
RUN install_packages gettext

ARG jmx_prometheus_version="0.16.1"

ADD configs/config.template /opt/mirrormaker/config.template
ADD ./run.sh /opt/mirrormaker/run.sh
RUN mkdir -p /opt/jmx-prometheus
RUN curl -o /opt/jmx-prometheus/jmx_prometheus_javaagent.jar  https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$jmx_prometheus_version/jmx_prometheus_javaagent-$jmx_prometheus_version.jar 
ADD configs/exporter.yml /opt/jmx-prometheus/kafka-connect.yml
RUN chmod +x /opt/mirrormaker/run.sh

RUN mkdir -p /var/run/mirrormaker
RUN chown 1234 /var/run/mirrormaker

ENV TOPICS .*
ENV DESTINATION "source-cluster:9092"
ENV SOURCE "localhost:9092"
ENV REPLICATION_FACTOR 1
ENV ACLS_ENABLED "false"
ENV TASKS_MAX 10


USER 1234
CMD /opt/mirrormaker/run.sh
