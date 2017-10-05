#!/bin/bash

# software needed: minimap2 miniasm, spades, act

ofolder=`pwd`
src=$ofolder/src
data=$ofolder/data
mkdir -p $src
cd $src

exelist=( $src/minimap2/minimap2 $src/miniasm/miniasm $src/spades/bin/spades.py $src/Artemis/act  $src/MUMmer3.23/dnadiff )
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


if [[ ! -f $src/MUMmer3.23/dnadiff ]]; then
    cd $src
    wget --no-check-certificate https://kent.dl.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz  
    tar -xvzf MUMmer3.23.tar.gz 
    cd MUMmer3.23
    make all
    rm -f ../MUMmer3.23.tar.gz
fi



cd $src
mkdir -p mylibs

### Intalling gzstream (it needs zlib!)
if [[ ! -d  mylibs/gzstream ]]  || [[ ! -f mylibs/gzstream/gzstream.o ]]; then
    rm -rf mylibs/gzstream
    cd mylibs
    
    wget https://www.cs.unc.edu/Research/compgeom/gzstream/gzstream.tgz 

    if [[ "$?" != 0 ]]; then
        echo "Error downloading gzstream, try again" 
        rm -rf gzstream gzstream.tgz 
        exit
    else
        tar -xvzf gzstream.tgz &> /dev/null
        if [[ "$?" != 0 ]]; then echo " Error during gzstream un-compressing. Exiting now"; exit; fi
        cd gzstream
        make &> /dev/null
        
        if [[ "$?" != 0 ]]; then echo " Error during gzstream compilation. Exiting now"; exit; fi
	test=`make test | grep "O.K" | wc -l`
        if [[ $test == 1 ]]; then rm ../gzstream.tgz 
        else  echo  " Gzstream test failed. Exiting now"; exit; fi
    fi
fi
 
cd $src
if [[ ! -f mylibs/gzstream/gzstream.o ]]; then 
        echo "  !! Error: gzstream not installed properly!"; 
        exit
fi


srcs=( n50 )
for code in "${srcs[@]}"; do 
    cd $src/$code
    if [[ ! -f $code ]] || [[ $code -ot $code.cpp ]] || [[ $code -ot lowmem.h ]]; then
        echo $code
        make all
    fi
done


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
