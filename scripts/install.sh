#!/bin/bash

# software needed: minimap2 miniasm, spades, act

ofolder=`pwd`
src=$ofolder/src
data=$ofolder/data
mkdir -p $src
cd $src

exelist=( $src/minimap2/minimap2 $src/miniasm/miniasm $src/spades/bin/spades.py $src/Artemis/act )
datalist=( $data/Escherichiacoli-K-12.fasta $data/miseq1.fastq  $data/miseq2.fastq $data/nanopore.fastq )

if [[ ! -f  $src/minimap2/minimap2 ]]; then
    rm -rf $src/minimap2
    cd $src
    git clone https://github.com/lh3/minimap2 && (cd minimap && make)
    cd minimap2
    make
fi

if [[ ! -f  $src/miniasm/miniasm ]]; then
    rm -rf $src/miniasm
    cd $src
    git clone https://github.com/lh3/miniasm && (cd miniasm && make)
fi

if [[ ! -f  $src/spades/bin/spades.py ]]; then
    rm -rf $src/spades
    cd $src
    wget http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1-Linux.tar.gz
    mkdir spades
    tar -xzf SPAdes-3.11.1-Linux.tar.gz -C spades --strip-components 1
    rm -r SPAdes-3.11.1-Linux.tar.gz
fi

if [[ ! -f  $src/Artemis/act ]]; then
    rm -rf $src/Artemis
    cd $src
    git clone https://github.com/sanger-pathogens/Artemis.git
    cd Artemis/
    make
fi


### download data
if [[ ! -d $data ]]; then
    cd $ofolder/
    wget ftp://ftp.sanger.ac.uk/pub/users/fg6/EBI_NGS_Assembly/data.tar.gz .
    tar -xvzf data.tar.gz
    rm -r data.tar.gz
fi

errs=0
for exe in "${exelist[@]}"; do
    if [[ ! -f $exe ]]; then
        echo Error! Cannot find $exe
        errs=$(($errs+1))
    fi
done

for file in "${datalist[@]}"; do
    if [[ ! -f $file ]]; then
        echo Error! Cannot find $file
        errs=$(($errs+1))
    fi
done



if [  $errs -gt 0 ]; then echo " ****  Errors occurred! **** "; echo; exit;
else echo " Congrats: installation successful!"; fi
