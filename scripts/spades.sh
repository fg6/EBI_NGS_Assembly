
ofolder=`pwd`
reads1=$ofolder/data/fastq/miseq1.fastq
reads2=$ofolder/data/fastq/miseq2.fastq


mkdir -p results/spades
cd results/spades
$ofolder/src/spades/bin/spades.py --pe1-1 $reads1 --pe1-2 $reads2 -t 15 -o miseq

mv contigs.fasta spades_contigs.fasta
mv scaffolds.fasta spades_scaffolds.fasta

