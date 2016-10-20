BEIGN {
  max = 0.0
} {
    s += (tp + tp + $1) * (1.0 - $1) / 2.0;
    tp += $1;
    fp += (1.0 - $1);
    TP[NR] = tp
    FP[NR] = fp
} END {
    for(i=1; i<=NR; i++){
      if(TP[i] == 0) continue;
      F1 = 2 * (TP[i] * TP[i] / (tp * i)) / (TP[i] / tp + TP[i] / i)
      print TP[i] / tp, TP[i] / i, F1;
      if (max < F1) max = F1
    }
    print tp, fp, s / (tp * fp), max;
}

