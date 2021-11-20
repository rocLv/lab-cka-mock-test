#!/bin/bash
mkdir /opt/course/14/
touch /opt/course/14/cluster-info
cat <<EOF >/opt/course/14/cluster-info
# How many master nodes are available?
# How many worker nodes are available?
# What is the Pod CIDR of cluster1-worker1?
# What is the Service CIDR?
# Which Networking (or CNI Plugin) is configured and where is its config file?
# Which suffix will static pods have that run on cluster1-worker1?


