#!/bin/bash

ofolder=`pwd`
minimap2=$ofolder/src/minimap2/minimap2
miniasm=$ofolder/src/miniasm/miniasm

reads=$ofolder/data/fastq/nanopore.fastq

if [ -f $reads ]; then check=`head -1 $reads`; fi
if [ ! -f $reads ]; then
        echo; echo "  Could not find read-file "  ${reads}; echo
elif [ -z "${check}" ]; then
        echo; echo "  The read-file "  ${reads} is empty!; echo
else
	mkdir -p $ofolder/results/miniasm
	cd $ofolder/results/miniasm

	#Read overlaps:
	$minimap2  -x ava-ont $reads $reads > overlaps.paf
	#Layout:
	$miniasm -f $reads overlaps.paf > reads.gfa  
	# Fasta from graph:
	cat reads.gfa | egrep "^S" | awk '{print ">" $2"\n"$3}' > miniasm.fasta

        echo assembly should be in $ofolder/results/miniasm/miniasm.fasta
fi

