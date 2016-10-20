# coding: u8

import sys
reload(sys)
sys.setdefaultencoding('u8')

import json
import traceback

import urllib
import urllib2

from WYLDocFeatureDumpFetcher import WYLDocFeatureDumpFetcher

class JsonFetcherMermaid(object):
    serve_url = "http://10.111.0.101:8101/mermaid/edit?method=getlist&start={0}&length={1}"
    colList = ['docId', 'title', 'source', 'sourceAuth', 'categories', 'demand', 'offending', 'demoSeg', 'metrics.PROFESSIONAL', 'metrics.LEISURE', 'metrics.NEWS']

    # 中国地名列表
    localNames = []

    def __init__(self, colList = None):
        if colList:
            self.colList = colList

    def data_fetch(self, n=-1):
        stepLength = 200
        offset = 0
        docInfos = []
        resJson = {}
        print >> sys.stderr, "fetching..."
        while offset == 0 or resJson:
            req_url = self.serve_url.format(offset, stepLength)
            try:
                s = urllib2.urlopen(req_url).read()
                if not s:
                    break
                resJson = json.loads(s)
            except Exception:
                print >> sys.stderr, traceback.format_exc()

            # parse properties
            for docinfo in resJson['docs']:
                item = {}
                for col in self.colList:
                    if col.find('.') == -1:
                        item[col] = docinfo[col]
                    elif col.find('.') > 0 and col.find('.') < len(col)-1:
                        col1, col2 = col.split('.')
                        item[col] = docinfo[col1][col2]
                docInfos.append(item)

            offset += stepLength
            # break # for debug
        print >> sys.stderr, "fetched {0} docs.".format(len(docInfos))

        return docInfos

    def local_flag(self, docInfo):
        if not self.localNames:
            with open('location_map_k1.lst', 'r') as inf:
                print >> sys.stderr, "open local name file for reading..."
                for line in inf:
                    self.localNames.append(line.strip())
                print >> sys.stderr, "read {0} locate names.".format(len(self.localNames))

        # flag = 0
        flag = ''
        for localName in self.localNames:
            if docInfo['title'].find(localName) != -1:
                # if flag % 10 == 0: flag += 1
                flag += ', t:' + localName
            if docInfo['source'].find(localName) != -1:
                # if flag / 10 == 0: flag += 10
                flag += ', s:' + localName
            if flag == 11:
                break
        docInfo['flag'] = flag
        return

    def dump(self, docInfos):
        # print header
        print '\t'.join(self.colList)

        for docinfo in docInfos:
            properties = []
            for col in self.colList:
                if col == 'categories':
                    properties.append(','.join(docinfo[col]))
                else:
                    properties.append(docinfo[col])
            if 'flag' in docinfo:
                properties.append(docinfo['flag'])
            print '\t'.join([str(i) for i in properties])

