library(RMySQL)
library(ggplot2) 
library(lubridate)
setwd("~/Dropbox/DataOne Workflows/IDCC-paper")
require('db_connect~.r')
#Update this according to your own server
# small change

draw_axis = opts(axis.line=theme_segment(colour="black",linetype="solid",size=0.8))
axis_labels=  opts(axis.text.x=theme_text(size=11),axis.text.y=theme_text(size=11)) 
no_bg = opts(panel.background=theme_rect(colour=NA))

#---------------------------------------------------------------------
#Bipcod Histogram
data = dbGetQuery(con,"select Uploaded, Updated, Versions, Views, Downloads, Myexp_v, Myexp_v_m, Myexp_v_a, Myexp_d, Myexp_d_a, Ext_v, Ext_d, Credits, Attributions, Number_Tags, Favs, Ratings, Citations, Reviews, Comments, Inputs, Processors, Beanshells, Outputs, Datalinks, Coordinators, Embeds, Local_N, String_N, Beanshell_N, Wsdl_N, Xml_N, Soap_N, Bio_N from taverna_2")
data1 = dbGetQuery(con,"select Uploaded, Updated, Versions, Views, Downloads, Myexp_v, Myexp_v_m, Myexp_v_a, Myexp_d, Myexp_d_a, Ext_v, Ext_d, Credits, Attributions, Number_Tags, Favs, Ratings, Citations, Reviews, Comments, Inputs, Processors, Beanshells, Outputs, Datalinks, Coordinators, Embeds, Local_N, String_N, Beanshell_N, Wsdl_N, Xml_N, Soap_N, Bio_N from taverna_1")
data4 = rbind(data,data1)

data4$bipcod=data4$Beanshells+data4$Inputs+data4$Processors+data4$Outputs+data4$Datalinks+data4$Coordinators
file1 = ggplot(data4,aes(x=bipcod)) +geom_histogram(binwidth=2) +xlab("Index of complexity") + ylab("Count") + opts(title="Workflow complexity") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) + no_bg + draw_axis + axis_labels


ggsave(file1, file="A-Tavernas Histogram - Bipcod.png",width=4.2,height=4.2)
 

# -------------------------------------------------------------------
# Histogram of user uploads

#All
data1=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_2")
data3=dbGetQuery(con,"select User_URL,Uploaded,Description from rapidminer")
data4=dbGetQuery(con,"select User_URL,Uploaded,Description from others")
data= rbind(data1, data2, data3, data4)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))

summary=count(data, c("User_URL"))

file2 = ggplot(summary,aes(freq)) +geom_histogram(binwidth=10) +xlab("# of workflows contributed per user") + ylab("Frequency") + opts(title="User uploads") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) + no_bg + draw_axis + axis_labels


ggsave(file2,file="B-all_User_URL_nchar_description.png",width=4.2,height=4.2)

# -------------------------------------------------------------------
# Duration against Duration/Downloads. Might show the use of myExperiment - long term vs. short term
# As well as possibly whether workflows are getting more specialised. 

combine_data <- function(d1,d2,d3,d4)
{
d1$workflow_type="Taverna_1"
d2$workflow_type="Taverna_2"
d3$workflow_type="Rapid_Miner"
d4$workflow_type="Others"
return (rbind(d1,d2,d3,d4))
}

#All
data1=dbGetQuery(con,"select Downloads,Uploaded from taverna_1")
data2=dbGetQuery(con,"select Downloads,Uploaded from taverna_2")
data3=dbGetQuery(con,"select Downloads,Uploaded from rapidminer")
data4=dbGetQuery(con,"select Downloads,Uploaded from others")
data= combine_data(data1, data2, data3, data4)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
data$DD=data$Downloads/as.numeric(data$duration)

file3 = ggplot(data,aes(duration,DD)) +geom_point() +geom_smooth(method=lm) +xlab("Days since myExperiment Went Live") +ylab("Days / Downloads") +geom_point() +geom_smooth(method=lm) +
xlab("Days since myExperiment Went Live") + ylab("Days / Downloads") + opts(title="Workflow use through time") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) + no_bg + draw_axis + axis_labels


ggsave(file3,file="C-Upload_dates.png",width=4.2,height=4.2)
 

#Tavernas
data1=dbGetQuery(con,"select Uploaded,Versions,Downloads from taverna_1")
data2=dbGetQuery(con,"select Uploaded,Versions,Downloads from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.

data$B[data$Versions==1]="1 Version";
data$B[data$Versions=='NA']="No Versions?";
data$B[data$Versions>1]="More than one version";

file = ggplot(subset(data,data$B=="More than one version"),aes(duration, Downloads/duration)) + ylab("Downloads over days ratio") + xlab("Amount of Days on myExperiment") + geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "VersionsOver Time vs. Download ratio") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) + no_bg + draw_axis + axis_labels
ggsave(file,file="D-Tavernas - Time vs. Download ratio.png",width=4.2,height=4.2)

#---------------------------------------------------------------------
#---------------------------------------------------------------------
#--------------------------Richard's new code-------------------------
#---------------------------------------------------------------------
#---------------------------------------------------------------------

#Issues. not sure what.

#Bipcod vs. Downloads - More complex, not more downloaded
data = dbGetQuery(con,"select Uploaded, Updated, Versions, Views, Downloads, Myexp_v, Myexp_v_m, Myexp_v_a, Myexp_d, Myexp_d_a, Ext_v, Ext_d, Credits, Attributions, Number_Tags, Favs, Ratings, Citations, Reviews, Comments, Inputs, Processors, Beanshells, Outputs, Datalinks, Coordinators, Embeds, Local_N, String_N, Beanshell_N, Wsdl_N, Xml_N, Soap_N, Bio_N from taverna_2")
data1 = dbGetQuery(con,"select Uploaded, Updated, Versions, Views, Downloads, Myexp_v, Myexp_v_m, Myexp_v_a, Myexp_d, Myexp_d_a, Ext_v, Ext_d, Credits, Attributions, Number_Tags, Favs, Ratings, Citations, Reviews, Comments, Inputs, Processors, Beanshells, Outputs, Datalinks, Coordinators, Embeds, Local_N, String_N, Beanshell_N, Wsdl_N, Xml_N, Soap_N, Bio_N from taverna_1")
data4 = rbind(data,data1)

data4$bipcod=data4$Beanshells+data4$Inputs+data4$Processors+data4$Outputs+data4$Datalinks+data4$Coordinators
file1 = ggplot(data4,aes(Downloads, bipcod)) +geom_histogram(binwidth=2) +geom_point() +geom_smooth(method=lm) +xlab("Downloads") +ylab("Complexity Proxy") +geom_point() +geom_smooth(method=lm) +
xlab("Downloads") + ylab("Complexity Proxy") + opts(title="How complexity effects Downloads") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) #+ no_bg + draw_axis + axis_labels

ggsave(file1, file="Tavernas - Bipcod vs. Downloads.png")

#----- Community proxy vs. Downlaods---------
# -----------------------------------
# myExperiment use: attributions, credits, reviews, favourites, ratings, comments vs. downloads

# All
data1=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from taverna_1")
data2=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from taverna_2")
data3=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from rapidminer")
data4=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments)) +xlab("Downloads") +ylab("Community Proxy") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Attributions, Credits,\n Favorites, Ratings, Citations,\n Reviews & Comments")
ggsave(file, file="Downloads vs. Community Proxy.png")
file


####################### Graphs without 1 uploads / Power uploaders##############################

#Uploads per User (Histogram)

data1=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_2")
data3=dbGetQuery(con,"select User_URL,Uploaded,Description from rapidminer")
data4=dbGetQuery(con,"select User_URL,Uploaded,Description from others")
data= rbind(data1, data2, data3, data4)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))

summary=count(data, c("User_URL"))
summary <- subset(summary, freq>=3 & freq<200)

file = ggplot(summary,aes(freq)) +geom_histogram(binwidth=10) +xlab("# of workflows contributed per user") + ylab("Frequency") + opts(title="User uploads") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) # + no_bg + draw_axis + axis_labels
file

#----------------------------

### karthik - need to match the subset of summary with data$bipcod - only select those that have 2>= workflows. Can't figure it out. Thoughts?

#Bipcod Histogram
data1 = dbGetQuery(con,"select User_URL, Uploaded, Updated, Versions, Views, Downloads, Myexp_v, Myexp_v_m, Myexp_v_a, Myexp_d, Myexp_d_a, Ext_v, Ext_d, Credits, Attributions, Number_Tags, Favs, Ratings, Citations, Reviews, Comments, Inputs, Processors, Beanshells, Outputs, Datalinks, Coordinators, Embeds, Local_N, String_N, Beanshell_N, Wsdl_N, Xml_N, Soap_N, Bio_N from taverna_2")
data2 = dbGetQuery(con,"select User_URL, Uploaded, Updated, Versions, Views, Downloads, Myexp_v, Myexp_v_m, Myexp_v_a, Myexp_d, Myexp_d_a, Ext_v, Ext_d, Credits, Attributions, Number_Tags, Favs, Ratings, Citations, Reviews, Comments, Inputs, Processors, Beanshells, Outputs, Datalinks, Coordinators, Embeds, Local_N, String_N, Beanshell_N, Wsdl_N, Xml_N, Soap_N, Bio_N from taverna_1")
data = rbind(data1,data2)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
summary=count(data, c("User_URL"))
summary <- subset(summary, freq>3 & freq<200)
data$bipcod=data$Beanshells+data$Inputs+data$Processors+data$Outputs+data$Datalinks+data$Coordinators

file = ggplot(data,aes(x=bipcod)) +geom_histogram(binwidth=2) +xlab("Index of complexity") + ylab("Count") + opts(title="Workflow complexity") + opts(plot.title=theme_text(size = 24, face ='bold')) + opts(panel.grid.major=theme_line(colour=NA)) + opts(panel.grid.minor=theme_line(colour=NA)) + no_bg + draw_axis + axis_labels
file

ggsave(file, file="Tavernas Histogram - Bipcod.png")