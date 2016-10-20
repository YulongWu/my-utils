LABEL=$1
MODEL=$2
MARK=$3
MODE=$4
set -e
########################################
# run this script at ~/gitsvnlib/pctr/data_prepare
########################################

#./vw -i $MODEL -t $LABEL -p /dev/stdout --quiet | cut -d' ' -f1 > data_evaluate/predict.$MARK.tmp
printf "pwd: "$(pwd)'\n'
~/thirdparty/vowpal_wabbit-7.5.senliu/vowpalwabbit/vw -i $MODEL -t $LABEL -p /dev/stdout --quiet | cut -d' ' -f1 > data_evaluate/predict.$MARK.tmp
#if [[ $MODE -eq "weighted" ]]; then
  #printf "for weighted mode: paste weight to predict"
  #cat $LABEL | cut -d' ' -f2 > data_evaluate/data_evaluate.weight.tmp
  #paste data_evaluate/predict.$MARK.tmp data_evaluate/data_evaluate.weight.tmp > data_evaluate/predict.$MARK.weighted.tmp
  #printf "paste predict and LABEL together and sort...\n"
  #paste data_evaluate/predict.$MARK.weighted.tmp $LABEL | awk '{l = $3; if(l == -1) l = 0; print $1 "\t" $2 "\t" l;}' | sort -t$'\t' -k1,1gr -s > data_evaluate/awk.$MARK.weighted.tmp
  #printf "calculate AUC...\n"
#  cat data_evaluate/awk.$MARK.weighted.tmp | cut -f2,3 | awk -f ~/gitsvnlib/YulongUtils/auc_weighted.awk > data_evaluate/$MARK.weighted.auc
#else
  printf "paste predict and LABEL together...\n"
  paste data_evaluate/predict.$MARK.tmp $LABEL > data_evaluate/awk.$MARK.tmp
  printf "calculate mean square loss...\n"
  cat data_evaluate/awk.$MARK.tmp | sed 's/\t/ /g' |cut -f1,2 | awk -f ~/gitsvnlib/YulongUtils/mse.awk > data_evaluate/$MARK.mse
#fi
#rm -f awk.tmp
#rm -f predict.tmp
