import sys
import re
import string

with open(sys.argv[1]) as f:
    line_buf = ""
    for line in f:
        if not re.match(r"^\d+$", line) and not re.match(r".* \-\-> ", line):
            line_buf += line.rstrip('\n') + ' '
            if re.match(r".*[.!?] ?$", line):
                print line_buf
                line_buf = ""
                #line_buf += "\n"
    #print line_buf
