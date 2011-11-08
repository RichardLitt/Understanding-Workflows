"""
myExperiment Scraper by Richard L.
Released into the public domain like Wikileaks no longer is.
Delay added to be nice to the servers. Many thanks to Beautiful Soup.

"""

#Import packages
import sys
import urllib2
from BeautifulSoup import BeautifulSoup
import time
import re

#One argument at the moment - the URL.
file = open(sys.argv[1])

#The output is put into a .csv, and then later transported to the .sql
output_file_name = sys.argv[1] + ".csv"
output = open(output_file_name,'a')

#Here the code begins. Line indicates for each url in arg[1]
for line in file.readlines():
    line = line.strip()
    u = urllib2.urlopen(line.strip())

    # mung it all together
    rawhtml = "".join(map(str.strip,u.readlines()))

    bs = BeautifulSoup(rawhtml)

    #This is where we start populating the file.
    #Print the user html page address
    print "\"" + line.strip() + "\",",
    output.write("\"" + line.strip() + "\",")

    #What's the title?
    title = bs.find("h1", {"class": "contribution_title"})
    print title.contents[0].replace("Pack: ", "")
    output.write("\"" + title.contents[0].replace("Pack: ", "") + "\",")

    #What is the description?
    try:
        description_obj = bs.find("div", {"class": "contribution_description"})
        description = description_obj.contents[0]
    except:
        description = ""
    print description
    output.write("\"" + str(description) + "\",")

    #How many items are there?
    items_obj = bs.find("h4").find("span").contents[0].replace("(", "")
    items_obj = items_obj.replace(")", "")
    print items_obj
    output.write("\"" + items_obj + "\",")

    #Let's grab the workflows in this pack, their URLs, and who uploaded them. 
    try:
        packs_obj = bs.find("ul", {"id": "packItemsList"}).findAll(text='Workflow:')
        packs_url = ""
        packs_name = ""
        packs_user_url = ""
        packs_user = ""
        packs_no = 0
        for x in packs_obj:
            packs_url_obj = x.findNext("a")
            packs_url += packs_url_obj['href'] + ", "
            packs_no += 1
            packs_name += str(packs_url_obj.contents[0]) + ", "
            packs_user_obj = packs_url_obj.findNext("a")
            packs_user_url += packs_user_obj['href'] + ", "
            packs_user += packs_user_obj.contents[0] + ", "
    except:
        packs_url = ""
        packs_name = ""
        packs_user_url = ""
        packs_user = ""
        packs_no = 0
    print packs_url
    print packs_name
    print packs_user_url
    print packs_user
    print str(packs_no)
    output.write("\"" + packs_url + "\",")
    output.write("\"" + packs_name + "\",")
    output.write("\"" + packs_user_url + "\",")
    output.write("\"" + packs_user.encode('ascii', 'ignore') + "\",")
    output.write("\"" + str(packs_no) + "\",")

    #Let's grab the external links while we're at it. 
    try:
        external_obj = bs.find("ul", {"id": "packItemsList"}).findAll(text='External:')
        external = ""
        for x in external_obj:
            external_url_obj = x.findNext("a")
            external += external_url_obj['href'] + ", "
    except:
        external = ""
    print external
    output.write("\"" + external + "\",")

    #URL search for the statistics page
    time.sleep(1) #Let's be nice. 
    stats_line = line.strip().replace(".html", "") + "/statistics"
    stats_u = urllib2.urlopen(stats_line.strip())

    # mung it all together
    rawstats = "".join(map(str.strip,stats_u.readlines()))
    bstats = BeautifulSoup(rawstats)

    #print the workflow statistics address on myExperiment
    print "\"" + stats_line.strip() + "\",", 
    output.write("\"" + stats_line.strip() + "\",")

    #get the entire statistics table and output it
    stats = bstats.find("div", {"class": "box_standout"}).findAll("b")
    #total views
    total_v = str(stats[0].contents[0])
    #total downloads
    total_d = str(stats[1].contents[0])
    #views on myexperiment
    myexp_v = str(stats[2].contents[0])
    #views on myexperiment from members
    myexp_v_m = str(stats[3].contents[0])
    #views on myexperiment from anonymous IPs
    myexp_v_a = str(stats[4].contents[0])
    #downloads on myexperiment
    myexp_d = str(stats[5].contents[0])
    #downloads on myexperiment from members
    myexp_d_m = str(stats[6].contents[0])
    #downloads on myexperiment from anonymous people
    myexp_d_a = str(stats[7].contents[0])
    #external views (say, on Taverna)
    ext_v = str(stats[8].contents[0])
    #external downloads
    ext_d = str(stats[9].contents[0])
    print "\"" + total_v + "\","
    print "\"" + total_d + "\","
    print "\"" + myexp_v + "\","
    print "\"" + myexp_v_m + "\","
    print "\"" + myexp_v_a + "\","
    print "\"" + myexp_d + "\","
    print "\"" + myexp_d_m + "\","
    print "\"" + myexp_d_a + "\","
    print "\"" + ext_v + "\","
    print "\"" + ext_d + "\","
    output.write("\"" + total_v + "\",")
    output.write("\"" + total_d + "\",")
    output.write("\"" + myexp_v + "\",")
    output.write("\"" + myexp_v_m + "\",")
    output.write("\"" + myexp_v_a + "\",")
    output.write("\"" + myexp_d + "\",")
    output.write("\"" + myexp_d_m + "\",")
    output.write("\"" + myexp_d_a + "\",")
    output.write("\"" + ext_v + "\",")
    output.write("\"" + ext_d + "\",")

    #Timestamp of scrape.
    import time
    import datetime
    print "\"" + str(datetime.datetime.now()) + "\",",
    output.write("\"" + str(datetime.datetime.now()) + "\",",)

    print
    output.write("\n")
    time.sleep(1)

output.close()
