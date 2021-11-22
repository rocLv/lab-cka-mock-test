#!/bin/bash
docker pull nginx
kubectl apply -f /root/.kube/step-scripts/3-ns.yaml
kubectl apply -f /root/.kube/step-scripts/3-sf.yaml
until [ `kubectl get pods -A |grep "o3db-1" |wc -l` == '1' ]
do
   sleep 1
   echo > /dev/null  2>&1
done

kubectl get pods -A |grep "o3db-1" |wc -l
