#!/usr/bin/env bash

# grab the pod id to stop and then stop it
pod_id=$(sudo rkt list | tail -n +2 | head -n -1 | awk '{print $1}')
sudo rkt stop $pod_id

# remove stopped pods for a pristine system
sudo rkt gc --grace-period=0s

# clean up the consul data so the next run doesn't have conflicts
sudo rm -r /consul/*