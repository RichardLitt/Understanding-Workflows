library(RMySQL)
library(ggplot2) 
setwd("~/Dropbox/DataOne Workflows/DataONE_R/Graphs")

con<-dbConnect(MySQL(),user="root",password="root",dbname="myExperiment",host="127.0.0.1",port=8889)

# A couple of  functions to cut down on repeated code
# ------------------------------------------------------------

# Plot views vs Downloads
workflow_plots <- function (data)
{
return(ggplot(data,aes(Downloads,Views)) + geom_point() +geom_smooth(method=lm)) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Views")
}

# ~~~~~~ combine the 4 diff workflow types and add identifiers
combine_data <- function(d1,d2,d3,d4)
{
d1$workflow_type="Taverna_1"
d2$workflow_type="Taverna_2"
d3$workflow_type="Rapid_Miner"
d4$workflow_type="Others"
return (rbind(d1,d2,d3,d4))
}

combine_tavernas <- function(d1,d2,d3,d4)
{
	d1$workflow_type="Taverna_1"
	d2$workflow_type="Taverna_2"
	d3$workflow_type="Tavernas"
	return (rbind(d1,d2,d3))
}

combine_rm_tavernas <- function(d1,d2,d3,d4)
{
	d1$workflow_type="Taverna_1"
	d2$workflow_type="Taverna_2"
	d3$workflow_type="Rapid_Miner"
	d4$workflow_type="Tavernas"
	return (rbind(d1,d2,d3,d4))
}
# ------------------------------------------------------------

# Downloads vs. Views


data1=dbGetQuery(con,"select Views,Downloads from taverna_1")
data2=dbGetQuery(con,"select Views,Downloads from taverna_2")
data3=dbGetQuery(con,"select Views,Downloads from rapidminer")
data4=dbGetQuery(con,"select Views,Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Views)) + geom_point() + geom_smooth(method=lm)  + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Views")
ggsave(file, file="Downloads vs. Views.png")
file

# -----------------------------------
# MyExperiment only: Downloads vs. Views

#All
data1=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from taverna_1")
data2=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from taverna_2")
data3=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from rapidminer")
data4=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from others")
data_all= combine_data(data1, data2, data3, data4)


file = ggplot(data_all,aes(Downloads,Views)) + geom_point() + geom_smooth(method=lm)   + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "MyExperiment only: Downloads vs. Views")
ggsave(file, file="MyExperiment only: Downloads vs. Views.png")
file


# -----------------------------------
# MyExp only: Downloads vs. Views, where d<400 (minus outliers)

#All
data1=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from taverna_1")
data2=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from taverna_2")
data3=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from rapidminer")
data4=dbGetQuery(con,"select Myexp_v as Views,Myexp_d as Downloads from others")
data_all= combine_data(data1, data2, data3, data4)
data_all=subset(data_all,Downloads<400)

file = ggplot(data_all,aes(Downloads,Views)) + geom_point() + geom_smooth(method=lm)   + facet_wrap(~workflow_type)  + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "MyExp only: Downloads vs. Views (<400 Downloads)")
ggsave(file, file="MyExp only: Downloads vs. Views (<400 Downloads).png")
file

# -----------------------------------
# MyExp only: Member Downloads vs. Member Views

#All
data1=dbGetQuery(con,"select Myexp_v_m as Views,Myexp_d_m as Downloads from taverna_1")
data2=dbGetQuery(con,"select Myexp_v_m as Views,Myexp_d_m as Downloads from taverna_2")
data3=dbGetQuery(con,"select Myexp_v_m as Views,Myexp_d_m as Downloads from rapidminer")
data4=dbGetQuery(con,"select Myexp_v_m as Views,Myexp_d_m as Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Views)) + geom_point() + geom_smooth(method=lm)   + facet_wrap(~workflow_type)    + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Member Downloads vs. Member Views")
ggsave(file, file="Member Downloads vs. Member Views.png")
file

# -------------------------------------------------
# MyExp only: anonymous Downloads vs. anonymous Views

data1=dbGetQuery(con,"select Myexp_v_a as Views,Myexp_d_a as Downloads from taverna_1")
data2=dbGetQuery(con,"select Myexp_v_a as Views,Myexp_d_a as Downloads from taverna_2")
data3=dbGetQuery(con,"select Myexp_v_a as Views,Myexp_d_a as Downloads from rapidminer")
data4=dbGetQuery(con,"select Myexp_v_a as Views,Myexp_d_a as Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Views)) + geom_point() + geom_smooth(method=lm)   + facet_wrap(~workflow_type)   + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Anonymous Downloads vs. Anonymous Views")
ggsave(file,file="Anonymous Downloads vs. Anonymous Views.png")
file


# --------------------------------------------------
# MyExp only: external views vs. external Downloads

#All
data1=dbGetQuery(con,"select Ext_v as Views,Ext_d as Downloads from taverna_1")
data2=dbGetQuery(con,"select Ext_v as Views,Ext_d as Downloads from taverna_2")
data3=dbGetQuery(con,"select Ext_v as Views,Ext_d as Downloads from rapidminer")
data4=dbGetQuery(con,"select Ext_v as Views,Ext_d as Downloads from others")
data_all= combine_data(data1, data2, data3, data4)


file = ggplot(data_all,aes(Downloads,Views)) + geom_point() + geom_smooth(method=lm)   + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "External Views vs. External Downloads")
ggsave(file, file="External Views vs. External Downloads.png")
file

# -----------------------------------
# MyExp only: member views vs. anonymous views

#All
data1=dbGetQuery(con,"select Myexp_v,Myexp_v_m from taverna_1")
data2=dbGetQuery(con,"select Myexp_v,Myexp_v_m from taverna_2")
data3=dbGetQuery(con,"select Myexp_v,Myexp_v_m from rapidminer")
data4=dbGetQuery(con,"select Myexp_v,Myexp_v_m from others")
data_all= combine_data(data1, data2, data3, data4)


file = ggplot(data_all,aes(Myexp_v,Myexp_v_m)) + xlab("Member Views") + ylab("Anon Views") + geom_point() + geom_smooth(method=lm)   + facet_wrap(~workflow_type)  + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Member Views Vs Anon Views")
ggsave(file, file="Member Views Vs Anon Views.png")
file

# -----------------------------------
# MyExp only: member downloads vs. anonymous downloads

#All
data1=dbGetQuery(con,"select Myexp_d,Myexp_d_m from taverna_1")
data2=dbGetQuery(con,"select Myexp_d,Myexp_d_m from taverna_2")
data3=dbGetQuery(con,"select Myexp_d,Myexp_d_m from rapidminer")
data4=dbGetQuery(con,"select Myexp_d,Myexp_d_m from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Myexp_d,Myexp_d_m)) + geom_point() + xlab("Member Downloads") + ylab("Anon Downloads") + geom_smooth(method=lm)   + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Member Downloads Vs Anon Downloads")
ggsave(file, file="Member Downloads Vs Anon Downloads.png")
file

# -------------------------------------------
# MyExp only: onsite views vs. external views

#All
data1=dbGetQuery(con,"select Myexp_v,Ext_v from taverna_1")
data2=dbGetQuery(con,"select Myexp_v,Ext_v from taverna_2")
data3=dbGetQuery(con,"select Myexp_v,Ext_v from rapidminer")
data4=dbGetQuery(con,"select Myexp_v,Ext_v from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Myexp_v,Ext_v)) + geom_point() + xlab("Onsite Views") + ylab("Externam Views") +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Onsite Views Vs External Views")
ggsave(file, file="Onsite Views Vs External Views.png")
file

# -------------------------------------------------
# MyExp only: onsite downloads vs. external downloads

#All
data1=dbGetQuery(con,"select Myexp_d,Ext_d from taverna_1")
data2=dbGetQuery(con,"select Myexp_d,Ext_d from taverna_2")
data3=dbGetQuery(con,"select Myexp_d,Ext_d from rapidminer")
data4=dbGetQuery(con,"select Myexp_d,Ext_d from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Myexp_d,Ext_d)) + xlab("Onsite Downloads") + ylab("External Downloads") +  geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type,scales="free")  + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Onsite Downloads Vs External Downloads")
ggsave(file, file="Onsite Downloads Vs External Downloads.png")
file

# -----------------------------------
# Tags vs. Downloads

# All
taverna1_tags=dbGetQuery(con,"select Downloads,Number_Tags from taverna_1")
taverna2_tags=dbGetQuery(con,"select Downloads,Number_Tags from taverna_2")
rapidminer_tags=dbGetQuery(con,"select Downloads,Number_Tags from rapidminer")
other_tags=dbGetQuery(con,"select Downloads,Number_Tags from others")
all_tags=data_all= combine_data(taverna1_tags, taverna1_tags, rapidminer_tags, other_tags)

file = ggplot(all_tags,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tags vs. Downloads")
ggsave(file, file="Tags vs. Downloads.png")
file 

# KARTHIK HAS NOT EDITED BELOW THIS LINE
# -----------------------------------
# Bipcod vs. Downloads

data1=dbGetQuery(con,"select Downloads,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_1")
data2=dbGetQuery(con,"select Downloads,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

file = ggplot(data_all,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +facet_wrap(~workflow_type) + xlab("Downloads") + ylab("BIPCOD") +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas:\n BIPCOD (Complexity proxy) vs. Downloads")
ggsave(file, file="Tavernas - BIPCOD (Complexity proxy) vs. Downloads.png")
file

# -----------------------------------
# Versions vs. Downloads

# Should also probably be a different type of graph
# Rapidminer and Others only have one version each.

data1=dbGetQuery(con,"select Versions,Downloads from taverna_1")
data2=dbGetQuery(con,"select Versions,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

# Tavernas
file = ggplot(data_all,aes(Downloads,Versions)) + xlab("Downloads") + ylab("Versions") +facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas - \n Downloads vs. Versions")
ggsave(file, file="Tavernas - Downloads vs. Versions.png")
file


# -----------------------------------
# Versions vs. Views

# Should also probably be a different type of graph
# Rapidminer and Others only have one version each.

# Tavernas
data1=dbGetQuery(con,"select Views,Versions from taverna_1")
data2=dbGetQuery(con,"select Views,Versions from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)


file = ggplot(data_all,aes(Views,Versions)) + xlab("Views") + ylab("Versions") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas:\n Views vs. Versions")
ggsave(file, file="Tavernas - Views vs. Versions.png")
file


# -----------------------------------
# Length of description against amount of downloads

# All
data1=dbGetQuery(con,"select Description,Downloads from taverna_1")
data2=dbGetQuery(con,"select Description,Downloads from taverna_2")
data3=dbGetQuery(con,"select Description,Downloads from rapidminer")
data4=dbGetQuery(con,"select Description,Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,nchar(Description))) +xlab("Downloads") +ylab("Length of Description") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Length of Description")
ggsave(file, file="Downloads vs. Length of Description.png")
file


# -----------------------------------
# Length of title against amount of downloads

#All
data1=dbGetQuery(con,"select Title,Downloads from taverna_1")
data2=dbGetQuery(con,"select Title,Downloads from taverna_2")
data3=dbGetQuery(con,"select Title,Downloads from rapidminer")
data4=dbGetQuery(con,"select Title,Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,nchar(Title))) +xlab("Downloads") +ylab("Length of Title") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Length of Title")
ggsave(file, file="Downloads vs. Length of Title.png")
file

# -----------------------------------
# Favorites against downloads

#All
data1=dbGetQuery(con,"select Favs,Downloads from taverna_1")
data2=dbGetQuery(con,"select Favs,Downloads from taverna_2")
data3=dbGetQuery(con,"select Favs,Downloads from rapidminer")
data4=dbGetQuery(con,"select Favs,Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Favs)) +xlab("Downloads") +ylab("Favorites") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Favorites")
ggsave(file, file="Downloads vs. Favorites.png")
file

# -----------------------------------
# Citations against downloads

#All
data1=dbGetQuery(con,"select Citations,Downloads from taverna_1")
data2=dbGetQuery(con,"select Citations,Downloads from taverna_2")
data3=dbGetQuery(con,"select Citations,Downloads from rapidminer")
data4=dbGetQuery(con,"select Citations,Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Citations)) +xlab("Downloads") +ylab("Citations") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Citations")
ggsave(file, file="Downloads vs. Citations.png")
file

# -----------------------------------
# Embeds against downloads

# Didnt measure for others, as they were not automatic or clear.

data1=dbGetQuery(con,"select Embeds,Downloads from taverna_1")
data2=dbGetQuery(con,"select Embeds,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

# Tavernas
file = ggplot(data_all,aes(Downloads,Embeds)) + xlab("Downloads") + ylab("Embedded Workflows") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Embedded Workflows")
ggsave(file, file="Tavernas - Downloads vs. Embedded Workflows.png")
file


# -----------------------------------
# Embeds descriptions against downloads

# Taverna 2 didnt have any.

# Taverna 1
data=dbGetQuery(con,"select WF_Descriptions,Downloads from taverna_1")

file = ggplot(data,aes(nchar(WF_Descriptions),Downloads)) + xlab("Downloads") + ylab("Embedded Workflow Description Length") +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 1 - Downloads vs.\n Embedded Workflow Description Length")
ggsave(file,file="Taverna 1 - Downloads vs. Embedded Workflow Descriptions.png")
file

# -----------------------------------
# Outputs vs. Downloads

#All
data1=dbGetQuery(con,"select Outputs,Downloads from taverna_1")
data2=dbGetQuery(con,"select Outputs,Downloads from taverna_2")
data3=dbGetQuery(con,"select Outputs,Downloads from rapidminer")
data4= rbind(data1, data2)
data_all= combine_rm_tavernas(data1, data2, data3, data4)

data=dbGetQuery(con,"select Outputs,Downloads from taverna_2")
file = ggplot(data_all,aes(Downloads,Outputs)) +xlab("Downloads") +ylab("Outputs") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Outputs")
ggsave(file,file="Downloads vs. Outputs.png")
file

#Others not possible. 


# -----------------------------------
# Outputs vs. Inputs

#This is definitely not the right graph for this.

data1=dbGetQuery(con,"select Outputs,Inputs from taverna_1")
data2=dbGetQuery(con,"select Outputs,Inputs from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

# Tavernas
file = ggplot(data_all,aes(Outputs,Inputs)) + xlab("Outputs") + ylab("Inputs") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Outputs vs. Inputs")
ggsave(file, file="Tavernas - Outputs vs. Inputs.png")
file

# Tavernas only box plot
file = ggplot(data3,aes(factor(Inputs),Outputs)) +geom_boxplot()
ggsave(file,file="Tavernas only - Outputs vs. Inputs Boxplot.png")
file


# -----------------------------------
# Inputs vs. Downloads

#All
data1=dbGetQuery(con,"select Inputs,Downloads from taverna_1")
data2=dbGetQuery(con,"select Inputs,Downloads from taverna_2")
data3=dbGetQuery(con,"select Inputs,Downloads from rapidminer")
data4= rbind(data1, data2)
data_all= combine_rm_tavernas(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Inputs)) +xlab("Downloads") +ylab("Inputs") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Inputs")
ggsave(file,file="Downloads vs. Inputs.png")
file

#Others not possible. 

# -----------------------------------
# Beanshells vs Downloads

data1=dbGetQuery(con,"select Beanshells,Downloads from taverna_1")
data2=dbGetQuery(con,"select Beanshells,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

# Tavernas
file = ggplot(data_all,aes(Downloads, Beanshells)) + xlab("Downloads") + ylab("Beanshells") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Beanshells")
ggsave(file,file="Tavernas - Downloads vs. Beanshells.png")
file

file = ggplot(data3,aes(factor(Beanshells),Downloads)) +geom_boxplot()
ggsave(file,file="Tavernas - Downloads vs. Beanshells Boxplot.png")
file

#For all of these, 89(~) workflows denied scraping access to myExperiment. 

# -----------------------------------
# Amount of descriptions in the workflow vs. downloads

#Taverna 2 (only one available)
data=dbGetQuery(con,"select Descriptions,Downloads from taverna_2")

file = ggplot(data,aes(factor(Descriptions),Downloads)) +geom_boxplot()
ggsave(file,file="Taverna 2 - Downloads vs. Workflow Metadata Description Boxplot.png")
file

file = ggplot(data,aes(Downloads,Descriptions)) +geom_point() +geom_smooth(method=lm) + xlab("Downloads") + ylab("Descriptions") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 2 -\n Downloads vs. Workflow metadata Description")
ggsave(file,file="Taverna 2 - Downloads vs. Workflow Metadata Description.png")
file

# -----------------------------------
# Title in the workflow vs. Downloads

#Taverna2 (ibid.)
data=dbGetQuery(con,"select Titles, Downloads from taverna_2")

file = ggplot(data,aes(factor(Titles),Downloads)) +geom_boxplot() 
ggsave(file,file="Taverna 2 - Downloads vs. Workflow Metadata Titles Boxplot.png")
file

file = ggplot(data,aes(Downloads,Titles)) +geom_point() +geom_smooth(method=lm) + xlab("Downloads") + ylab("Titles") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 2 -\n Downloads vs. Workflow Metadata Titles")
ggsave(file,file="Taverna 2 - Downloads vs. Workflow Metadata Titles.png")
file

# -----------------------------------
# Amount of information in the workflow (Authors, Title, Descriptions) vs. Downloads

#Taverna 2 (ibid.)
data=dbGetQuery(con,"select Titles, Authors, Descriptions,Downloads from taverna_2")

file = ggplot(data,aes(Downloads,Titles+Authors+Descriptions)) +geom_point() +geom_smooth(method=lm) + xlab("Downloads") + ylab("Descriptions, Authors, Titles") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 2 -\n Downloads vs. Workflow Metadata\n (Authors, Descriptions, Titles)")
ggsave(file,file="Taverna 2 - Downloads vs. Workflow Metadata.png")
file

# -----------------------------------
# Authors vs. Downloads

data=dbGetQuery(con,"select Authors,Downloads from taverna_2")

# Box plot with everything
file = ggplot(data,aes(factor(Authors),Downloads)) +geom_boxplot() + geom_smooth(aes(group=1),method=lm) + xlab("Authors") + ylab("Downloads") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 2 -\n Authors vs. Downloads")
ggsave(file, file="Taverna 2 - Authors vs. Downloads.png")
file

# Box plot: 1 vs 2+3+4
data$B[data$Authors==1]="One author";
data$B[data$Authors>1]="Two or more authors";
plot2 = ggplot(subset(data,data$B!='NA'),aes(factor(B),Downloads)) +geom_boxplot() + geom_smooth(aes(group=1),method=lm)  + xlab("Authors") + ylab("Downloads") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 2 -\n Authors vs. Downloads\n 1 vs. All")
ggsave(plot2, file="Taverna 2 - Authors vs. Downloads - 1 vs. All.png")
plot2

# Box plot: 0+NA vs 1+2+3+4
data=data[,1:2]
data$B[data$Authors==0]="Unknown authors";
data$B[data$Authors=='NA']="Unknown authors";
data$B[data$Authors>=1]="One or more authors";
plot3 = ggplot(data,aes(factor(B),Downloads)) +geom_boxplot() + geom_smooth(aes(group=1),method=lm)  + xlab("Authors") + ylab("Downloads") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Taverna 2 -\n Authors vs. Downloads\n 0 vs. All")
ggsave(plot3, file="Taverna 2 - Authors vs. Downloads - 0 vs. All.png")
plot3

# -----------------------------------
# local vs. downloads

#Tavernas
data1=dbGetQuery(con,"select Local_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Local_N,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

# Tavernas
file = ggplot(data_all,aes(Downloads, Local_N)) + xlab("Downloads") + ylab("Local_N") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Local_N")
ggsave(file,file="Tavernas - Downloads vs. Local_N.png")
file

box = ggplot(data3,aes(factor(Local_N),Downloads)) +geom_boxplot() + xlab("Downloads") + ylab("Local_N") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Local_N")
ggsave(box, file="Tavernas - Downloads vs. Local_N Boxplot.png")
box


# -----------------------------------
# string vs. downloads

#Tavernas
data1=dbGetQuery(con,"select String_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select String_N,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

file = ggplot(data_all,aes(Downloads, String_N)) + xlab("Downloads") + ylab("String_N") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. String_N")
ggsave(file,file="Tavernas - Downloads vs. String_N.png")
file

box = ggplot(data3,aes(factor(String_N),Downloads)) +geom_boxplot() + xlab("Downloads") + ylab("String_N") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. String_N")
ggsave(box, file="Tavernas - Downloads vs. String_N Boxplot.png")
box

# -----------------------------------
# wsdl vs. downloads

#Tavernas
data1=dbGetQuery(con,"select Wsdl_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Wsdl_N,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

file = ggplot(data_all,aes(Downloads, Wsdl_N)) + xlab("Downloads") + ylab("Wsdl_N") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Wsdl_N")
ggsave(file,file="Tavernas - Downloads vs. Wsdl_N.png")
file

box = ggplot(data3,aes(factor(Wsdl_N),Downloads)) +geom_boxplot() + xlab("Downloads") + ylab("Wsdl_N") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Wsdl_N")
ggsave(box, file="Tavernas - Downloads vs. Wsdl_N Boxplot.png")
box

# -----------------------------------
# XML vs. downloads

#Tavernas
data1=dbGetQuery(con,"select Xml_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Xml_N,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

file = ggplot(data_all,aes(Downloads, Xml_N)) + xlab("Downloads") + ylab("Xml_N") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Xml_N")
ggsave(file,file="Tavernas - Downloads vs. Xml_N.png")
file

box = ggplot(data3,aes(factor(Xml_N),Downloads)) +geom_boxplot() + xlab("Downloads") + ylab("Xml_N") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Xml_N")
ggsave(box, file="Tavernas - Downloads vs. Xml_N Boxplot.png")
box

# -----------------------------------
# Bio vs. downloads

#Tavernas
data1=dbGetQuery(con,"select Bio_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Bio_N,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

file = ggplot(data_all,aes(Downloads, Bio_N)) + xlab("Downloads") + ylab("Bio_N") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Bio_N")
ggsave(file,file="Tavernas - Downloads vs. Bio_N.png")
file

box = ggplot(data3,aes(factor(Bio_N),Downloads)) +geom_boxplot() + xlab("Downloads") + ylab("Bio_N") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Bio_N")
ggsave(box, file="Tavernas - Downloads vs. Bio_N Boxplot.png")
box

# -----------------------------------
# SOAP vs. downloads

#Tavernas
data1=dbGetQuery(con,"select Soap_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Soap_N,Downloads from taverna_2")
data3= rbind(data1, data2)
data_all= combine_tavernas(data1, data2, data3)

file = ggplot(data_all,aes(Downloads, Soap_N)) + xlab("Downloads") + ylab("Soap_N") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Soap_N")
ggsave(file,file="Tavernas - Downloads vs. Soap_N.png")
file

box = ggplot(data3,aes(factor(Soap_N),Downloads)) +geom_boxplot() + xlab("Downloads") + ylab("Soap_N") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Soap_N")
ggsave(box, file="Tavernas - Downloads vs. Soap_N Boxplot.png")
box


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

# -----------------------------------
# myExperiment use: attributions, credits, reviews, favourites, ratings vs. downloads
# minus comments as those are often from the Authors

# All
data1=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from taverna_1")
data2=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from taverna_2")
data3=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from rapidminer")
data4=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from others")
data_all= combine_data(data1, data2, data3, data4)

file = ggplot(data_all,aes(Downloads,Attributions + Credits + Favs + Ratings + Citations + Reviews)) +xlab("Downloads") +ylab("Community Proxy") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Downloads vs. Attributions, Credits,\n Favorites, Ratings, Citations,\n & Reviews")
ggsave(file, file="Downloads vs. Community Proxy (No Comments).png")
file

# ------------------------------------------------------------

# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# --------------Not double checked yet------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------

# ------------------------------------------------------------

# Example code using dates

# I need to comment this up. 

# Grab everything, as it is easier to run it with all of the data at the moment. 

data=dbGetQuery(con,"select * from taverna_2")

# You will notice they are char which makes it hard to do date math.
# Below we typecase those dates into two new columns. You can also overwrite the columns if you prefer.

data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")

data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")

# Now lets see what the date fields look like:
#str(data)

#month(data[,4]) # will give you the month of those dates
#as.duration(data$Uploaded_date-data$Start_date) # get the duration between column 4 and 3.

data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600 #Cut it down into days.

#data$ratio=data$duration/data$Downloads
#ggplot(data,aes(ratio,Downloads)) +geom_point()

# ------------------------------------------------------------
# Bipcod since Start_date

#Tavernas
data1=dbGetQuery(con,"select Uploaded,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_1")
data2=dbGetQuery(con,"select Uploaded,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.


data$bipcod=data$Beanshells+data$Inputs+data$Processors+data$Outputs+data$Datalinks+data$Coordinators

file = ggplot(data,aes(duration, bipcod)) + xlab("Days Since myExperiment Went Live") + ylab("BIPCOD (Complexity Proxy)") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\nComplexity of Workflows\n Over Time")
ggsave(file,file="Tavernas - Complexity of Workflows Over Time.png")
file

# ------------------------------------------------------------
# Embeds since Start_date

#Tavernas
data1=dbGetQuery(con,"select Uploaded,Embeds from taverna_1")
data2=dbGetQuery(con,"select Uploaded,Embeds from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.

file = ggplot(data,aes(duration, Embeds)) + xlab("Days Since myExperiment Went Live") + ylab("Amount of Embedded Workflows") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Embedded Workflows")
ggsave(file,file="Tavernas - Embedded Workflows over time.png")
file

# ------------------------------------------------------------
# Datalinks since Start_date

#Tavernas
data1=dbGetQuery(con,"select Uploaded,Datalinks from taverna_1")
data2=dbGetQuery(con,"select Uploaded,Datalinks from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.

file = ggplot(data,aes(duration, Datalinks)) + xlab("Days Since myExperiment Went Live") + ylab("Amount of Datalinks") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Datalinks")
ggsave(file,file="Tavernas - Datalinks over time.png")
file

# ------------------------------------------------------------
# Versions since Start_date

#Tavernas
data1=dbGetQuery(con,"select Uploaded,Versions from taverna_1")
data2=dbGetQuery(con,"select Uploaded,Versions from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.

file = ggplot(data,aes(duration, Versions)) + xlab("Days Since myExperiment Went Live") + ylab("Versions") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads vs. Versions")
ggsave(file,file="Tavernas - Versions over Time.png")
file

# ------------------------------------------------------------
# Versions against last update

#Tavernas
data1=dbGetQuery(con,"select Updated,Versions from taverna_1")
data2=dbGetQuery(con,"select Updated,Versions from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Updated_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.

file = ggplot(data,aes(duration, Versions)) + xlab("Days Since Last Update") + ylab("Versions") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Last Update vs. Versions")
ggsave(file,file="Tavernas - Last Update vs. Versions.png")
file

# ------------------------------------------------------------
# Downloads since Start_date

#Tavernas
data1=dbGetQuery(con,"select Uploaded,Downloads from taverna_1")
data2=dbGetQuery(con,"select Uploaded,Downloads from taverna_2")
data3= rbind(data1, data2)
data= combine_tavernas(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600 #Cut it down into days.

file = ggplot(data,aes(duration, Downloads)) + xlab("Days Since myExperiment Went Live") + ylab("Downloads") + facet_wrap(~workflow_type) +geom_point() +geom_smooth(method=lm) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas -\n Downloads over time")
ggsave(file,file="Tavernas - Downloads over time.png")
file


# -------------------------------------------------------------------
# User uploads - amount of, amount over time.
#This effectively just plots the uploads per user. 
#There is a way to get informaiton out of this, but I am not sure how.

#All
data1=dbGetQuery(con,"select User_URL,Uploaded from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded from taverna_2")
data3=dbGetQuery(con,"select User_URL,Uploaded from rapidminer")
data4=dbGetQuery(con,"select User_URL,Uploaded from others")
data= combine_data(data1, data2, data3, data4)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
file = ggplot(data,aes(duration, User_URL)) +xlab("Days Since myExperiment Went Live") +ylab("User IDs") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "User uploads over time")
ggsave(file,file="User uploads over time.png")
file


# -------------------------------------------------------------------
# Bipcod against Downloads - For only users that have more than one upload. 
# This is a measure of complexity, but it isnt the perfect graph. That would be bipcod of first upload vs. others. 


# Taverna 2
data=dbGetQuery(con,"select * from taverna_2")
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
data$User_URL = sub("http://www.myexperiment.org/", "", c(data$User_URL))
regex=which(grepl("users/30|users/221|users/1620|users/43|users/4706|users/5|users/267|users/1019|users/13207|users/666|users/500|users/1938|users/15178|users/12835|users/8560|users/7582|users/7581|users/6658|users/4707|users/13|users/12139|users/8705|users/7551|users/1307|users/1169|users/8344|users/8014|users/7599|users/586|users/13255|users/12763|users/10069|users/925|users/6890|users/2|users/9777|users/9775|users/7600|users/7161|users/5187|users/345|users/2037|users/18|users/17168|users/1601|users/15456|users/15427|users/15175|users/1355|users/1333|users/12553",data$User_URL, ignore.case=T))
data$User_URL_flag <- rep(NA, NROW(data))
data$User_URL_flag[regex]="Yes"
data$User_URL_flag[-(regex)]="No"
ggplot(data=subset(data,data$User_URL_flag=='Yes'),aes(Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data=subset(data,data$User_URL_flag=='Yes'),aes(Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators,Downloads)) +geom_point() +geom_smooth(method=lm) +xlab("BIPCOD (Complexity Proxy)") +ylab("Downloads") + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Tavernas - BIPCOD vs. Downloads for experienced users")
ggsave(file,file="Taverna 2 - BIPCOD vs. Downloads for experienced users.png")

# Taverna 1
data=dbGetQuery(con,"select * from taverna_1")
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
data$User_URL = sub("http://www.myexperiment.org/", "", c(data$User_URL))
regex=which(grepl("users/30|users/221|users/1620|users/43|users/4706|users/5|users/267|users/1019|users/13207|users/666|users/500|users/1938|users/15178|users/12835|users/8560|users/7582|users/7581|users/6658|users/4707|users/13|users/12139|users/8705|users/7551|users/1307|users/1169|users/8344|users/8014|users/7599|users/586|users/13255|users/12763|users/10069|users/925|users/6890|users/2|users/9777|users/9775|users/7600|users/7161|users/5187|users/345|users/2037|users/18|users/17168|users/1601|users/15456|users/15427|users/15175|users/1355|users/1333|users/12553",data$User_URL, ignore.case=T))
data$User_URL_flag <- rep(NA, NROW(data))
data$User_URL_flag[regex]="Yes"
data$User_URL_flag[-(regex)]="No"
ggplot(data=subset(data,data$User_URL_flag=='Yes'),aes(Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data=subset(data,data$User_URL_flag=='Yes'),aes(Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="Taverna 1 - BIPCOD vs. Downloads for experienced users.png")


# -------------------------------------------------------------------
#Relative time frame of the workflow systems

#Need to find a way to use the WF_System tags.

# -------------------------------------------------------------------
#nchar() of description over time

#All
data1=dbGetQuery(con,"select Description,Uploaded from taverna_1")
data2=dbGetQuery(con,"select Description,Uploaded from taverna_2")
data3=dbGetQuery(con,"select Description,Uploaded from rapidminer")
data4=dbGetQuery(con,"select Description,Uploaded from others")
data=combine_data(data1, data2, data3, data4)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
file = ggplot(data,aes(duration,nchar(Description))) +geom_point() +geom_smooth(method=lm) +xlab("Days since myExperiment Went Live") +ylab("Length of Description") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Length of Description\n Over Time")
ggsave(file,file="Length of Description\n Over Time.png")
file

# -------------------------------------------------------------------
# Duration against Duration/Views. Might show the use of myExperiment - long term vs. short term
# As well as possibly whether workflows are getting more specialised. 

#All
data1=dbGetQuery(con,"select Views,Uploaded from taverna_1")
data2=dbGetQuery(con,"select Views,Uploaded from taverna_2")
data3=dbGetQuery(con,"select Views,Uploaded from rapidminer")
data4=dbGetQuery(con,"select Views,Uploaded from others")
data=combine_data(data1, data2, data3, data4)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
file = ggplot(data,aes(duration,duration/Views)) +geom_point() +geom_smooth(method=lm) +xlab("Days since myExperiment Went Live") +ylab("Days / Views") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Upload dates vs.\n Upload Date / Views")
ggsave(file,file="Upload dates vs. Upload Date divided by Views.png")
file

# -------------------------------------------------------------------
# Duration against Views. Might show the use of myExperiment - long term vs. short term
# As well as possibly whether workflows are getting more specialised. 

#All
data1=dbGetQuery(con,"select Views,Uploaded from taverna_1")
data2=dbGetQuery(con,"select Views,Uploaded from taverna_2")
data3=dbGetQuery(con,"select Views,Uploaded from rapidminer")
data4=dbGetQuery(con,"select Views,Uploaded from others")
data=combine_data(data1, data2, data3, data4)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
#data$Updated_date=as.Date(data$Updated, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date) # new column
data$duration=data$duration/84600
file = ggplot(data,aes(duration,Views)) +geom_point() +geom_smooth(method=lm) +xlab("Days since myExperiment Went Live") +ylab("Views") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Upload dates\n vs. Views")
ggsave(file,file="Upload dates vs. Views.png")
file


# -------------------------------------------------------------------
# Duration against Duration/Downloads. Might show the use of myExperiment - long term vs. short term
# As well as possibly whether workflows are getting more specialised. 

#Doesn't want to work, and I'm not sure why.

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
file = ggplot(data,aes(duration,duration/Downloads)) +geom_point() +geom_smooth(method=lm) +xlab("Days since myExperiment Went Live") +ylab("Days / Downloads") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Upload dates\n vs. Upload Date divided by Downloads")
ggsave(file,file="Upload dates\n vs. Upload Date divided by Downloads.png")
file

# -------------------------------------------------------------------
# Duration against Downloads. Might show the use of myExperiment - long term vs. short term
# As well as possibly whether workflows are getting more specialised. 

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
file = ggplot(data,aes(duration,Downloads)) +geom_point() +geom_smooth(method=lm) +xlab("Days since myExperiment Went Live") +ylab("Downloads") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Upload dates since start \n vs. Downloads")
ggsave(file,file="Upload dates since start \n vs. Downloads.png")
file

# -----------------------------------
# MyExp only: onsite downloads vs. external downloads through time. 

#Also doesn't want to work, and I'm not sure why.

#All
data1=dbGetQuery(con,"select Myexp_d,Ext_d,Uploaded,WF_System from taverna_1")
data2=dbGetQuery(con,"select Myexp_d,Ext_d,Uploaded,WF_System from taverna_2")
data3=dbGetQuery(con,"select Myexp_d,Ext_d,Uploaded,WF_System from rapidminer")
data4=dbGetQuery(con,"select Myexp_d,Ext_d,Uploaded,WF_System from others")
data= combine_data(data1, data2, data3,data4)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600

file = ggplot(data,aes(duration,Ext_d/Myexp_d, shape = data$WF_System)) +geom_point() +xlab("Days since myExperiment Went Live") +ylab("External Downloads over Onsite Downloads") +geom_point() +geom_smooth(method=lm) + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "External vs. Onsite Downloads through time by system")

ggsave(file, file="External vs. Onsite Downloads through time by system.png")
file

# -------------------------------------------------------------------
#Community (Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads) through time

#All
data1=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads, WF_System, Uploaded from taverna_1")
data2=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads, WF_System, Uploaded from taverna_2")
data3=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads, WF_System, Uploaded from rapidminer")
data= rbind(data1, data2, data3)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600
ggplot(data,aes(duration, Attributions+Credits+Favs+Ratings+Citations+Reviews, shape = data$WF_System)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(duration, Attributions+Credits+Favs+Ratings+Citations+Reviews, shape = data$WF_System)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_community_duration.png")

# -------------------------------------------------------------------
#User against length of description

#All
data1=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_2")
data3=dbGetQuery(con,"select User_URL,Uploaded,Description from rapidminer")
data4=dbGetQuery(con,"select User_URL,Uploaded,Description from others")
data= rbind(data1, data2, data3, data4)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
ggplot(data,aes(User_URL,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(User_URL,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="all_User_URL_nchar_description.png")

# ------------------------------------------------------------------
#User against len(title)

#All
data1=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Description from taverna_2")
data3=dbGetQuery(con,"select User_URL,Uploaded,Description from rapidminer")
data4=dbGetQuery(con,"select User_URL,Uploaded,Description from others")
data= rbind(data1, data2, data3, data4)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
ggplot(data,aes(User_URL,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(User_URL,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="all_User_URL_nchar_description.png")


# -------------------------------------------------------------------
#Embeds against user?
#All
data1=dbGetQuery(con,"select User_URL,Uploaded,Embeds from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Embeds from taverna_2")
data= rbind(data1, data2)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
ggplot(data,aes(User_URL,Embeds)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(User_URL,Embeds)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="all_User_URL_Embeds.png")

#Not sure this is actually getting what I want it to get...

#See above for code involving embeds versus no embeds downloads. 

# -------------------------------------------------------------------
#Amount of embeds through time. 

#All
data1=dbGetQuery(con,"select User_URL,Uploaded,Embeds from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Embeds from taverna_2")
data= rbind(data1, data2)
data$Uploaded_date=as.Date(data$Uploaded, "%d/%m/%Y@%H:%M:%S")
data$Start_date=rep("01/11/07@01:01:01",NROW(data))
data$Start_date=as.Date(data$Start_date, "%d/%m/%Y@%H:%M:%S")
data$duration=as.duration(data$Uploaded_date-data$Start_date)
data$duration=data$duration/84600
data$B[data$Embeds==0]="No embeds";
data$B[data$Embeds=='NA']="No embeds";
data$B[data$Embeds>0]="One or more embeds";
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
file = ggplot(subset(data,data$B!="No embeds"),aes(duration,Embeds)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="all_Embeds_duration.png")
file

# -------------------------------------------------------------------
# Embeds only downloaded. 

#All
data1=dbGetQuery(con,"select User_URL,Downloads,Embeds from taverna_1")
data2=dbGetQuery(con,"select User_URL,Downloads,Embeds from taverna_2")
data= rbind(data1, data2)
data$B[data$Embeds==0]="No embeds";
data$B[data$Embeds=='NA']="No embeds";
data$B[data$Embeds>0]="One or more embeds";
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
file = ggplot(subset(data,data$B!="No embeds"),aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="all_Embeds_one_or_more_downloads.png")
file

# -------------------------------------------------------------------
#Beanshells against user - identify experts

#Embeds against user?
#All
data1=dbGetQuery(con,"select User_URL,Uploaded,Beanshells from taverna_1")
data2=dbGetQuery(con,"select User_URL,Uploaded,Beanshells from taverna_2")
data= rbind(data1, data2)
data$User_URL = sub("http://www.myexperiment.org/users/", "", c(data$User_URL))
file = ggplot(data,aes(User_URL,Beanshells)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="all_User_URL_Embeds.png")
file

#Not sure about this one, either...
#Yeah, it isnt. How do I get it to add up each string?

# -------------------------------------------------------------------
#Amount of use of Bio, Soap
# -------------------------------------------------------------------
#Beanshells correlated with tags? with description? (How do we show experts?)
# -------------------------------------------------------------------
# Example Titles by Downloads

#Also not working anymore. Not sure why. 

#All
data1=dbGetQuery(con,"select Title,Downloads from taverna_1")
data2=dbGetQuery(con,"select Title,Downloads from taverna_2")
data3=dbGetQuery(con,"select Title, Downloads from others")
data4=dbGetQuery(con,"select Title, Downloads from rapidminer")
data= combine_data(data1, data2,data3,data4)
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"

file = ggplot(data,aes(Downloads,example_flag)) + xlab("Downloads") + geom_boxplot() + ylab("Example Titles") + geom_point() + geom_smooth(method=lm)  + facet_wrap(~workflow_type) + opts(plot.title = theme_text(size = 20, face = "bold")) + opts(title = "Example Titles by Downloads")
ggsave(file, file="Downloads vs. Views.png")
file

file = ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
ggsave(file, file="all_Title_example_Downloads.png")

#taverna_2
data=dbGetQuery(con,"select Title, Downloads from taverna_2")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
file = ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
ggsave(file, file="taverna_2_Title_example_Downloads.png")

#taverna_1 
data=dbGetQuery(con,"select Title, Downloads from taverna_1")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
file = ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
ggsave(file, file="taverna_1_Title_example_Downloads.png")

#Tavernas
data1=dbGetQuery(con,"select Title,Downloads from taverna_1")
data2=dbGetQuery(con,"select Title,Downloads from taverna_2")
data= rbind(data1, data2)
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
file = ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
ggsave(file, file="tavernas_Title_example_Downloads.png")

# RM
data=dbGetQuery(con,"select Title, Downloads from rapidminer")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
file = ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
ggsave(file, file="rm_Title_example_Downloads.png")

# others
data=dbGetQuery(con,"select Title, Downloads from others")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
file = ggplot(data,aes(example_flag,Downloads)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Downloads")
ggsave(file, file="o_Title_example_Downloads.png")



# -------------------------------------------------------------------
# Example Titles by Views

#taverna_2
data=dbGetQuery(con,"select Title, Views from taverna_2")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
file = ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
ggsave(file, file="taverna_2_Title_example_Views.png")

#taverna_1 
data=dbGetQuery(con,"select Title, Views from taverna_1")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
file = ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
ggsave(file, file="taverna_1_Title_example_Views.png")

#Tavernas
data1=dbGetQuery(con,"select Title,Views from taverna_1")
data2=dbGetQuery(con,"select Title,Views from taverna_2")
data= rbind(data1, data2)
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
file = ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
ggsave(file, file="tavernas_Title_example_Views.png")

# RM
data=dbGetQuery(con,"select Title, Views from rapidminer")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
file = ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
ggsave(file, file="rm_Title_example_Views.png")

# others
data=dbGetQuery(con,"select Title, Views from others")
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
file = ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
ggsave(file, file="o_Title_example_Views.Viewspng")

#All
data1=dbGetQuery(con,"select Title,Views from taverna_1")
data2=dbGetQuery(con,"select Title,Views from taverna_2")
data3=dbGetQuery(con,"select Title, Views from others")
data4=dbGetQuery(con,"select Title, Views from rapidminer")
data= rbind(data1, data2,data3,data4)
regex=which(grepl("example",data$Title, ignore.case=T))
data$example_flag <- rep(NA, NROW(data))
data$example_flag[regex]="Yes"
data$example_flag[-(regex)]="No"
ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
file = ggplot(data,aes(example_flag,Views)) + geom_boxplot() +xlab("Title - 'Example'") +ylab("Views")
ggsave(file, file="all_Title_example_Downloads.png")

# -------------------------------------------------------------------
#Tags, etc. against other things than downloads?
# -------------------------------------------------------------------
#bipcod of second/third uploads against bipcod of first upload, for each user.
# -------------------------------------------------------------------
#amount of tags over time, per user, avg. per workflow, etc. 
# -------------------------------------------------------------------
#Inputs etc. against user
# -------------------------------------------------------------------

# Regular Expressions stats can be found in other files. 

#What would be really useful is if we could compare an authors second+ workflows against their first for complexity. Same with dates,
#length of description, and so on....

# What, specifically, are credits? Attributions? how are they different from citations?

