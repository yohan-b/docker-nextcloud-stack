#!/bin/bash
for NETWORK in mailnet mysqlnet reverse-proxy
do
    sudo docker network inspect ${NETWORK} &> /dev/null && continue
    sudo docker network create ${NETWORK}
    sudo docker network inspect ${NETWORK} &> /dev/null || \
    { echo "ERROR: could not create network ${NETWORK}, exiting."; exit 1; }
done

test -f ~/openrc.sh || { echo "ERROR: ~/openrc.sh not found, exiting."; exit 1; }
source ~/openrc.sh
INSTANCE=$(~/env_py3/bin/openstack server show -c id --format value $(hostname))
for VOLUME in nextcloud
do
    mkdir -p /mnt/volumes/${VOLUME}
    if ! mountpoint -q /mnt/volumes/${VOLUME}
    then
         VOLUME_ID=$(/home/yohan/env_py3/bin/openstack volume show ${VOLUME} -c id --format value)
         test -e /dev/disk/by-id/*${VOLUME_ID:0:20} || nova volume-attach $INSTANCE $VOLUME_ID auto
         sleep 3
         sudo mount /dev/disk/by-id/*${VOLUME_ID:0:20} /mnt/volumes/${VOLUME}
         mountpoint -q /mnt/volumes/${VOLUME} || { echo "ERROR: could not mount /mnt/volumes/${VOLUME}, exiting."; exit 1; }
    fi
done

sudo -E bash -c 'docker-compose up -d --build'
