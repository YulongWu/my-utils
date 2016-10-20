import sys
import json

# extract column by its name in json
# call format: cat input.json | python pip_json_extractor.py ''["_id"]'' > docid.out
if __name__ == "__main__":
    headers = json.loads(sys.argv[1])
    for line in sys.stdin:
        info = json.loads(line)
        cols = []
        for header in headers:
            cols.append(info[header])
        print "\t".join(cols)
