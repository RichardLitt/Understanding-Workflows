"""
myExperiment Scraper by Richard L.

Released into the Public Domain like chimps into space. Free.
Delay added to be nice to the servers. Many thanks to Beautiful Soup.

This scrapes the groups pages.

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

    #print the workflow group address on myExperiment
    print line.strip() + ", "
    output.write("\"" + line.strip() + "\",",)

    title = bs.find("h1").contents[0].replace("Group: ", "")
    print title + ", "
    output.write("\"" +  title + "\",",)

    mini_nav = bs.find("div", {"class": "contribution_mini_nav"}).findAll("a")

    #members = mini_nav[0].contents[0].replace("Members (", "")
    #print members

    #This seems to work at the moment, so we're going to go with this. 
    members = re.search("(\d+)",str(mini_nav[0]))
    print members.group(0) + ", "
    output.write("\"" +  members.group(0) + "\",",)

    news = re.search("(\d+)",str(mini_nav[1].contents[0]))
    if (news != None):
        print news.group(0) + ", "
        output.write("\"" +  news.group(0) + "\",",)
    elif (news == None):
        print ", "
        output.write("\"" + ""  + "\",",)

    shared_items = re.search("(\d+)",str(mini_nav[2].contents[0]))
    if (shared_items != None):
        print shared_items.group(0) + ", "
        output.write("\"" + shared_items.group(0)  + "\",",)
    elif (shared_item == None):
        print ", "
        output.write("\"" + ""  + "\",",)


    creditations = re.search("(\d+)",str(mini_nav[3].contents[0]))
    if (creditations != None):
        print creditations.group(0) + ", "
        output.write("\"" + creditations.group(0)  + "\",",)
    elif (creditations == None):
        print ", "
        output.write("\"" + ""  + "\",",)

    #How many tags are there?
    tags_no = re.search("(\d+)",str(mini_nav[4].contents[1]))
    if (tags_no != None):
        print tags_no.group(0) + ", "
        output.write("\"" + tags_no.group(0)  + "\",",)
    elif (tags_no == None):
        print ", "
        output.write("\"" + ""  + "\",",)


    announcements = re.search("(\d+)",str(mini_nav[5].contents[0]))
    if (announcements != None):
        print announcements.group(0) + ", "

        output.write("\"" + announcements.group(0)  + "\",",)
    elif (announcements == None):
        print ", "
        output.write("\"" + ""  + "\",",)


    comments = re.search("(\d+)",str(mini_nav[6].contents[0]))
    if (comments != None):
        print comments.group(0) + ", "
        output.write("\"" + comments.group(0) + "\",",)
    elif (comments == None):
        print ", "
        output.write("\"" + ""  + "\",",)

    #Let's get that massive description block raw. 
    #Might have an issue with " eventually in this block. 
    description = bs.find("div", {"class": "box_simple"})#.replace("\"", "'")
    print "description goes here"
    output.write("\"" + str(description) + "\",",)

    #When was this created?
    creation_date = bs.find("div", {"class":
        "contribution_left_box"}).contents[1].contents[1]
    print creation_date
    output.write("\"" + creation_date + "\",",)

    #What is the unique name?
    unique_name = bs.find("div", {"class":
        "contribution_left_box"}).contents[2].contents[1]
    print unique_name
    output.write("\"" + unique_name + "\",",)

    #Who are the members?
    members_obj = bs.findAll("li", {"class": "member"})
    members = ""
    for x in members_obj:
        members_u = x.contents[0].contents[0]
        members += members_u['href'] + ", " 
    print members
    output.write("\"" + members + "\",",)

    #Who is the admin?
    #How many admins are there?
    #There might be an error with multiple authors. Should check. 
    admin_obj = bs.findAll("div", {"id": "hlist"})[0].find("a")
    admin = ""
    admin_no = 0
    for x in admin_obj:
        admin += admin_obj['href']
        admin_no += 1
    print admin
    print admin_no
    output.write("\"" + admin + "\",",)
    output.write("\"" + str(admin_no) + "\",",)

    #What tags have users given it?
    #Why don't we grab the urls as well?
    tags_obj = bs.find("div", {"id": "user_tags"}).findAll("a")
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

    #Why don't we get all of the information on the shared files?
    #Well, is it relevant to anything? no, probably not. So, maybe not.
    #Ok then. 

    #Same with the comments. 

    print
    output.write("\n")
    #time.sleep(1)

output.close()
