#!/bin/bash

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

while getopts ":hr:" option; do
  case ${option} in
  h) echo 'Usage: processRef.sh -r <reference>'
     echo 'Creates an index, a sequence dictionary, and a bed file for the reference'
     exit 0;;
  r) REF=${OPTARG};;
  esac
done
shift "$((OPTIND -1))"

if [[ -f ${REF} ]]
then
  echo "Found ${REF}"
else
  echo "Reference not found"
  exit 0
fi

refDir="$(dirname $REF)"

python ${scriptDir}/createBed.py ${REF} ${refDir}/ref.bed

refPrefix=$(echo "${REF}" | cut -f 1 -d '.')

picard CreateSequenceDictionary R=${REF} O=${refPrefix}.dict #create ref dictionary

samtools faidx ${REF} #index the reference

bwa index ${REF} #index the reference for purposes of aligning 
