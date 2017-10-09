# EBI_NGS_Assembly
Practical exercises for the EBI NGS Course -- Assembly Session

## Installation
Requirements: wget, zlib, gcc, Python2: 2.4–2.7, and Python3: 3.2 or higher, Java 1.6 or higher.

Download repository, install utilities/compile tools, downaload data: 

    $ git clone https://github.com/fg6/EBI_NGS_Assembly.git
    $ cd EBI_NGS_Assembly
    $ ./scripts/install.sh
  
If everything went fine you should see a comment like this:

    Congrats: installation successful!
  
## Description of data
In the data/ folder there are the following files and folders:

      Escherichiacoli-K-12.fasta  =  E.Coli Reference assembly
      
  the fastq/ folder contains Illumina and Oxford Nanopore read files:

    miseq1.fastq, miseq2.fastq	=  E.Coli Miseq (Illumina) data: read pairs
    nanopore.fastq  = E.Coli Oxford Nanopore Technologies reads
    
  the results/ folder contains the assemblies and act results that the pipeline generates:
     
      assemblies/miniasm.fasta             E.Coli contig assembly from MiniAsm using the nanopore.fastq reads
      assemblies/spades_contigs.fasta      E.Coli contig assembly from SPAdes using the Miseq reads
      assemblies/spades_scaffolds.fasta    E.Coli scaffold assembly from SPAdes using the Miseq reads
      assemblies/hybridspades_contigs.fasta      E.Coli contig assembly from SPAdes using the Miseq and the ONT reads
      assemblies/hybridspades_scaffolds.fasta    E.Coli scaffold assembly from SPAdes using the Miseq and the ONT reads

      act/act_miniasm                  alignment and fasta file to run ACT for the miniasm assembly
      act/act_spades_contigs                  alignment and fasta file to run ACT for the SPAdes contigs
      act/act_spades_scaffolds                alignment and fasta file to run ACT for the SPAdes scaffolds
      act/act_hybridspades_contigs            alignment and fasta file to run ACT for the hybridSPAdes contigs
      act/act_hybridspades_scaffolds          alignment and fasta file to run ACT for the hybridSPAdes scaffolds

The assemblies in the data/assemblies folder are the same that the scripts below will generate, and are provided
as a way to check the results. 

## Run the examples
Run each script from the main folder EBI_NGS_Assembly; if a script needs input files, provide the files including  their relative location.

### Generate the SPAdes assembly using the Miseq reads:
      
      $ ./scripts/spades.sh
      
Contig and Scaffold assemblies will be in results/spades/miseq/contigs.fasta results/spades/miseq/scaffolds.fasta
### Generate the SPAdes assembly using the Miseq reads and the Nanopore reads:

      $ ./scripts/spades_hybrid.sh
Contig and Scaffold assemblies will be in results/spades/miseq_ont/contigs.fasta results/spades/miseq_ont/scaffolds.fasta

### Generate the MiniAsm assembly using the Nanopore reads:
      
      $ ./scripts/miniasm.sh
      
Contig assembly will be in results/miniasm/miniasm.fasta

### Check stats and average identity of an assembly with respect to the reference (for instance the miniasm assembly):
    
       $ ./scripts/check_assembly.sh data/Escherichiacoli-K-12.fasta results/miniasm/miniasm.fasta   
     
The scripts/check_assembly.sh can also run on the assemblies provided in the data/assemblies folder.

### Run the pipeline to map an assembly against the reference and visualize the result with ACT (for instance the miniasm assembly):

       $ ./scripts/runACT.sh results/miniasm/miniasm.fasta data/Escherichiacoli-K-12.fasta 

The scripts/runACT.sh can also run on the assemblies provided in the data/assemblies folder.
The scripts/runACT.sh script will run the ACT provided in the PATH variable. The training computers have ACT installed and ready to use. If using this repo on own computer and don't have ACT, you can try to use the act version installed in: EBI_NGS_Assembly/src/forACT/utils/mysrcs/Artemis/act, just add the full path to this ACT into your PATH environment variable. (this installation not working on the training computers).
