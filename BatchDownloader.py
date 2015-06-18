import urllib
urlbase = r"http://mp3.en8848.com/meiwen/jqcd50/"
local = r"/Users/frankiewu/Downloads/meiwen/"
for i in range(8,39):
    resource = str(i).zfill(2) + '.mp3'
    url = urlbase + resource
    print "Downloading " + url
    urllib.urlretrieve(url, local+resource);
