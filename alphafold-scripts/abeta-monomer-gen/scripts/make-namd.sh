#!/bin/bash

dirname=$1

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, exiting..."
    exit 1
fi

mkdir $dirname
mkdir ${dirname}/NPT1
mkdir ${dirname}/NPT2

cp /scratch/midway3/gideonm/namd/const/implicit-NPT1.conf ${dirname}/NPT1/NPT1.conf
cp /scratch/midway3/gideonm/namd/const/implicit-NPT2-2fs.conf ${dirname}/NPT2/NPT2.conf

cp /scratch/midway3/gideonm/namd/const/job-submit.sh ${dirname}/NPT1/
cp /scratch/midway3/gideonm/namd/const/job-submit.sh ${dirname}/NPT2/
