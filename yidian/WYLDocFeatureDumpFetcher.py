#coding: u8

import sys
reload(sys)
sys.setdefaultencoding('u8')
import urllib
import urllib2
import json
import traceback
import datetime
import re

# call format:

class WYLDocFeatureDumpFetcher(object):
    serve_url = "http://10.111.0.54:8025/service/feature?docid={0}"   #url for doc feature dump
    serve_url = "http://10.111.0.54:8025/service/featuredump?docid={0}"   #url for doc feature dump
    cfb_cols = ['VClickDoc', 'VShareDoc', 'VViewComment', 'VAddComment', 'VLike', 'VDislike', 'VDWell', 'VDWellShortClick', 'VDWellClickDoc', 'ThumbUp', 'ThumbDown', 'RViewDoc']
    docInfoBuffer = {}

    def _getInfo(self, docid):
        if docid in self.docInfoBuffer:
            info = self.docInfoBuffer[docid]
        else:
            try:
                req_url = self.serve_url.format(docid)
                info = json.loads(urllib2.urlopen(req_url).read())
                self.docInfoBuffer[docid] = info
            except Exception, e:
                print >> sys.stderr, "Error occured for docid: " + docid
                print >> sys.stderr, traceback.format_exc()
                return None
        return info

    def _getMetric(self, docid, f):
        info = self._getInfo(docid)
        if not info:
            return -1
        else:
            clkbt = f(info)
            return clkbt

    def getDate(self, docid):
        date_diff = self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^date'])
        date = datetime.datetime.now() - datetime.timedelta(milliseconds = float(date_diff)*100000)
        return date.strftime("%Y-%m-%d %H:%M:%S")

    def getCFBFromDict(self, cfb_dict):
        res_map = {}
        for col in self.cfb_cols:
            res_map[col] = -1 if col not in cfb_dict else cfb_dict[col]
        return res_map

    def getAllCFB(self, docid, prefix='all'):
        res_map = {}
        t = self._getMetric(docid, lambda info:info['result']['clickfeedbacks'][prefix])
        if t and t != -1:
            for col in self.cfb_cols:
                res_map[col] = self._getMetric(docid, lambda info:info['result']['clickfeedbacks'][prefix][col])
        return res_map

    def _getSegmentCFBs(self, cfb_dict, cur_key, res_dict):
        if not cfb_dict:
            return
        for key in cfb_dict.keys():
            if key == 'stats':
                res_dict[cur_key] = getCFBFromDict(self, cfb_dict[key])
            elif key != 'all':
                self._getSegmentCFBs(self, cfb_dict[key], cur_key + '_' + key, res_dict)
        return

    def getCFBSegments(self, docid):
        cfb_all = self._getMetric(docid, lambda info:info['result']['clickfeedbacks'])
        res_dict = {}
        self._getSegmentCFBs(cfb_all, '', res_dict)
        return res_dict

    # 做为getBestCFB()的第三个参数传入
    def bestCFB_getter(cfb_dict, numerator_key, denominator_key, denominator_bar):
        if numerator_key not in cfb_dict or denominator_key not in cfb_dict:
            return -1
        denominator = cfb_dict[demoninator_key]
        if denominator == -1 or denominator < denominator_bar:
            return -1
        numerator = cfb_dict[numerator_key]
        return 1.0*numerator/denominator

    def getBestCFB(self, docid, n_key, d_key, d_bar):
        res_dict = self.getCFBSegments(docid)
        best_key, best_value = '', 0
        for key in res_dict.keys():
            v = self.bestCFB_getter(res_dict[key], n_key, d_key, d_bar)
            if v > best_value:
                best_value = v
                best_key = key
        return best_key, best_value

    def getClkbtScore(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^clkbt'])

    def getLCRScore(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^plcr'])

    def getSCRScore(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^pscr'])

    def _fetchDocumentData(self, docid, pattern):
        doc_s = self._getMetric(docid, lambda info:info['result']['documentData'])
        if doc_s == -1:
            return None
        match = re.search(pattern, doc_s)
        if match:
            return match.group(1)
        else:
            return None

    def getDemandType(self, docid):
        return self._fetchDocumentData(docid, 'demandType=(\w+?),')

    def getCategories(self, docid):
        return self._fetchDocumentData(docid, ' cat=\[(.+?)\]')

    def fetchDictValue(self,d, keys):
        v = None
        t = d
        for key in keys:
            if d and key in d:
                t = t[key]
            else:
                return None
        return t

    def getVClickDoc(self, docid):
        # return self._getMetric(docid, lambda info:info['result']['clickfeedbacks']['all']['stats']['VClickDoc'])
        info = self._getInfo(docid)
        res = self.fetchDictValue(info, ['result', 'clickfeedbacks', 'all', 'stats', 'VClickDoc'])
        if not res:
            return -1
        return res

    def getIndepthScore(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^indepth'])

    def getBpctr(self, docid):
        if self.serve_url.find('featuredump') != -1:
            return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^bpctr'])
        else:
            return self._fetchDocumentData(docid, ' sc_bpctr=([\d\.\-e]+?),')

    def getTmsstScore(self, docid):
        # for http://10.111.0.54:8025/service/featuredump?docid=
        if self.serve_url.find('featuredump') != -1:
            return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^tmsst'])
        # for http://10.111.0.54:8025/service/feature?docid=
        else:
            return self._fetchDocumentData(docid, ' tmsst=(\w+?),')

    def getMHot(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^mhot'])

    def getRnkc(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^rnkc'])

    def getRnksc(self, docid):
        return self._getMetric(docid, lambda info:info['result']['docFeatureMap']['d^^rnksc'])
