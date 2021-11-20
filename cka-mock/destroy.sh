#!/bin/bash
set -e

# 脚本中必须使用绝对路径！！！

WHITE='\033[0;97m'       # White
YELLOW='\033[0;93m' 
RED='\033[0;91m'
GREEN='\033[0;92m' 

CLUSTER_MASTERS=('cluster1-master1' 'cluster2-master1' 'cluster3-master1') 
CLUSTER_WORKERS=('cluster1-worker1' 'cluster1-worker2' 'cluster2-worker1' 'cluster3-worker1' 'cluster3-worker2')

MASTER_IMAGE='roclv/k8s-master'
WORKER_IMAGE='roclv/k8s'

stop_container () {
  if [  "$(docker ps -q -f name=${1}$)" ]; then
    echo -e "${RED}Stoping $1 ${WHITE}"
    docker stop $1
  fi

  if [ "$(docker ps -aq -f status=exited -f name=${1}$)" ]; then
    echo -e "${RED}Removing $1 ${WHITE}"
    docker rm $1
  fi
}

stop_container $1

for cluster in "${CLUSTER_MASTERS[@]}"
do
  echo -e "${YELLOW}Removing$1-$cluster ${WHITE}"
  stop_container $1-$cluster
done

for worker in "${CLUSTER_WORKERS[@]}"
do
  echo -e "${YELLOW}Removing $worker ${WHITE}"
  stop_container $1-$worker
done

echo -e "${GREEN} Destroied $1 containers successfully! ${WHITE}"
