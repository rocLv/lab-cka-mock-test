#!/bin/bash
set -e

# 脚本中必须使用绝对路径！！！

WHITE='\033[0;97m'       # White
YELLOW='\033[0;93m' 
RED='\033[0;91m'
GREEN='\033[0;92m' 

CLUSTER_MASTERS=('cn-lab-master1') 
CLUSTER_WORKERS=('cn-lab-worker1')

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
