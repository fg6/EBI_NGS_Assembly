#!/bin/bash

# software needed: minimap2 miniasm, spades, act

ofolder=`pwd`
src=$ofolder/src
data=$ofolder/data
mkdir -p $src
cd $src

exelist=( $src/minimap2/minimap2 $src/miniasm/miniasm $src/spades/bin/spades.py $src/Artemis/act  $src/MUMmer3.23/dnadiff )
datalist=( $data/Escherichiacoli-K-12.fasta $data/miseq1.fastq  $data/miseq2.fastq $data/nanopore.fastq )

errs=0

if [[ ! -f  $src/minimap2/minimap2 ]]; then
    echo Installing minimap2 ...
    rm -rf $src/minimap2
    cd $src
    git clone https://github.com/lh3/minimap2 &> down.log && cd minimap2 && make &> install.log
fi

if [[ ! -f  $src/miniasm/miniasm ]]; then
    echo Installing miniasm ...
    rm -rf $src/miniasm
    cd $src
    git clone https://github.com/lh3/miniasm &>> down.log  && cd miniasm && make &> install.log
fi

if [[ ! -f  $src/spades/bin/spades.py ]]; then
    echo Installing SPAdes ...
    rm -rf $src/spades
    cd $src
    wget http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1-Linux.tar.gz &>> down.log 
    mkdir spades
    tar -xzf SPAdes-3.11.1-Linux.tar.gz -C spades --strip-components 1 &> install.log
    rm -r SPAdes-3.11.1-Linux.tar.gz
fi

if [[ ! -f  $src/Artemis/act ]]; then
    echo Installing ACT ...
    rm -rf $src/Artemis
    cd $src
    git clone https://github.com/sanger-pathogens/Artemis.git &>> down.log 
    cd Artemis/
    make &> install.log
fi


if [[ ! -f $src/MUMmer3.23/dnadiff ]]; then
    echo Installing MUMmer ...
    cd $src
    wget --no-check-certificate https://kent.dl.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz   &>> down.log 
    tar -xzf MUMmer3.23.tar.gz 
    cd MUMmer3.23
    make all &> install.log
    rm -f ../MUMmer3.23.tar.gz
fi


#wget https://netix.dl.sourceforge.net/project/staden/staden/2.0.0b11/staden-2.0.0b11-2016-src.tar.gz

if [[ ! -d $src/forACT ]]; then
    echo Installing forACT ...
    cd $src
    git clone https://github.com/fg6/forACT.git &>> down.log 
    cd forACT
    ./launchme.sh install &> install.log
    test=`grep "Congrats:" install.log | wc -l`
    if [[ $test != 1 ]]; then 
	echo  " forACT installation failed" 
	errs=$(($errs+1))
    fi
fi



### download data
if [[ ! -d $data ]]; then
    echo Downloading data ...
    cd $ofolder/
    wget ftp://ftp.sanger.ac.uk/pub/users/fg6/EBI_NGS_Assembly/data.tar.gz  &>> down.log 
    tar -xzf data.tar.gz
    rm -r data.tar.gz
fi

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
