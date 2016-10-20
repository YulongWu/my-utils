import sys
import json

class WYLJoin(object):
    @staticmethod
    def leftJoin(file1, file2, col1, col2):
        '''
        left join file1 and file2 based on col1 and col2
        '''
        mapper = {}
        with open(file2, 'r') as f2:
            for line in f2:
                info = line.strip().split('\t')
                key = info[col2-1]
                del info[col2-1]
                value = info
                if key in mapper:
                    raise Exception("duplicate key in file2 for key: {0}".format(key))
                mapper[key] = '\t'.join(info)

        with open(file1, 'r') as f1:
            for line in f1:
                info = line.strip().split('\t')
                key = info[col1-1]
                if key in mapper:
                    print "{0}\t{1}".format(line.strip(), mapper[key])
                else:
                    print line.strip() + '\t~'
    @staticmethod
    def innerJoin(file1, file2, col1, col2):
        '''
        inner join file1 and file2 based on col1 and col2
        '''
        mapper = {}
        with open(file2, 'r') as f2:
            for line in f2:
                info = line.strip().split('\t')
                key = info[col2-1]
                del info[col2-1]
                value = info
                if key in mapper:
                    raise Exception("duplicate key in file2 for key: {0}".format(key))
                mapper[key] = '\t'.join(info)

        with open(file1, 'r') as f1:
            for line in f1:
                info = line.strip().split('\t')
                key = info[col1-1]
                if key in mapper:
                    print "{0}\t{1}".format(line.strip(), mapper[key])
