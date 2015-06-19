import datetime
import sys

if __name__ == "__main__":
    dates = []
    for arg in sys.argv[1:]:
        if(arg == "today"):
            dates.append(datetime.date.today())
        else:
            if(len(arg.split('-')) != 3):
                print "Parameter number = {0} is illegal!".format(arg.split('-'))
                exit(1)
            year, month, day = [int(i) for i in arg.split('-')]
            dates.append(datetime.date(year, month, day))
    if len(dates) > 2:
        print "Warning: too much parameters given: {0}".format(len(dates))
    print '  Duration days: {0:6d}'.format((dates[1] - dates[0]).days)
