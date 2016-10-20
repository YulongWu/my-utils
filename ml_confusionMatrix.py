import sys

# call format: cat test.txt | python ml_confusionMatrix.py {index_of_label} {index_of_score} {threshold_of_score}

if __name__ == '__main__':
    tp, tn, fp, fn = 0, 0, 0, 0
    label_i = int(sys.argv[1])-1
    result_i = int(sys.argv[2])-1
    threshold = float(sys.argv[3])
    for line in sys.stdin:
        info = line.strip().split('\t')
        label = info[label_i]
        result = info[result_i]
        if float(result)> threshold:
            if int(label) >= 1:
                tp += 1
                print line.strip() + '\t' + 'TP'
            else:
                fp += 1
                print line.strip() + '\t' + 'FP'
        else:
            if int(label) >= 1:
                fn += 1
                print line.strip() + '\t' + 'FN'
            else:
                tn += 1
                print line.strip() + '\t' + 'TN'
    print >> sys.stderr, "\t\t\t\tture\tfalse"
    print >> sys.stderr, "positive:\t{0}\t{1}".format(tp, fp)
    print >> sys.stderr, "negative:\t{0}\t{1}".format(tn, fn)
    precision = 1.0*tp/(tp+fp)
    recall = 1.0*tp/(tp+fn)
    print >> sys.stderr, "precision: {0}".format(precision)
    print >> sys.stderr, "recall: {0}".format(recall)
    print >> sys.stderr, "F1: {0}".format(2*precision*recall/(precision + recall))
