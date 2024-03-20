#!/bin/bash

usage() {
        echo ""
        echo "A program for quickly creating an Alphafold run"
        echo "Please make sure all required parameters are given"
        echo "Usage: $0 <OPTIONS>"
        echo "Required Parameters:"
        echo "-r <residue count>       residue count (must be 40 or 42)"
        echo "-c <chain cout>          chain count"
        echo ""
        exit 1
}

while getopts ":d:o:f:t:g:r:e:n:a:m:c:p:l:b:" i; do
        case "${i}" in
        r)
                res_count=$OPTARG
        ;;
        c)
                chain_count=$OPTARG
        ;;
        esac
done

if [ "$res_count" != "40" ] && [ "$res_count" != "42" ]; 
then
    usage
fi

dirname=${res_count}r.${chain_count}c

# check if dir ecists
if [ -d ${dirname} ];
then
  echo "${dirname} already exists, terminating..."
  exit 1
fi

# make new directory
mkdir $dirname
mkdir $dirname/$dirname

# copy job submission scripts and previous MSAs
echo "Copying job submissions scripts and MSAs..."
cp -r /scratch/midway3/gideonm/jobs/const/msas/${res_count}r $dirname/$dirname/msas
sed s/REPLACEME/${dirname}-alphafold/g /scratch/midway3/gideonm/jobs/const/alphafold2.3-gpu.sh > ${dirname}/alphafold-submit.sh

echo "Creating Fasta..."
python3 /home/gideonm/scratch/gideonm/jobs/const/scripts/create_fasta.py $res_count $chain_count > $dirname/${res_count}r.${chain_count}c.fasta

echo "use-precomputed-msas is set"
echo "created $dirname"
