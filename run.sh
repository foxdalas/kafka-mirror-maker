#!/bin/bash

set -e

envsubst < /opt/mirrormaker/config.template > /var/run/mirrormaker/config
export KAFKA_OPTS="-javaagent:/opt/jmx-prometheus/jmx_prometheus_javaagent.jar=8080:/opt/jmx-prometheus/kafka-connect.yml"


/opt/bitnami/kafka/bin/connect-mirror-maker.sh /var/run/mirrormaker/config
