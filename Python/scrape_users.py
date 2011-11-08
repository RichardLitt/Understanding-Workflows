"""
myExperiment Scraper by Richard L.
Released into the public domain with more freedom than a bluebird from a cage.
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
    #This line is going to be important eventually - for now, it's not.
    line = line.strip()# + "/statistics"
    u = urllib2.urlopen(line.strip())

    # mung it all together
    rawhtml = "".join(map(str.strip,u.readlines()))

    bs = BeautifulSoup(rawhtml)

    #This is where we start populating the file.
    #Print the user html page address
    print "\"" + line.strip() + "\",",
    output.write("\"" + line.strip() + "\",",)

    #This is where we try and get the information we want.
    info = bs.findAll("p")

    try:
        #I believe I have your name!
        name = ""
        name_regex = re.compile("Name")
        for x in bs.find("td", {"style": "padding-left: 1em; vertical-align: top;"}).findAll("p"):
            v = x.contents[0].contents[0]
            matcher = re.match(name_regex,v)
            if (matcher != None):
                name = x.contents[1].encode('ascii', 'ignore')
        print name
        output.write("\"" + name + "\",",)
    except:
        output.write("Account not activated. \n")
        continue


    #Joined date!
    join = ""
    regex = re.compile("Joined")
    for x in bs.find("td", {"style": "padding-left: 1em; vertical-align: top;"}).findAll("p"):
        v = x.contents[0].contents[0]
        matcher = re.match(regex,str(v))
        if (matcher != None):
            join = x.contents[1]
    output.write("\"" + join + "\",",)
    print join


    #Last Seen!
    regex = re.compile("Last seen")
    seen = ""
    for x in bs.find("td", {"style": "padding-left: 1em; vertical-align: top;"}).findAll("p"):
        v = x.contents[0].contents[0]
        matcher = re.match(regex,v)
        if (matcher != None):
            seen = x.contents[1]
    output.write("\"" + seen + "\",",)
    print seen


    #Emails?
    emails = ""
    regex = re.compile("Email")
    for x in bs.find("td", {"style": "padding-left: 1em; vertical-align: top;"}).findAll("p"):
        v = x.contents[0].contents[0]
        matcher = re.match(regex,v)
        if (matcher != None):
            email = x.contents[1].contents[0].replace("Not specified", "")
    print email
    output.write("\"" + email + "\",",)


    #How about a website?
    web = ""
    regex = re.compile("Website")
    for x in bs.find("td", {"style": "padding-left: 1em; vertical-align: top;"}).findAll("p"):
        v = x.contents[0].contents[0]
        matcher = re.search(regex,v)
        if (matcher != None):
            web = x.contents[1].contents[0].replace("Not specified", "").encode('ascii', 'ignore')
    print web
    output.write("\"" + web + "\",",)


    #How about a location?
    location = ""
    regex = re.compile("Location")
    for x in bs.find("td", {"style": "padding-left: 1em; vertical-align: top;"}).findAll("p"):
        v = x.contents[0].contents[0]
        matcher = re.search(regex,v)
        if (matcher != None):
            location = x.contents[1]
    print location
    try:
        output.write("\"" + str(location).replace("<font class=\"none_text\">Not specified</font>", "").encode('ascii', 'ignore') + "\",",)
    except:
        output.write("\"" + str(location).replace("<font class=\"none_text\">Not specified</font>", "") + "\",",)

    stats_box = bs.find("div", {"class": "stats_box"}).findAll("p")


    #How many friends do you have, I wonder...
    #let's grab the friends url, while we're at it.
    friend_no = ""
    friend_url = ""
    regex = re.compile("Friend")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            friend_no = x.contents[0].contents[0].contents[0].replace(" Friends", "")
            friend_url = x.contents[0].contents[0]
            friend_url = "http://www.myexperiment.org" + friend_url['href']
    print friend_no
    output.write("\"" + friend_no + "\",",)
    print friend_url
    output.write("\"" + friend_url + "\",",)


    #How about we get some group admin information
    group_a_no = ""
    group_a_url = ""
    regex = re.compile("admin")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            group_a_no = x.contents[0].contents[0].contents[0].replace(" Groups (admin)", "")
            group_a_url = x.contents[0].contents[0]
            group_a_url = "http://www.myexperiment.org" + group_a_url['href']
    print group_a_no
    output.write("\"" + group_a_no + "\",",)
    print group_a_url
    output.write("\"" + group_a_url + "\",",)


    #Why don't we get the amount of groups she's a member of
    group_m_no = ""
    regex = re.compile("member")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            group_m_no = x.contents[0].contents[0].contents[0].replace(" Groups (member)", "")
    print group_m_no
    output.write("\"" + group_m_no + "\",",)


    #Why don't we get the amount of packs she's got
    packs_no = ""
    packs_url = ""
    regex = re.compile("Packs")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            packs_no = x.contents[0].contents[0].contents[0].replace(" Packs", "")
            packs_url = x.contents[0].contents[0]
            packs_url = "http://www.myexperiment.org" + packs_url['href']
    print packs_no
    output.write("\"" + packs_no + "\",",)
    print packs_url
    output.write("\"" + packs_url + "\",",)


    #Why don't we get the amount of files she's got
    files_no = ""
    files_url = ""
    regex = re.compile("Files")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            files_no = x.contents[0].contents[0].contents[0].replace(" Files", "")
            files_url = x.contents[0].contents[0]
            files_url = "http://www.myexperiment.org" + files_url['href']
    print files_no
    output.write("\"" + files_no + "\",",)
    print files_url
    output.write("\"" + files_url + "\",",)


    #Why don't we get the amount of workflows she's uploaded?
    wfs_no = ""
    wfs_url = ""
    regex = re.compile("Workflows")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            wfs_no = x.contents[0].contents[0].contents[0].replace(" Workflows", "")
            wfs_url = x.contents[0].contents[0]
            wfs_url = "http://www.myexperiment.org" + wfs_url['href']
    print wfs_no
    output.write("\"" + wfs_no + "\",",)
    print wfs_url
    output.write("\"" + wfs_url + "\",",)


    #Why don't we grok her amount of favs?
    favs_no = ""
    favs_url = ""
    regex = re.compile("Favourites")
    for x in stats_box:
        matcher = re.search(regex,str(x))
        if (matcher != None):
            favs_no = x.contents[0].contents[0].contents[0].replace(" Favourites", "")
            favs_url = x.contents[0].contents[0]
            favs_url = "http://www.myexperiment.org" + favs_url['href']
    print favs_no
    output.write("\"" + favs_no + "\",",)
    print favs_url
    output.write("\"" + favs_url + "\",",)


    #How about the amount of credits she's gotten?
    csb = bs.findAll("div", {"class": "contribution_section_box"})[1].find("a")
    credits_no = csb.contents[0].replace(" times", "")
    print credits_no
    output.write("\"" + credits_no + "\",",)


    #And the credit URL
    credits_url = "http://www.myexperiment.org" + csb['href']
    print credits_url
    output.write("\"" + credits_url + "\",",)


    #How about the average ratings she's gotten?
    csb = bs.findAll("div", {"class": "contribution_section_box"})[2]
    ratings = csb.contents[1].contents[0].replace(" / 5", "")
    print ratings
    output.write("\"" + ratings + "\",",)

    #And how many ratings total?
    ratings_no = csb.contents[2].contents[0].replace("(", "").replace(" ratings in total)", "")
    print ratings_no
    output.write("\"" + ratings_no + "\",",)


    #How about their autobio?
    bso = bs.findAll("div", {"class": "box_standout"})[0]
    try:
        try:
            autobio = bso.contents[0].contents[0].replace("Description/summary not set", "").encode('ascii', 'ignore')
        except:
            autobio = bso.contents[0].contents[0]
    except:
        autobio = ""
    print autobio
    output.write("\"" + str(autobio) + "\",",)


    bsi = bs.findAll("div", {"class": "box_simple"})[0]


    #Other contact details
    try:
        ocd = bsi.contents[1].contents[0].replace("Not specified", "")
    except:
        ocd = bsi.contents[1].contents[0]
    print ocd
    try:
        output.write("\"" + str(ocd) + "\",",)
    except:
        output.write("\"" + "[chinese characters]" + "\",",)

    #Interests?
    try:
        try:
            interests = bsi.contents[3].contents[0].replace("Not specified", "")
        except:
            interests = bsi.contents[3].contents[0]
    except:
        interests = ""
    print interests
    output.write("\"" + str(interests)  + "\",",)


    bsi = bs.findAll("div", {"class": "box_simple"})[1]


    #Field/Industry
    field = bsi.contents[0].contents[1]
    print field
    output.write("\"" + str(field).replace("<font class=\"none_text\">Not specified</font>", "") + "\",",)


    #Occupation
    try:
        occupation = bsi.contents[1].contents[1]
    except:
        occupation = ""
    print occupation
    output.write("\"" + str(occupation).replace("<font class=\"none_text\">Not specified</font>", "") + "\",",)


    #Organisation
    organisation = bsi.contents[3].contents[0].replace("Not specified", "").encode('ascii', 'ignore')
    print organisation
    output.write("\"" + organisation + "\",",)

    #URL search for the friends page
    #time.sleep(1) #Let's be nice. 
    friends_line = line.strip().replace(".html", "") + "/friends"
    friends_u = urllib2.urlopen(friends_line.strip())

    # mung it all together
    rawstats = "".join(map(str.strip,friends_u.readlines()))
    fr = BeautifulSoup(rawstats)

    #print the workflow friends address on myExperiment
    print "\"" + friends_line.strip() + "\",", 
    output.write("\"" + friends_line.strip() + "\",",)

    #get the entire friends url and output it
    friends_obj = fr.findAll("td", {"class": "mid"})
    friends_url = ""
    for x in friends_obj:
        friends_url_obj = x.find("a")
        friends_url += friends_url_obj['href'] + ", "
    print friends_url
    output.write("\"" + friends_url  + "\",",)

    #Get the friends names
    friends_obj = fr.findAll("td", {"class": "mid"})
    friends = ""
    for x in friends_obj:
        friends_obj = x.find("a")
        friends += friends_obj.contents[0] + ", "
    print friends
    output.write("\"" + friends.encode('ascii', 'ignore')  + "\",",)

    #Timestamp of scrape.
    import time
    import datetime
    print "\"" + str(datetime.datetime.now()) + "\",",
    output.write("\"" + str(datetime.datetime.now()) + "\",",)

    print

    #Time for a new line, don't you think?
    output.write("\n")

    #Let's be nice. Note - disabled for my own server, because who cares.
    time.sleep(.5)

output.close()
