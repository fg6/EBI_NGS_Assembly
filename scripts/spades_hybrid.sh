
ofolder=`pwd`
reads1=$ofolder/data/fastq/miseq1.fastq
reads2=$ofolder/data/fastq/miseq2.fastq
long_reads=$ofolder/data/fastq/nanopore.fastq



if [ -f $reads1 ]; then check1=`head -1 $reads1`; fi
if [ -f $reads2 ]; then check2=`head -1 $reads2`; fi
if [ -f $long_reads ]; then check3=`head -1 $long_reads`; fi


if [ ! -f $reads1 ]; then
        echo; echo "  Could not find read-file "  ${reads1}; echo
elif  [ ! -f $reads2 ]; then
        echo; echo "  Could not find read-file "  ${reads2}; echo
elif  [ ! -f $long_reads ]; then
        echo; echo "  Could not find read-file "  ${long_reads}; echo
elif [ -z "${check1}" ]; then
        echo; echo "  The read-file "  ${reads1} is empty!; echo
elif [ -z "${check2}" ]; then
        echo; echo "  The read-file "  ${reads2} is empty!; echo
elif [ -z "${check3}" ]; then
        echo; echo "  The read-file "  ${long_reads} is empty!; echo
else

	mkdir -p results/spades
	cd results/spades
	$ofolder/src/spades/bin/spades.py --pe1-1 $reads1 --pe1-2 $reads2 --nanopore $long_reads -t 15 -o miseq_ont

	mv miseq_ont/contigs.fasta miseq_ont/hybridspades_contigs.fasta
	mv miseq_ont/scaffolds.fasta miseq_ont/hybridspades_scaffolds.fasta
fi
