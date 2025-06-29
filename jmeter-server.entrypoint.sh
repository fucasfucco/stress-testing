#!/bin/bash

echo "Starting JMeter Worker with IP: $(hostname -i) and VM_ARGS: $JVM_ARGS"

# Configurações de rede e desempenho
jmeter-server \
    -Dserver_port=1099 \
    -Dserver.rmi.localport=50000 \
    -Djmeter.server.rmi.localport=60000 \
    -Djava.rmi.server.hostname=$(hostname -i) \
    -Djmeterengine.remote.system.exit=false
