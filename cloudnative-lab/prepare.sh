#!/bin/bash
set -e

WHITE='\033[0;97m'       # White
YELLOW='\033[0;93m' 
RED='\033[0;91m'
GREEN='\033[0;92m' 
# 脚本中必须使用绝对路径！！！
if [[ $(docker ps | wc -l) -gt 15 ]]
then
  echo -e "${RED}Too much containers $(docker ps | wc -l) running...${WHITE}"
  echo -e "${RED}异常退出！${WHITE}"
  exit 1
fi


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

create_container () {
  stop_container $1

  echo -e "${YELLOW}Starting $1 ${WHITE}"

  docker run -d --name $1 --privileged $2
}

get_join_token () {
  docker exec $1 kubeadm token create --print-join-command
}

join_cluster () {
  docker exec $1 $(docker exec $2 kubeadm token create --print-join-command)
}

test_master_initialized () {
  docker exec $1 kubectl get nodes
  return $?
}

for cluster in "${CLUSTER_MASTERS[@]}"
do
  echo -e "${YELLOW}Creating $1 ${WHITE}"
  create_container $1 $MASTER_IMAGE
done

for worker in "${CLUSTER_WORKERS[@]}"
do
  echo -e "${YELLOW}Creating $worker ${WHITE}"
  create_container $1-$worker $WORKER_IMAGE
done

MASTER1=$1
C1WORKER1=$1-cn-lab-worker1

echo -e "${YELLOW} $C1WORKER1 joining in master $MASTER1 ${WHITE}"
until docker exec $MASTER1 kubectl get nodes &> /dev/null
do
  sleep 1
  echo -n ...
done
join_cluster $C1WORKER1 $MASTER1

echo -e "${GREEN} Success! $1 ${WHITE}"
