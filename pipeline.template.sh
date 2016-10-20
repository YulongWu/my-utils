#!/bin/zsh
set -e
step=$1
INPUT=$2
MARK=$3

function run_command()
{
    step=$1
    command=$2
    echo "[INFO]Step$step: Prepare to run command: "$command"\n"
    echo "Working directory: $(pwd)"
    date
    eval $command
}
# separate training data and test data
# num_all=${"wc -l $input_0"}

# step1: randomly sort input data
# path: ./new_data
BASE="document_explore_201504to08.txt"
intput_1=$INPUT
output_1=${input_1}.uniq.random_sort
if [[ $step == *1* ]]; then
    command="cat ${input_1} | sort | uniq | sort -R > ${output_1}"
    run_command 1 $command
else
    output_1=$INPUT
fi

# step2: 
# 1. parse cfb info to generate label
input_2=${output_1}
input_2_base=$(basename ${input_2})
if [[ ${input_2:0:2} != "2_" ]]; then
    output_2_base=2_${input_2_base}.$MARK.label
else
    output_2_base=2_${input_2_base:2:$}.$MARK.label
fi
output_2=$(dirname ${input_2})/${output_2_base}
if [[ $step == *2* ]]; then
    command="python 2_generate_label.py $input_2 > $output_2"
    run_command 2 $command
else
    output_2=$output_1
fi

# step3: cook features and transform to vw format
input_3=${output_2}
input_3_base=$(basename ${input_3})
if [[ ${input_3:0:2} != "2_" ]]; then
    output_3_base=3_${input_3_base}.$MARK.vw
else
    output_3_base=3_${input_3_base:2:$}.$MARK.vw
fi
output_3=$(dirname ${input_3})/${output_3_base}
if [[ $step == *3* ]]; then
    print "enter step 3..."
    command="time java -cp predictor-server-0.1-jar-with-dependencies.jar com.hipu.feature.content.clickbait.ClickbaitPrepare $output_2 > $output_3"
    run_command 3 $command
    mv data_model/feature_mapper.out data_model/feature_mapper.out.$MARK
else
    output_3=$INPUT
fi

# step4: split train and test data
input_4=${output_3}
output_4_all=${input_4}
if [[ $step == *4* ]]; then
    output_4_train=${input_4}.train
    output_4_test=${input_4}.test
    line_num=$(wc -l $input_4 | awk '{print $1}')
    line_num_test=$(($line_num / 5))
    line_num_train=$(($line_num - $line_num_test))
    command="head -$line_num_test ${input_4} > $output_4_test"
    run_command 4 $command
    command="tail -$line_num_train ${input_4} > $output_4_train"
    run_command 4 $command
else
    output_4_all=$INPUT
    output_4_train=$INPUT.train
fi

# step 5: train model
input_5=${output_4_all}
if [[ $step == *5* ]]; then
    rm tmt.cache lr.model

    command="~/thirdparty/vowpal_wabbit-7.5.senliu/vowpalwabbit/vw --loss_function logistic -f lr.model.$MARK -d $input_5 -b 25 --passes 25 --cache_file tmt.cache"
    run_command 5 $command
fi

#step 6: train and output feature weight
#step 6_1: for model with feature hash
input_6=${output_4_all}
if [[ $step == *6* ]]; then
    if [[ -e tmt.cache.$MARK ]]; then
        rm -vf tmt.cache.$MARK
    fi
    print "Step 6.1: train model..."
    command="~/thirdparty/vowpal_wabbit-7.5.senliu/vowpalwabbit/vw --loss_function logistic -f data_model/lr.model.$MARK -d ${input_6} -b 25 --passes 1 --readable_model data_model/readable_model.$MARK -k"
    run_command 6 $command
    print "Step 6.2: getting audit file..."
    command="~/thirdparty/vowpal_wabbit-7.5.senliu/vowpalwabbit/vw -i data_model/lr.model.$MARK -t ${input_6}  --audit > data_model/audit.txt.$MARK"
    run_command 6 $command
    print "Step 6.3: getting feature weight file..."
    print "Current \$step=$step"
    if [[ $step == *6a* ]]; then
      print "mode 1: have feature hasing"
      command="python task3/extract_weight.py data_model/audit.txt.$MARK > data_model/feature_weight_lr.txt.$MARK"
      run_command 6a $command
    elif [[ $step == *6b* ]]; then
      print "mode 2: no feature hashing(self coding feature id)"
      command="python task3/extract_weight.nofeaturehash.py data_model/feature_mapper.out.$MARK data_model/audit.txt.$MARK > data_model/feature_weight_lr.txt.$MARK"
      run_command 6b $command
    else
      print "Error: no mode specify!"
      exit(1)
    fi
fi

#step 7: test model
input_7=${output_4_all}
if [[ $step == *7* ]]; then
    command="~/thirdparty/vowpal_wabbit-7.5.senliu/vowpalwabbit/vw -i lr.model.$MARK -t $input_7 -p test.score.$MARK"
    print "Step 7.1: test model..."
    run_command 7 $command
fi
#step 8: get classifier result
if [[ $step == *8* ]]; then
    input_8_1=$2 # output of step 2
    input_8_2=$3 # audit.txt file: output of step 6
    MARK=$4
    command="python ../util_matchResult.py $input_8_1 $input_8_2 $MARK"
    run_command 8 $command
fi

if [[ $step == util ]]; then
  # get doc info from mongo
  golog 'python ../../YulongUtils/mongo_datafetcher.py "{\"insert_time\":{\"\$gte\":\"2015-10-14 20:00:00\"}}" "[\"_id\", \"cat_class\", \"source\", \"kws\", \"seg_title\"]" > doc.v2.from20150601.json'
    # get parse title of pos cases
    cat 2_document_explore_201504to08.v1.txt| grep '"label": "pos"' | grep -oe '\"parse_title\": \".*\", \"subcat_class\"'
    # generate multigrams from word2vec
    cat word2vec/corpus_title_from20150601.phrase1 | python util_gen_multigram_dict.py
    # generate model result for training data
    python util/util_matchResult.py 2_doc_from20150601.json.uniq.$MARK.label.shuffled ../audit.txt.$MARK $MARK
    # label based on last model
    python util/util_labelOnModel.py new_data.v10/matchResult.$MARK.txt new_data.v10/doc_from20150601.json.uniq $MARK
    # generate multigram by frequency only
    cat data_train/1_title_20150601-20151021.clean | python util/util_gen_multigram.py $MARK 100
    
fi

# merge feature weight feature_weight_lr.txt into old seed file and generate a new seed file
if [[ $step == merge_seed ]]; then
    PREMARK=$2
    cat feature_weight_lr.txt.$MARK | python util_process_feature_weight_lr.txt.py > feature_weight_lr.txt.$MARK.word
    cp seed.$PREMARK.txt temp
    cat feature_weight_lr.txt.$MARK.word >> temp
    cat temp | sort > seed.$PREMARK.$MARK.txt
fi
