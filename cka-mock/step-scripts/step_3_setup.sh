#!/bin/bash
kubectl apply -f 3-ns.yaml 
kubectl apply -f 3-sf.yaml 
echo $?