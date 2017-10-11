

ofolder=`pwd`

assembly=$1
reference=$2

if [ $# -lt 2 ] || [ $1 == '-h' ]; then
    echo; echo "  Usage:" $(basename $0) assembly.fasta reference.fasta 
    exit
fi
where=$ofolder/results/report/report_$(basename $assembly .fasta)


rm -rf $where
mkdir -p $where
cd $where

echo
$ofolder/src/forACT/utils/mysrcs/n50/n50 $ofolder/$assembly | tee n50.stats
if [[ -f n50.stats ]]; then
   echo Assembly stats saved in $where/n50.stats
else
   echo Error running n50!
fi

if [[ ! -f out.report ]]; then
  $ofolder/src/MUMmer3.23/dnadiff $ofolder/$reference $ofolder/$assembly &> dnadiff.log
fi

if [[ -f out.report ]]; then
 echo; echo
 echo Dnadiff results are in file $where/out.report 
 grep "AvgIdentity" out.report | tail -1

else
 echo Error running dnadiff: something went wrong!
 echo Please look into the log file $where/dnadiff.log
 exit
fi
echo

