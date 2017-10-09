#!/bin/bash

ofolder=`pwd`
myforACT=$ofolder/src/forACT
data=$ofolder/data

assembly=$ofolder/$1
reference=$ofolder/$2

if [ $# -lt 2 ] || [ $1 == '-h' ]; then
    echo; echo "  Usage:" $(basename $0)  assembly.fasta reference.fasta 
    exit
fi
where=$ofolder/results/act/act_$(basename $assembly .fasta)
mkdir -p $where


echo
if [[ ! -f $where/mysettings.sh ]]; then
    $myforACT/launchme.sh setup $reference $assembly  $where

    cd $where
    # change some settings:
    sed -i 's#shred=10000#shred=5000000#g' mysettings.sh  # no shredding
    sed -i 's#lfsjobs=1#lfsjobs=0#g'  mysettings.sh
    sed -i 's#minid=70#minid=10#g'  mysettings.sh
fi
cd $where

# launch forACT
./mypipeline.sh align
./mypipeline.sh check
./mypipeline.sh prepfiles | head -8


#./mypipeline.sh act
act $reference $where/minimap2_5000000/unique/foractnonoise0.2_minid10.al  $where/minimap2_5000000/unique/foractnonoise0.2_minid10.fasta

