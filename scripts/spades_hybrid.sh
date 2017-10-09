
ofolder=`pwd`
reads1=$ofolder/data/fastq/miseq1.fastq
reads2=$ofolder/data/fastq/miseq2.fastq
long_reads=$ofolder/data/fastq/nanopore.fastq


mkdir -p results/spades
cd results/spades
$ofolder/src/spades/bin/spades.py --pe1-1 $reads1 --pe1-2 $reads2 --nanopore $long_reads -t 15 -o miseq_ont

mv contigs.fasta hybridspades_contigs.fasta
mv scaffolds.fasta hybridspades_scaffolds.fasta
