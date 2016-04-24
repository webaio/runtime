#!/bin/bash

CONF=/usr/local/flink/conf
EXEC=/usr/local/flink/bin

sed -i -e "s/%nb_slots%/`nproc`/g" $CONF/flink-conf.yaml
sed -i -e "s/%parallelism%/1/g" $CONF/flink-conf.yaml

if [ "$1" = "jobmanager" ]; then
    echo "Configuring Job Manager on this node"
    sed -i -e "s/%jobmanager%/`hostname -i`/g" $CONF/flink-conf.yaml
    $EXEC/jobmanager.sh start cluster

elif [ "$1" = "taskmanager" ]; then
    echo "Configuring Task Manager on this node"
    sed -i -e "s/%jobmanager%/$JOBMANAGER_PORT_6123_TCP_ADDR/g" $CONF/flink-conf.yaml
    $EXEC/taskmanager.sh start
fi

echo "config file: " && cat $CONF/flink-conf.yaml

echo "export JAVA_HOME=/usr/java/default;" >> ~/.profile
echo "export PATH=$PATH:$JAVA_HOME/bin;" >> ~/.profile
echo "export F=/usr/local/flink/;" >> ~/.profile
echo 'export FLINK_SSH_OPTS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"' >> ~/.profile

/usr/sbin/sshd && tail -f /dev/null
