#coding: u8

import sys
reload(sys)
sys.setdefaultencoding('u8')
import json

def json2tab():
    headers = []
    for linecount,line in enumerate(sys.stdin):
        if line.startswith("*"):
            break
        info = json.loads(line)
        if linecount == 0:
            for key in info.iterkeys():
                headers.append(key)
            print '\t'.join(headers)
        cur_line = []
        for header in headers:
            if header in info:
                col = info[header]
                cur_line.append(str(col))
            else:
                cur_line.append('~')
        print '\t'.join(cur_line)

if __name__ == '__main__':
    json2tab()
