
ofolder=`pwd`
reads1=$ofolder/data/miseq1.fastq
reads2=$ofolder/data/miseq2.fastq


mkdir -p results/spades
cd results/spades
$ofolder/src/spades/bin/spades.py --pe1-1 $reads1 --pe1-2 $reads2 -t 15 -o miseq

