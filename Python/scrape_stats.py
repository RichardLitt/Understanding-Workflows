"""
myExperiment Scraper by Richard L.

Released into the Public Domain like pythons south of Tallahassee. Free.  
Delay added to be nice to the servers. Many thanks to Beautiful Soup.

This scrapes the stats pages, and still relies on a file with all of the workflow urls preloaded. 

"""

import sys
import urllib2
from BeautifulSoup import BeautifulSoup
import time
import re

file = open(sys.argv[1])

output_file_name = sys.argv[1] + ".csv"
output = open(output_file_name,'a')

for line in file.readlines():
	line = line.strip() + "/statistics"
	u = urllib2.urlopen(line.strip())
	
	
	# mung it all together
	rawhtml = "".join(map(str.strip,u.readlines()))
	
	bs = BeautifulSoup(rawhtml)
	
	
	#print the workflow statistics address on myExperiment
	print "\"" + line.strip() + "\",", 
	output.write("\"" + line.strip() + "\",",)
	
	#get the entire statistics table and output it
	stats = bs.find("div", {"class": "box_standout"}).findAll("b")
	#total views
	total_v = str(stats[0].contents[0]) + ", "
	#total downloads
	total_d = str(stats[1].contents[0]) + ", "
	#views on myexperiment
	myexp_v = str(stats[2].contents[0]) + ", "
	#views on myexperiment from members
	myexp_v_m = str(stats[3].contents[0]) + ", "
	#views on myexperiment from anonymous IPs
	myexp_v_a = str(stats[4].contents[0]) + ", "
	#downloads on myexperiment
	myexp_d = str(stats[5].contents[0]) + ", "
	#downloads on myexperiment from members
	myexp_d_m = str(stats[6].contents[0]) + ", "
	#downloads on myexperiment from anonymous people
	myexp_d_a = str(stats[7].contents[0]) + ", "
	#external views (say, on Taverna)
	ext_v = str(stats[8].contents[0]) + ", "
	#external downloads
	ext_d = str(stats[9].contents[0]) + ", "
	print "\"" + total_v + "\",",
	print "\"" + total_d + "\",",
	print "\"" + myexp_v + "\",",
	print "\"" + myexp_v_m + "\",",
	print "\"" + myexp_v_a + "\",",
	print "\"" + myexp_d + "\",",
	print "\"" + myexp_d_m + "\",",
	print "\"" + myexp_d_a + "\",",
	print "\"" + ext_v + "\",",
    print "\"" + ext_d + "\",",
	output.write("\"" + total_v + "\",",)
	output.write("\"" + total_d + "\",",)
	output.write("\"" + myexp_v + "\",",)	
	output.write("\"" + myexp_v_m + "\",",)
	output.write("\"" + myexp_v_a + "\",",)
	output.write("\"" + myexp_d + "\",",)	
	output.write("\"" + myexp_d_m + "\",",)
	output.write("\"" + myexp_d_a + "\",",)
	output.write("\"" + ext_v + "\",",)	
	output.write("\"" + ext_d + "\",",)	
				
	print
	output.write("\n")
	time.sleep(1)
	
output.close()
