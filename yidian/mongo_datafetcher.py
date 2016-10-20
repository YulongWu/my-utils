# coding: u8
########################################
# run_mode = 1:
# for the specific task.
# run_mode = 2:
# 根据find_dict从mongo中dump出相关数据
# call format example: python mongo_datafetcher.py 2 '{"insert_time":{"$gte":"2015-10-14 20:00:00"}}' '["url"]' > output.out
# run_mode = 3:
# 将输入文件的第一列作为docids, 取出一些指定字段, 附加在行尾
# call format example: cat orig_data.txt | python mongo_datafetcher.py 2 'cat url' > output.txt
########################################
import json
import pymongo
import sys
import urllib
import httplib, urllib
reload(sys)
sys.setdefaultencoding('u8')

rs4_conn = pymongo.mongo_client.MongoClient(\
            "rs4-1.yidian.com,rs4-2.yidian.com,rs4-arb.yidian.com", \
                read_preference=pymongo.ReadPreference.SECONDARY, \
                    replicaSet="rs4")
#rs4_conn = pymongo.Connection("10.111.0.125")
rs4_db = rs4_conn.news
#url_remote  = "http://10.111.0.28:6096/service/explain"
#url_remote  = "http://10.111.0.23:6096/service/explain"
#url_local   = "http://localhost:6096/service/authority"
#url_remote  = "http://10.111.0.22:6096/service/handle"

# call format:

if __name__ == "__main__":
    if len(sys.argv) == 2:
        # pattern for 财经类标题党
        mode = sys.argv[1]
        if mode == "1":
            # find_dict = {"$and":[{"insert_time":{"$gte":"2015-06-01 00:00:00"}}, {"cat_class":"财经"}]}
            find_dict = {"insert_time":{"$gte":"2015-11-09 00:00:00", "$lte":"2015-11-16 00:00:00"}}
            fields = ["_id", "seg_title"]
            projection = {"_id":True, "seg_title":True}
        else:
            raise Exception("Unsupported parameters!")
    elif mode == '2':
        FINDDICT = sys.argv[2]
        FIELDS = sys.argv[3]
        find_dict = json.loads(FINDDICT)
        fields = json.loads(FIELDS)
    elif sys.argv[1] == '3':
        docids, lines = [], []
        retrieve_keys = sys.argv[2].split(' ')
        for line in sys.stdin:
            parts = line.strip().split('\t')
            docid, rest = parts[0], parts[1:]
            docids.append(docid)
            lines.append(rest)
        find_dict = {"_id":{"$in":docids}}
        projection = {}
        for key in retrieve_keys:
            projection[key] = 1
    else:
        raise Exception("Unsupported parameters again!")
    document = rs4_db.data.find(find_dict,projection = projection)
    if mode == '1' or mode == '2':
        for count, item in enumerate(document):
            print json.dumps(item, ensure_ascii=False, encoding='utf8')
    elif mode == '3':
        doc_map = {}

