#!/bin/bash

# software needed: minimap2 miniasm, spades, act

ofolder=`pwd`
src=$ofolder/src
mkdir -p $src
cd $src

list=( $src/minimap2/minimap2 $src/miniasm/miniasm $src/spades/bin/spades.py $src/Artemis/act )


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


errs=0
for exe in "${list[@]}"; do
    if [[ ! -f $exe ]]; then
        echo Error! Cannot find $exe
        errs=$(($errs+1))
    fi
done

if [  $errs -gt 0 ]; then echo " ****  Errors occurred! **** "; echo; exit;
else echo " Congrats: installation successful!"; fi
