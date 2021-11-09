#!/bin/bash
docker stop $1 && docker rm $1
cp run_template run
sed -i '2i\name='$1  run
docker run --name $1 \
-v /root/lab-shell/dubbo-go:/data \
-v /var/run/docker.sock:/var/run/docker.sock \
-d \
hub.study.netlearning.tech/kind:latest
docker exec $1 sh /data/run
