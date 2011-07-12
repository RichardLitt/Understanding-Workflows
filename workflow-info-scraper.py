"""
myExperiment Scraper by Steve K. and Richard L.
Released into the Public Domain like pythons south of Tallahassee. Free.  
Delay added to be nice to the servers. Many thanks to Beautiful Soup.

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
	u = urllib2.urlopen(line.strip())
	
	# mung it all together
	rawhtml = "".join(map(str.strip,u.readlines()))

	bs = BeautifulSoup(rawhtml)

	#Print the workflow address on myExperiment
	print "\"" + line.strip() + "\",", 
	output.write("\"" + line.strip() + "\",",)
	
	#Print the link to the .svg image
	print "\"" + line.strip() + "/versions/1/previews/full\",", 
	output.write("\"" + line.strip() + "/versions/1/previews/full\",",)

    # Get the title
	title_obj = bs.find("h1", {"class": "contribution_title"})
	title = title_obj.contents[0].replace("Workflow Entry: ","").encode('ascii', 'ignore')
	print "\"" + title.strip() + "\",",
	output.write("\"" + title.strip() + "\",",)
	
	# Get the dates
	date_obj = bs.find("div", {"class": "contribution_aftertitle"})
	date_created = date_obj.contents[1].replace(" ","")
	date_created = date_created.replace("&nbsp;","")
	print "\"" + date_created.strip() + "\",", 
	output.write("\"" + date_created.strip() + "\",", )
	date_updated = ""
	if len(date_obj.contents) == 4:
		date_updated = date_obj.contents[3].replace(" ","")
	print "\"" + date_updated.strip() + "\",",
	output.write("\"" + date_updated.strip() + "\",",)

	# Get the author
	author_obj = bs.findAll("div", {"class": "contribution_section_box"})[1].find("a")
	author = author_obj['href']
	print "\"" + author.strip() + "\",",
	output.write("\"" + author.strip() + "\",",)
	
	# Get the workflow system type
	type_obj = bs.findAll("div", {"class": "contribution_section_box"})[0].find("a")
	wftype = type_obj.contents[0]
	print "\"" + wftype.strip() + "\",", 
	output.write("\"" + wftype.strip() + "\",", )
	
	# Get the natural language description
	try:
		desc_obj = bs.find("div", {"class": "contribution_description"}).findAll("p")
		description = ""
		for x in desc_obj:
			description += str(x.contents[0]).encode('ascii', 'ignore') + " "
		print "\"" + description.strip() + "\",",
		output.write("\"" + description.strip() + "\",",) 
	except:
		print ","
		output.write(",")
	
	#Get the tags
	tags_obj = bs.find("div", {"class": "hTagcloud"}).findAll("a")
	tags = ""
	for i in tags_obj:
		tags += i.contents[0] + ", "
	print "\"" + tags[:-2].strip() +"\",",
	output.write("\"" + tags[:-2].strip() +"\",",)
	
	#Get the statistics
	stats_obj = bs.find("div", {"class": "stats_box"}).findAll("p")
	viewings = stats_obj[0].contents[0].replace(" viewings", "")
	print "\"" + viewings.strip() + "\",",  #Viewings
	output.write("\"" + viewings.strip() + "\",",)
	
	downloads = stats_obj[1].contents[0].replace(" downloads", "")
	print "\"" + downloads.strip() + "\",", #Downloads
	output.write("\"" + downloads.strip() + "\",",)
	
	number_regex = re.compile(".*(\d+)")
	for x in bs.find("div", {"class": "stats_box"}).findAll("a"):
		v = x.contents[0]
		match_o = re.match(number_regex,v)
		if (match_o != None):
			print "\"" + match_o.group(0) + "\",",
			output.write("\"" + match_o.group(0) + "\",",)
	
	others_obj = bs.findAll("div", {"class": "foldTitle"})
	for y in others_obj:
		v = y.contents[0]
		if len(y.contents) == 2:
			v = y.contents[1]
		match_o = re.match(number_regex,v)
		if (match_o != None):
			print "\"" + match_o.group(1) + "\",",
			output.write("\"" + match_o.group(1) + "\",",)

	print
	output.write("\n")
	time.sleep(1)
	
output.close()
