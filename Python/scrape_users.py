"""
myExperiment Scraper by Richard L.
Released into the public domain with more freedom than a bluebird over Kansas.
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


    #I believe I have your name!
    name = str(info[0].contents[1])
    print name
    output.write("\"" + name + "\",",)


    #Joined date!
    join = str(info[1].contents[1])
    print join
    output.write("\"" + join + "\",",)


    #Last Seen!
    seen = str(info[2].contents[1])
    print seen
    output.write("\"" + seen + "\",",)


    #Emails?
    email = info[3].contents[1].contents[0]
    print email
    output.write("\"" + email + "\",",)


    #How about a website?
    website = info[4].contents[1].contents[0]
    print website
    output.write("\"" + website + "\",",)


    #How about a location?
    location = info[5].contents[1]
    print location
    output.write("\"" + location + "\",",)


    #How many friends do you have, I wonder...
    friend_no = info[6].contents[0].contents[0].contents[0].replace(" Friends", "")
    print friend_no
    output.write("\"" + friend_no + "\",",)

    #let's grab the friends url, while we're at it.
    friend_url = info[6].contents[0].contents[0]
    friend_url = line.strip() + friend_url['href']
    print friend_url
    output.write("\"" + friend_url + "\",",)


    #How about we get some group information
    group_admin_no = info[7].contents[0].contents[0].contents[0].replace(" Groups (admin)", "")
    print group_admin_no
    output.write("\"" + group_admin_no + "\",",)


    #And the group URL
    group_admin_url = info[7].contents[0].contents[0]
    group_admin_url = line.strip() + group_admin_url['href']
    print group_admin_url
    output.write("\"" + group_admin_url + "\",",)


    #Why don't we get the amount of groups she's a member of
    group_member_no = info[8].contents[0].contents[0].contents[0].replace(" Groups (member)", "")
    print group_member_no
    output.write("\"" + group_member_no + "\",",)


    #And the group member URL
    group_member_url = info[8].contents[0].contents[0]
    group_member_url = line.strip() + group_member_url['href']
    print group_member_url
    output.write("\"" + group_member_url + "\",",)


    #Why don't we get the amount of packs she's got
    packs_no = info[9].contents[0].contents[0].contents[0].replace(" Packs", "")
    print packs_no
    output.write("\"" + packs_no + "\",",)


    #And the pack URL
    packs_url = info[9].contents[0].contents[0]
    packs_url = line.strip() + packs_url['href']
    print packs_url
    output.write("\"" + packs_url + "\",",)


    #Why don't we get the amount of groups she's a member of
    files_no = info[10].contents[0].contents[0].contents[0].replace(" Files", "")
    print files_no
    output.write("\"" + files_no + "\",",)


    #And the files URL
    files_url = info[10].contents[0].contents[0]
    files_url = line.strip() + files_url['href']
    print files_url
    output.write("\"" + files_url + "\",",)


    #Why don't we get the amount of workslows she's uploaded?
    wf_no = info[11].contents[0].contents[0].contents[0].replace(" Workflows", "")
    print wf_no
    output.write("\"" + wf_no + "\",",)


    #And the wf URL
    wf_url = info[11].contents[0].contents[0]
    wf_url = line.strip() + wf_url['href']
    print wf_url
    output.write("\"" + wf_url + "\",",)


    #Why don't we grok her amount of favs?
    fav_no = info[12].contents[0].contents[0].contents[0].replace(" Favourites", "")
    print fav_no
    output.write("\"" + fav_no + "\",",)


    #And the fav URL
    fav_url = info[12].contents[0].contents[0]
    fav_url = line.strip() + fav_url['href']
    print fav_url
    output.write("\"" + fav_url + "\",",)


    #How about the amount of credits she's gotten?
    credits_no = info[13].contents[0].contents[1].contents[0].replace(" times", "")
    print credits_no
    output.write("\"" + credits_no + "\",",)


    #And the credit URL
    credits_url = info[13].contents[0].contents[1]
    credits_url = line.strip() + credits_url['href']
    print credits_url
    output.write("\"" + credits_url + "\",",)


    #How about the average ratings she's gotten?
    ratings = info[15].contents[0].replace(" / 5", "")
    print ratings
    output.write("\"" + ratings + "\",",)


    #And how many ratings total?
    ratings_no = info[16].contents[0].replace("(", "").replace(" ratings in total)", "")
    print ratings_no
    output.write("\"" + ratings_no + "\",",)


    #How about their autobio?
    autobio = info[18].contents[0]
    print autobio
    output.write("\"" + autobio + "\",",)


    #Interests?
    interests = info[21].contents[0]
    print interests
    output.write("\"" + interests  + "\",",)


    #Field/Industry
    field = info[22].contents[1]
    print field
    output.write("\"" + field + "\",",)


    #Occupation
    occupation = info[23].contents[1]
    print occupation
    output.write("\"" + occupation  + "\",",)


    #Organisation
    organisation = info[25].contents[0]
    print organisation
    output.write("\"" + organisation + "\",",)

    #URL search for the friends page
    time.sleep(1) #Let's be nice. 
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
    output.write("\"" + friends  + "\",",)

    print

    #Time for a new line, don't you think?
    output.write("\n")

    #Let's be nice. Note - disabled for my own server, because who cares.
    time.sleep(1)

output.close()
