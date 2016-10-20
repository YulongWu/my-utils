#coding: u8

import sys
reload(sys)
sys.setdefaultencoding('u8')
from sets import Set

import urllib
import urllib2
import json

# call format:

ids = Set()

# call format: cat data_evaluate/top500.v2.type_heshe.docid.txt | python ~/gitsvnlib/YulongUtils/http_dataFetcher.py > data_evaluate/top500.v2.type_heshe.docid.result.json

if __name__ == "__main__":
    serving_url = "http://10.111.0.56:8029/clickfeedback/neo"   #url of cfb info

    for linecount, line in enumerate(sys.stdin):
        if linecount % 10000 == 0:
            print >> sys.stderr, "Processed {0} lines...".format(linecount)
        id = line.strip()
        try:
            req_url = serving_url + '?' + urllib.urlencode({'docids':id})
            print urllib2.urlopen(req_url).read(),
        except Exception, e:
            print >> sys.stderr, "Error occured for docid: " + id
            print >> sys.stderr, e
