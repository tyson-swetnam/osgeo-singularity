#!/bin/bash
# Ubuntu 17.04 Zesty
# testing new  build

# install debootstrap
sudo apt-get install debootstrap

TS=`date +'%Y%m%d'`
BASENAME="eemt-v$TS"

rm -f $BASENAME.img
singularity build $BASENAME.simg Singularity
