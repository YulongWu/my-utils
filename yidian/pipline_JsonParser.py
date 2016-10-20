# python pipline_JsonParser.py docid click view
import sys
import json

if __name__ == "__main__":
    args = sys.argv[1:]
    for line in sys.stdin:
        cols = []
        info = json.loads(line)
        for arg in args:
            cols.append(info[arg])
        print '\t'.join(cols)
