#coding:u8
import json
import traceback
import sys
reload(sys)
sys.setdefaultencoding('u8')

#parse info by given column name
def serial(col_data):
    if type(col_data) is list:
        return ', '.join(col_data)
    elif type(col_data) is str:
        return col_data
    else:
        return str(col_data)

def parseJsonDict(line, *column_names):
    line = line.strip()
    info = json.loads(line)
    res_col_s = []
    if len(column_names) == 1 and type(column_names) is tuple:
        column_names = column_names[0]
    for index, column in enumerate(column_names):
        if column in info:
            col_data = info[column]
            col_data_s = serial(col_data)
            res_col_s.append(col_data_s)
        else:
            if index == 0:
                raise Exception("[Error] Missing ID column: {0} for line: {1}".format(column, line))
            else:
                res_col_s.append('')
    return '\t'.join(res_col_s)

if __name__ == "__main__":
    total_linecount = int(sys.argv[1])
    column_names = sys.argv[2:]
    cur_percentage = 0
    for linecount, line in enumerate(sys.stdin):
        if 1.0 * linecount / total_linecount > cur_percentage:
            print >> sys.stderr, "Processed {0}%...".format(cur_percents)
            cur_percentage += .01
            cur_percents += 1
        try:
            print parseJsonDict(line, column_names)
        except:
            exc_type, exc_value, exc_traceback = sys.exc_info()
            traceback.print_exception(exc_type, exc_value, exc_traceback, limit=2, file=sys.stderr)

