"""
myExperiment Scraper by Steve K. and Richard L.
Released into the Public Domain like pythons south of Tallahassee. Free.  
Delay added to be nice to the servers. Many thanks to Beautiful Soup.

NB: You need to remove wf_img, WF_N, stat_URL, views_s, downloads_s, as they are pretty much useless. 
And as you removed them from the code, so they won't be showing up anymore, anyway. 


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

    #print the workflow address on myExperiment
    print "\"" + line.strip() + "\",", 
    output.write("\"" + line.strip() + "\",",)

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
    
    #Get the amount of versions
    vers_obj = bs.find("td", {"class": "heading"}).findAll("span")[1]
    version = vers_obj.contents[0].replace("(of ", "").replace(")", "")
    print "\"" + version + "\",", 
    output.write("\"" + version + "\",", )

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
            description += str(x.contents[0]).encode('ascii', 'ignore').replace("\"", "") + " "
    #    print "\"" + description.strip() + "\",",
        output.write("\"" + description.strip() + "\",",) 
    except:
    #    print ","
        output.write(",")
    
    #Get the tags
    tags_obj = bs.find("div", {"class": "hTagcloud"}).findAll("a")
    tags = ""
    for i in tags_obj:
        tags += i.contents[0] + ", "
    print "\"" + tags[:-2].strip() +"\",",
    output.write("\"" + tags[:-2].strip() + "\",",)
    
    #Get the viewings
    stats_obj = bs.find("div", {"class": "stats_box"}).findAll("p")
    viewings = stats_obj[0].contents[0].replace(" viewings", "")
    print "\"" + viewings.strip() + "\",",  #Viewings
    output.write("\"" + viewings.strip() + "\",",)
    
    #Get the downloads
    downloads = stats_obj[1].contents[0].replace(" downloads", "")
    print "\"" + downloads.strip() + "\",", #Downloads
    output.write("\"" + downloads.strip() + "\",",)
    
    #URL search for the statistics page, which is a separate URL. 
    time.sleep(1) #Let's be nice. 
    stats_line = line.strip().replace(".html", "") + "/statistics"
    stats_u = urllib2.urlopen(stats_line.strip())
    rawstats = "".join(map(str.strip,stats_u.readlines()))
    bstats = BeautifulSoup(rawstats)
    
    #get the entire statistics table and output it
    stats = bstats.find("div", {"class": "box_standout"}).findAll("b")
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
    print "\"" + myexp_v + "\",",
    print "\"" + myexp_v_m + "\",",
    print "\"" + myexp_v_a + "\",",
    print "\"" + myexp_d + "\",",
    print "\"" + myexp_d_m + "\",",
    print "\"" + myexp_d_a + "\",",
    print "\"" + ext_v + "\",",
    print "\"" + ext_d + "\",",
    output.write("\"" + myexp_v + "\",",)    
    output.write("\"" + myexp_v_m + "\",",)
    output.write("\"" + myexp_v_a + "\",",)
    output.write("\"" + myexp_d + "\",",)    
    output.write("\"" + myexp_d_m + "\",",)
    output.write("\"" + myexp_d_a + "\",",)
    output.write("\"" + ext_v + "\",",)    
    output.write("\"" + ext_d + "\",",)
    
    #Get the more section
    number_regex = re.compile("\d+")
    for x in bs.find("div", {"class": "stats_box"}).findAll("a"):
        v = x.contents[0]
        match_o = re.match(number_regex,v)
        if (match_o != None):
            print "\"" + match_o.group(0) + "\",",
            output.write("\"" + match_o.group(0) + "\",",)

    if (sys.argv[2] == "taverna_1")    or (sys.argv[2] == "taverna_2") or (sys.argv[2] == "rapidminer"):
        #Get the numerical metadata
        others_obj = bs.findAll("div", {"class": "foldTitle"})
        for y in others_obj:
            v = y.contents[0]
            if len(y.contents) == 2:
                v = y.contents[1]
            match_o = re.search(number_regex,v)
            if (match_o != None):
                print "\"" + match_o.group(0) + "\",",
                output.write("\"" + match_o.group(0) + "\",",)
        
        #Get more of the metadata (non-numerical)
        others_con = bs.findAll("div", {"class": "foldContent"})
        t = []
        for x in others_con:
            others_b = x.findAll("tr")
            t.append(others_b)
        
        if (sys.argv[2] == "rapidminer"):
            #Get the names of the operators
            op_names = ""
            for x in t[1]:
                op_name = x.find("td")
                if (op_name != None):
                    op_names += op_name.contents[0].encode('ascii', 'ignore') + ", "
            print "\"" + op_names + "\",",
            output.write("\"" + op_names + "\",",)
    
            #Get the names of the outputs
            output_names = ""
            for x in t[2]:
                output_name = x.find("b")
                if (output_name != None):
                    output_names += output_name.contents[0] + ", "
            print "\"" + output_names + "\",",
            output.write("\"" + output_names + "\",",)        
        
        if (sys.argv[2] == "taverna_1")    or (sys.argv[2] == "taverna_2"):
            try:
                #Get the names of the inputs
                input_names = ""
                if (sys.argv[2] == "taverna_1"):
                    input_var = t[0]
                elif (sys.argv[2] == "taverna_2"):
                    input_var = t[3]
                    
                for x in input_var:
                    input_name = x.find("b")
                    if (input_name != None):
                        input_names += input_name.contents[0] + ", "
                print "\"" + input_names + "\",",
                output.write("\"" + input_names + "\",",)
            
                #Get the processor names
                proc_names = ""
                if (sys.argv[2] == "taverna_1"):
                    proc_var = t[1]
                elif (sys.argv[2] == "taverna_2"):
                    proc_var = t[4]
                    
                for x in proc_var:
                    proc_name = x.find("b")
                    if (proc_name != None):
                        proc_names += proc_name.contents[0] + ", "
                print "\"" + proc_names + "\",",
                output.write("\"" + proc_names + "\",",)
                
                #Get the embedded workflow names, amount, and description
                wf_names = ""
                wf_descrip = ""
                
                #These basically count the amount of times these occur. 
                count = [0]
                localworker = [0]
                stringconstant = [0]
                beanshell = [0]
                wsdl = [0]
                xmlsplitter = [0]
                workflow = [0]
                soaplab = [0]
                bio = [0]

                for x in proc_var:
                    wf_name=x.contents
                    match_wf = re.search("workflow",str(wf_name[1]))
                    if (match_wf != None):
                        
                        #Get the names, put them into a single list
                        wfnames =  wf_name[0].find("b").contents[0]
                        wf_names += str(wfnames) + ", "
                
                        #Get the descriptions (if any), put them into a single list
                        wfdesc = wf_name[2]
                        try: 
                            wf_descrip = str(wfdesc.contents[0]) + ", "
                        except:
                            wf_descrip = ""
                
                        #Count the amount of workflows in processors
                        count[0] += 1
                        
                    match_wf = re.search("local",str(wf_name[1]))
                    if (match_wf != None):
                        localworker[0] += 1
                    match_wf = re.search("string",str(wf_name[1]))
                    if (match_wf != None):
                        stringconstant[0] += 1
                    match_wf = re.search("bean",str(wf_name[1]))
                    if (match_wf != None):
                         beanshell[0] += 1
                    match_wf = re.search("wsdl",str(wf_name[1]))
                    if (match_wf != None):
                         wsdl[0] += 1
                    match_wf = re.search("xmlsplitter",str(wf_name[1]))
                    if (match_wf != None):
                         xmlsplitter[0] += 1
                    match_wf = re.search("soap",str(wf_name[1]))
                    if (match_wf != None):
                         soaplab[0] += 1
                    match_wf = re.search("bio",str(wf_name[1]))
                    if (match_wf != None):
                         bio[0] += 1
                         
                     #other ones can be caught later using R and the SUM of these columns. 
                         
                count = str(count[0])
                localworker = str(localworker[0])
                stringconstant = str(stringconstant[0])
                beanshell = str(beanshell[0])
                wsdl = str(wsdl[0])
                xmlsplitter = str(xmlsplitter[0])
                soaplab = str(soaplab[0])
                bio = str(bio[0])

                print "\"" + count + "\",",
                print "\"" + wf_names + "\",",
                print "\"" + wf_descrip + "\",",
                print "\"" + localworker + "\",",
                print "\"" + stringconstant + "\",",
                print "\"" + beanshell + "\",",
                print "\"" + wsdl + "\",",
                print "\"" + xmlsplitter + "\",",
                print "\"" + soaplab + "\",",
                print "\"" + bio + "\",",
                
                output.write("\"" + wf_names + "\",",)
                output.write("\"" + wf_descrip + "\",",)
                output.write("\"" + count + "\",",)
                output.write("\"" + localworker + "\",",)
                output.write("\"" + stringconstant + "\",",)
                output.write("\"" + beanshell + "\",",)
                output.write("\"" + wsdl + "\",",)
                output.write("\"" + xmlsplitter + "\",",)
                output.write("\"" + soaplab + "\",",)
                output.write("\"" + bio + "\",",)
                    
            
                #Get the beanshell names
                bn_names = ""
                if (sys.argv[2] == "taverna_1"):
                    bean_var = t[2]
                elif (sys.argv[2] == "taverna_2"):
                    bean_var = t[5]
                for x in bean_var:
                    bn_name = x.find("b")
                    if (bn_name != None):
                        bn_names += bn_name.contents[0] + ", "
                print "\"" + bn_names + "\",",
                output.write("\"" + bn_names + "\",",)
                
                #Get the names of the outputs
                output_names = ""
                if (sys.argv[2] == "taverna_1"):
                    out_var = t[3]
                elif (sys.argv[2] == "taverna_2"):
                    out_var = t[6]
                for x in out_var:    
                    output_name = x.find("b")
                    if (output_name != None):
                        output_names += output_name.contents[0] + ", "
                print "\"" + output_names + "\",",
                output.write("\"" + output_names + "\",",)    
            except:
                print
    
    #Get the License
    try:
        license_obj = bs.findAll("div", {"class": "contribution_currentlicense"})[0].find("a")    
        license = license_obj['title']
        print "\"" + license.strip() + "\",",
        output.write("\"" + license.strip() + "\",",)
    except:
        print ","
        output.write(",")
    
    #Shared with Groups -INT
    groups_obj = bs.findAll("div", {"class": "contribution_section_box"})[5].find("p").find("span", {"class": "count_text"})
    v = groups_obj.contents[0]
    number_regex = re.compile("\d+")
    match_o = re.search(number_regex,v)
    print "\"" + match_o.group(0).strip() + "\",",
    output.write("\"" + match_o.group(0).strip() + "\",",)
        
    #Shared with which groups
    try:
        wgroups_obj = bs.findAll("div", {"class": "contribution_section_box"})[5].findAll("a")
        wgroups = ""
        for i in wgroups_obj:
            wgroups += i.contents[0] + ", "
        print "\"" + wgroups[:-2].strip() +"\",",
        output.write("\"" + wgroups[:-2].strip() + "\",",)
    except:
        print ","
        output.write(",")
    
    #Featured in packs INT
    packs_obj = bs.findAll("div", {"class": "contribution_section_box"})[6].find("p").find("span", {"class": "count_text"})
    v = packs_obj.contents[0]
    number_regex = re.compile("\d+")
    match_o = re.search(number_regex,v)
    print "\"" + match_o.group(0).strip() + "\",",
    output.write("\"" + match_o.group(0).strip() + "\",",)    
    
    #Featured in which packs
    try:
        packs_obj = bs.findAll("div", {"class": "contribution_section_box"})[6].find("ul", {"class": "items"}).findAll("a")
        packs = ""
        for i in packs_obj:
            packs += i.contents[0] + ", "
        print "\"" + packs.strip() +"\",",
        output.write("\"" + packs.strip() + "\",",)
    except:
        print ","
        output.write(",")
        
    #Amount of Ratings INT
    ratings_obj = bs.findAll("div", {"class": "contribution_section_box"})[7].find("font", {"class": "count_text"})
    v = ratings_obj.contents[0]
    number_regex = re.compile("\d+")
    match_o = re.search(number_regex,v)
    print "\"" + match_o.group(0).strip() + "\",",
    output.write("\"" + match_o.group(0).strip() + "\",",)    

    #Current Rating INT
    cratings_obj = bs.find("div", {"style": "margin: 0.2em 0;"}).findAll("p")[1]
    v = cratings_obj.contents[0].replace(" / 5","").encode('ascii', 'ignore')
    print "\"" + v.strip() + "\",",
    output.write("\"" + v.strip() + "\",",)        
    #What individual ratings


    #Attribution URLs and Names (Two columns)
    attrib_obj = bs.findAll("div", {"class": "contribution_section_box"})[8].findAll("a")
    attrib_html = ""
    attrib_name = ""
    for i in range(1,len(attrib_obj)):
        attrib_html_obj = attrib_obj[i]
        attrib_html += attrib_html_obj['href'] + ", "
        attrib_name += attrib_html_obj.contents[0] + ", "
    print "\"" + attrib_html +"\",",
    print "\"" + attrib_name +"\",",
    output.write("\"" + attrib_html.strip() + "\",",)
    output.write("\"" + attrib_name +"\",",)
        
    #Favourited user URLs 
    favour_obj = bs.findAll("div", {"class": "contribution_section_box"})[9].findAll("a")
    favour_html = ""
    for i in range(1,len(favour_obj)):
        favour_html_obj = favour_obj[i]
        favour_html += favour_html_obj['href'] + ", "
    print "\"" + favour_html +"\",",
    output.write("\"" + favour_html.strip() + "\",",)
    
    #Versions Created On
    versions_obj = bs.findAll("div", {"class": "contribution_version_meta_info_box"})
    created = ""
    updated = ""
    for x in range(len(versions_obj)):
        versions_obj_obj = versions_obj[x]
        versions_p = versions_obj_obj.findAll("p")
        created += versions_p[0].contents[1] + ", "
        if len(versions_p) == 4:
            updated += ", "
        if len(versions_p) == 6:
            updated += versions_p[2].contents[1] + ","
    print "\"" + created +"\",",
    output.write("\"" + created + "\",",)
    print "\"" + updated +"\",",
    output.write("\"" + updated + "\",",)
        
    #Comment Author
    try:
        comments_obj = bs.find("div", {"class": "commentsBox"}).findAll("span")
        comment_author = ""
        for x in range(len(comments_obj)):
            com_obj = comments_obj[x].find("a")
            comment_author += com_obj['href'] + ", "
        print "\"" + comment_author +"\",",
        output.write("\"" + comment_author + "\",",)
    except:
        print ","
        output.write(",")
    
    
    #Comment Date
    comments_obj = bs.find("div", {"class": "commentsBox"}).findAll("td", {"class": "header"})
    comment_date = ""
    for x in range(len(comments_obj)):
        comments_obj_obj = comments_obj[x].contents[0].encode('ascii', 'ignore')
        comment_date += comments_obj_obj.strip() + ", "
    print "\"" + comment_date +"\",",
    output.write("\"" + comment_date + "\",",)
    
    #Comment
    comments_obj = bs.find("div", {"class": "commentsBox"}).findAll("td", {"class": "content"})
    comment = ""
    for x in comments_obj:
        comment += str(x.contents).encode('ascii', 'ignore').replace("\"", "").strip() + ", "
    print "\"" + comment +"\",",
    output.write("\"" + comment + "\",",)

    #Timestamp of scrape.
    import time
    import datetime
    print "\"" + str(datetime.datetime.now()) + "\",",
    output.write("\"" + str(datetime.datetime.now()) + "\",",)

    print
    output.write("\n")
    #time.sleep(1)
    
output.close()
