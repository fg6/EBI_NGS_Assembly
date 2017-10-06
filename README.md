# EBI_NGS_Assembly
Practical exercises for the EBI NGS Course -- Assembly Session





## Installation
Requirements: wget, zlib, gcc, Python2: 2.4–2.7, and Python3: 3.2 or higher, Java 1.6 or higher
Download repository, install utilities/compile tools, downaload data: 

    $ git clone https://github.com/fg6/EBI_NGS_Assembly.git
    $ cd EBI_NGS_Assembly
    $ ./scripts/install.sh
  
If everything went fine you should see a comment like this:

  Congrats: installation successful!
  
## Description of data
In the data/ folder there are the following files:
      Escherichiacoli-K-12.fasta  =  E.Coli Reference assembly
      miseq1.fastq, miseq2.fastq	=  E.Coli Miseq (Illumina) data: read pairs
      nanopore.fastq  = E.Coli Oxford Nanopore Technologies reads
      
      assemblies/miniasm.fasta             E.Coli contig assembly from MiniAsm using the nanopore.fastq reads
      assemblies/spades_contigs.fasta      E.Coli contig assembly from SPAdes using the Miseq reads
      assemblies/spades_scaffolds.fasta    E.Coli scaffold assembly from SPAdes using the Miseq reads

## Run the exmples
### Generate the SPAdes assembly using the Miseq reads:
      
      $ ./scripts/spades.sh
      
Contig and Scaffold assemblies will be in results/spades/miseq/contigs.fasta results/spades/miseq/scaffolds.fasta
### Generate the SPAdes assembly using the Miseq reads and the Nanopore reads:

      $ ./scripts/spades_hybrid.sh
Contig and Scaffold assemblies will be in results/spades/miseq_ont/contigs.fasta results/spades/miseq_ont/scaffolds.fasta

### Generate the MiniAsm assembly using the Nanopore reads:
      
      $ ./scripts/miniasm.sh
      
Contig assembly will be in results/miniasm/miniasm.fasta
