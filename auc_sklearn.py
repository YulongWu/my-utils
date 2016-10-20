#coding: u8
import sys
import numpy as np
from sklearn import metrics

if __name__ == '__main__':
    pred_list, label_list = [] , []
    for line in sys.stdin:
        pred, label = line.strip().split('\t')
        pred_list.append(float(pred))
        label_list.append(int(label))
    np_pred = np.array(pred_list)
    np_label = np.array(label_list)
    fpr, tpr, thresholds = metrics.roc_curve(np_label, np_pred, pos_label=1)
    print metrics.auc(fpr, tpr)
