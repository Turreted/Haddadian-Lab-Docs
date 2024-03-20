#!/bin/bash

input_dir=$1
data_dir=${input_dir}/${input_dir}

filecount=$(ls ${data_dir}/ranked_* | wc -l)

if [ $((filecount)) == 0 ]; then
  echo "Alphafold Job is not run"
  exit 1
fi

echo "backing up to submitted archive..."
cp -r $input_dir /home/gideonm/scratch/gideonm/submitted-archive

echo "Seperating data from metadata..."
mkdir ${input_dir}/metadata
mv ${data_dir}/*.pkl ${data_dir}/unrelaxed* ${data_dir}/msas ${input_dir}/metadata

echo "Moving essential data to box..."
mv $data_dir /home/gideonm/scratch/gideonm/box/multimer

rm -r $input_dir