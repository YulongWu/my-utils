#coding: u8
# mode = 1: convert from timestamp to readable time

import sys
import datetime

if __name__ == "__main__":
    mode = int(sys.argv[1])
    if mode == 1:
        timestamp = long(sys.argv[2])
        print datetime.datetime.fromtimestamp(timestamp)
    else:
        print "unrecognized parameter!"
