#!/bin/bash

hadoop fs -rm -r $4

nohup hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -Dmapreduce.job.reduces=1 \
    -input '/user/azkaban/camus/rawlog_str_pollen_android/hourly/2015-07-20/*,/user/azkaban/camus/rawlog_str_pollen_iPhone/hourly/2015-07-20/*' \
    -mapper $1 \
    -file /home/wuyulong/streaming/$1 \
    -reducer $2 \
    -file /home/wuyulong/streaming/$2 \
    -file $3 \
    -output $4 &
