BEIGN {
  max = 0.0
} {
    if($2 == 0) {
        fp += $1;
        s += tp;
    }
    if($2 == 1)
        tp += $1;
    TP[NR] = tp
    FP[NR] = fp
} END {
    for(i=1; i<=NR; i++){
      if(TP[i] == 0) continue;
      F1 = 2 * (TP[i] * TP[i] / (tp * (TP[i]+FP[i]))) / (TP[i] / tp + TP[i] / (TP[i]+FP[i]))
      print TP[i] / tp, TP[i] / (TP[i]+FP[i]), F1;
      if (max < F1) max = F1
    }
    print "tp: " tp
    print "fp: " fp
    print "s: " s
    print "max: " max
    print tp, fp, s / (tp * fp), max;
}

