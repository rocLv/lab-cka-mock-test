#!/bin/bash
docker stop $1 && docker rm $1
cp /root/lab-shell/cka-mock/run_template /root/lab-shell/cka-mock/run
sed -i '2i\name='$1  /root/lab-shell/cka-mock/run
docker run --name $1 \
-v /root/lab-shell/cka-mock:/data \
-v /var/run/docker.sock:/var/run/docker.sock \
-d \
hub.study.netlearning.tech/kind:latest
docker exec $1 sh /data/run
