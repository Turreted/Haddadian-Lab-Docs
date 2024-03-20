#!/bin/bash

inname=$1
outname=$2

if [ $# -ne 2 ]
  then
    echo "./copy-namd-outputs.sh indir outdir..."
    exit 1
fi

echo $inname
echo $outname

for file in $(ls "../NPT1/NPT1.restart.*.old")
do
    $outfile=${file//$restart/}
    $outfile=${outfile//$.old/}
    $outfile=${outfile//$..\/NPT1/}
    cp $file $outfile
done
