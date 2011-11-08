"""
myExperiment Scraper by Richard L.

Released into the Public Domain like college students without debt. Free. 
Delay added to be nice to the servers. Many thanks to Beautiful Soup.

This scrapes the files pages.

"""
#Import time
import sys
import urllib2
from BeautifulSoup import BeautifulSoup
import time
import re

#The URLS of the groups you want to scrape.
file = open(sys.argv[1])

#.csv, which should then ideally be put into an .sql
output_file_name = sys.argv[1] + ".csv"
output = open(output_file_name,'a')

for line in file.readlines():
    u = urllib2.urlopen(line.strip())


    # mung it all together
    rawhtml = "".join(map(str.strip,u.readlines()))

    bs = BeautifulSoup(rawhtml)

    #print the file address on myExperiment
    print line.strip() + ", "
    output.write("\"" + line.strip() + "\",",)
    #Let's get the title!
    title = bs.find("h1", {"class": "contribution_title"})
    print title.contents[0].replace("File Entry: ", "").encode('ascii', 'ignore') + ", "
    output.write("\"" + title.contents[0].replace("File Entry: ",
    "").encode('ascii', 'ignore') + "\",",)

    #When was it created? When was it uploaded?
    created_obj = bs.find("div", {"class":
        "contribution_aftertitle"})
    created = created_obj.contents[1].replace("&nbsp;", "")
    try:
        uploaded = created_obj.contents[3].replace("&nbsp;", "")
    except:
        uploaded = ""
    print created + ", " + uploaded + ", "
    output.write("\"" + created + "\",",)
    output.write("\"" + uploaded + "\",",)

    mini_nav = bs.find("div", {"class": "contribution_mini_nav"}).findAll("a")

    #How many credits does it have?
    credits_no = re.search("(\d+)",str(mini_nav[1]))
    print credits_no.group(0) + ", "
    output.write("\"" +  credits_no.group(0) + "\",",)

    #Attributions?
    att_no = re.search("(\d+)",str(mini_nav[2]))
    print att_no.group(0) + ", "
    output.write("\"" +  att_no.group(0) + "\",",)

    #Tags?
    tags_no = re.search("(\d+)",str(mini_nav[3]))
    print tags_no.group(0) + ", "
    output.write("\"" +  tags_no.group(0) + "\",",)

    #Featured in packs?
    featured_no = re.search("(\d+)",str(mini_nav[4]))
    print featured_no.group(0) + ", "
    output.write("\"" +  featured_no.group(0) + "\",",)

    #Ratings?
    ratings_no = re.search("(\d+)",str(mini_nav[5]))
    print ratings_no.group(0) + ", "
    output.write("\"" +  ratings_no.group(0) + "\",",)

    #Attributed by?
    attby_no = re.search("(\d+)",str(mini_nav[6]))
    print attby_no.group(0) + ", "
    output.write("\"" +  attby_no.group(0) + "\",",)

    #Rated by?
    ratby_no = re.search("(\d+)",str(mini_nav[7]))
    print ratby_no.group(0) + ", "
    output.write("\"" +  ratby_no.group(0) + "\",",)

    #File Name?
    file_name = bs.find("div", {"class": "contribution_version_inner_box"})
    file_name = file_name.contents[1].contents[1]
    print file_name
    output.write("\"" +  file_name + "\",",)


    #File type?
    file_type = bs.find("div", {"class": "contribution_version_inner_box"})
    file_type = file_type.contents[2].contents[1]
    print file_type
    output.write("\"" +  file_type + "\",",)

    #Description?
    description = bs.find("div", {"class": "contribution_version_inner_box"})
    description = str(description.contents[5]).replace("\"", "")
    print description
    output.write("\"" + description + "\",",)

    #What's the download url?
    try:
        download = bs.find("div", {"class": "contribution_version_inner_box"})
        download = download.contents[8].contents[0].contents[0].contents[0]['href']
    except:
        download = ""
    print download
    output.write("\"" +  download + "\",",)

    #Who uploaded it?
    uploader_obj = bs.find("div", {"class": "contribution_section_box"})
    uploader_url = uploader_obj.contents[1].contents[0].contents[0].contents[0]['href']
    uploader = uploader_obj.contents[1].contents[0].contents[0].contents[0].contents[0]['title']
    print uploader_url + ", " + uploader + ", "
    output.write("\"" + uploader_url  + "\",",)
    output.write("\"" + uploader.encode('ascii', 'ignore')  + "\",",)

    #What is the licence?
    license_obj = bs.find("div", {"class": "contribution_currentlicense"})
    license = license_obj.contents[0]
    print str(license) + ", "
    output.write("\"" + str(license)  + "\",",)

    #Who has credited this?
    try:
        credit_obj = bs.findAll("div", {"class": "contribution_section_box"})[2]
        credit_url = credit_obj.findAll("a")[1]['href']
        credit = credit_obj.findAll("a")[1]
        credit = credit.contents[0]
    except:
        credit = ""
        credit_url = ""
    print credit + ", " + credit_url + ", "
    output.write("\"" + credit.encode('ascii', 'ignore') + "\",",)
    output.write("\"" + credit_url  + "\",",)

    #No attribution information.

    #What tags are popular/uploader for this?
    #Why don't we grab the urls as well?
    tags_obj = bs.find("ul", {"class": "popularity"}).findAll("a")
    tags_url = ""
    tags = ""
    for x in tags_obj:
        tags_url_obj = x['href'] + ", "
        tags_url += tags_url_obj
        tags_name = x.contents[0]
        tags += tags_name + ", "
    print tags_url
    print tags
    output.write("\"" + tags_url + "\",",)
    output.write("\"" + tags + "\",",)

    #Not shared with groups.

    #What packs is this featured in?
    try:
        pack_obj = bs.findAll("div", {"class": "contribution_section_box"})[5]
        pack_url = pack_obj.findAll("a")[1]['href']
        pack = pack_obj.findAll("a")[1]
        pack = pack.contents[0]
    except:
        pack = ""
        pack_url = ""
    print pack + ", " + pack_url + ", "
    output.write("\"" + pack  + "\",",)
    output.write("\"" + pack_url  + "\",",)

    #No ratings
    #No attributed by
    #No favourited by

    #Statistics should be done by calling statistics page
    #Need to download and do this. 

    #Do we need the comments? Probably not, to be honest.

    #URL search for the statistics page
    time.sleep(1) #Let's be nice. 
    stats_line = line.strip().replace(".html", "") + "/statistics"
    stats_u = urllib2.urlopen(stats_line.strip())

    # mung it all together
    rawstats = "".join(map(str.strip,stats_u.readlines()))
    bstats = BeautifulSoup(rawstats)

    #print the workflow statistics address on myExperiment
    print "\"" + stats_line.strip() + "\",", 
    output.write("\"" + stats_line.strip() + "\",",)

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

    #Timestamp of scrape.
    import time
    import datetime
    print "\"" + str(datetime.datetime.now()) + "\",",
    output.write("\"" + str(datetime.datetime.now()) + "\",",)

    print
    output.write("\n")
    time.sleep(1)

output.close()
