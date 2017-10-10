
ofolder=`pwd`
reads1=$ofolder/data/fastq/miseq1.fastq
reads2=$ofolder/data/fastq/miseq2.fastq



if [ -f $reads1 ]; then check1=`head -1 $reads1`; fi
if [ -f $reads2 ]; then check2=`head -1 $reads2`; fi

if [ ! -f $reads1 ]; then
        echo; echo "  Could not find read-file "  ${reads1}; echo
elif  [ ! -f $reads2 ]; then
        echo; echo "  Could not find read-file "  ${reads2}; echo
elif [ -z "${check1}" ]; then
        echo; echo "  The read-file "  ${reads1} is empty!; echo
elif [ -z "${check2}" ]; then
        echo; echo "  The read-file "  ${reads2} is empty!; echo
else


	mkdir -p results/spades
	cd results/spades
	$ofolder/src/spades/bin/spades.py --pe1-1 $reads1 --pe1-2 $reads2 -t 15 -o miseq
	
	mv miseq/contigs.fasta miseq/spades_contigs.fasta
	mv miseq/scaffolds.fasta miseq/spades_scaffolds.fasta
fi
