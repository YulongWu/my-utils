#!/usr/bin/env sh
# input format
# $1: mapper file. 
# $2: reducer file
# $3: mapper input file

if [ $# -ne 3 ]
then
    echo "usage: ./HadoopStreaming_LocalSimulator.sh mapper_code_file reducer_code_file mapper_input_file"
    exit 1
fi

mapper=$1
reducer=$2
input=$3

if [[ (! -f $mapper) || (! -f $reducer) ]]
then
    if [ ! -f $mapper ]
    then
        echo -e "$LIGHTREDError Mapper file: $YELLOW $mapper could not found!$NC"
    else
        echo -e "$LIGHTREDError Reducer file: $YELLOW $reducer could not found!$NC"
    fi
fi

if [ -f hadoopstreaming.simulator.temp ]
then
    rm -f hadoopstreaming.simulator.temp
fi

if [ -f hadoopstreaming.simulator.out ]
then
    rm -f hadoopstreaming.simulator.out
fi

if [ $? -eq 0 ]
then
    echo -e "$GREEN Simulator: mapper is starting...$NC "
    echo -e "$YELLOW Simulator: input line number to mapper: $(wc -l $input | awk '{ print $1 }')$NC "
    cat $input | python $mapper > hadoopstreaming.simulator.temp
fi

if [ $? -eq 0 ]
then
    echo -e "$YELLOW Simulator: output line number of mapper: $(wc -l hadoopstreaming.simulator.temp | awk '{ print $1 }')$NC "
    echo -e "$GREEN Simulator: mapper successful! shuffling...$NC "
    sort -k 1 -t \t hadoopstreaming.simulator.temp -o hadoopstreaming.simulator.temp
fi

if [ $? -eq 0 ]
then
    echo -e "$GREEN Simulator: shuffuling completed! reducer is starting...$NC "
    cat hadoopstreaming.simulator.temp | python $reducer > hadoopstreaming.simulator.out
    if [ $? -eq 0 ]
    then
        echo -e "$YELLOW Simulator: output line number of reducer: $(wc -l hadoopstreaming.simulator.out | awk '{ print $1 }')$NC "
        echo -e "$GREEN Congratulations! Simulating completed succesfully! Pls see $YELLOW hadoopstreaming.simulator.out$GREEN output data.$NC"
        exit 0
    fi
fi

echo -e "$LIGHTRED Simulator failed, pls check! $YELLOW Don't disappointed, you're nearing to the success!"
exit 1
