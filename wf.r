# -------------------------------------------------------------------------------------
# An R script to read (modify if you like), analyze and plot data from MySQL tables.
# Specifically, this script reads data screen scraped from myExperiment.
# Created by Karthik R. and Richard L. 

# -------------------------------------------------------------------------------------
# LOADING LIBRARIES & SETTING WORKING DIRECTORY
# We'll use RMySQL to query the data & ggplot (see http://had.co.nz/ggplot2/ for examples)
# Type in install.packages('RMySQL') to install if you don't have it
# If you don't have ggplot, then run a similar command. install.packages('ggplot2')

library(RMySQL)
library(ggplot2) 

# Set a working directory so all files, especially results and figures are in Dropbox.

setwd("~/Dropbox/DataOne Workflows/DataONE_R/Graphs")

# -------------------------------------------------------------------------------------
# CONNECTING TO THE DATABASE

# Next, we'll connect to the database. Pretty self-explanatory.
# Here, I am connecting to my local SQL server, hosted by MAMP.
con<-dbConnect(MySQL(),user="root",password="root",dbname="myExperiment",host="127.0.0.1",port=8889)
table_list=dbGetQuery(con,"show tables")
table_list

# To find which directory files are saved to, type:
getwd()
# -------------------------------------------------------------------------------------

# NOW TO RUN THE QUERIES
# What follows are a few simple examples to get you started.

# First we'll ask the database to return a list of tables.
table_list=dbGetQuery(con,"show tables")


table_list # should show you that there is one table right now.

# If you are unfamiliar with R, table_list is now what is called a 'Data Frame'. Data read from CSVs or Excel also go into dataframes. Dataframes can be queried, joined, or grouped into lists.

# Type in str(table_list) to see its structure in R.


# Now let's look at the structure of the taverna_2 table

dbGetQuery(con,"describe taverna_2")

# Next, we'll write a really simple query. 

dataset_1=dbGetQuery(con,"select Downloads,Views from taverna_2 where Downloads<1000")

# To save this result into a local csv file
write.csv(dataset_1, file = "dataset_1.csv")

names(dataset_1) # shows you the names of the columns. Best to avoid periods in column names in the databsase. Use _ instead.
dim(dataset_1) # shows you how many rows and columns resulted from that query
head(dataset_1) # shows you the top few rows
tail(dataset_1) # shows you the bottom few.

# Now let's make a simple plot with this

ggplot(dataset_1,aes(Downloads,Views)) + geom_point()

# To save this plot as a jpg, first assign it to a variable
plot_1=ggplot(dataset_1,aes(Downloads,Views)) + geom_point()
# then save that variable into any format you like for blogging, publication or further editing
ggsave(plot_1,file="first_plot.png") #Use jpg,pdf, or eps to save in such a format

# -------------------------------------------------------------------------------------
# A few more example queries
# See here for some tips: http://www.mysqltutorial.org/mysql-select-statement-query-data.aspx
dataset_1=dbGetQuery(con,"select distinct Category from taverna_2 where C1>1000")


# -------------------------------------------------------------------------------------
# Specific plots

# -----------------------------------
# Downloads vs. Views

# Taverna 2
data=dbGetQuery(con,"select Views,Downloads from taverna_2")
ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_views_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Views,Downloads from taverna_1")
ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_views_downloads.png")

#RapidMiner
data=dbGetQuery(con,"select Views,Downloads from rapidminer")
ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_views_downloads.png")

#Others
data=dbGetQuery(con,"select Views,Downloads from others")
ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_views_downloads.png")

#Karthiks suggestion (not working at the moment, I must have been confused)
#taverna_1$workflow_type="taverna_1"
#taverna_2$workflow_type="taverna_2"
#tavernas=rbind(taverna_1,taverna_2)

#All
data1=dbGetQuery(con,"select Views,Downloads from taverna_1")
data2=dbGetQuery(con,"select Views,Downloads from taverna_2")
data3=dbGetQuery(con,"select Views,Downloads from rapidminer")
data4=dbGetQuery(con,"select Views,Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Downloads,Views)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_views_downloads.png")

# -----------------------------------
# MyExp only: Downloads vs. Views

#All
data1=dbGetQuery(con,"select Myexp_v,Myexp_d from taverna_1")
data2=dbGetQuery(con,"select Myexp_v,Myexp_d from taverna_2")
data3=dbGetQuery(con,"select Myexp_v,Myexp_d from rapidminer")
data4=dbGetQuery(con,"select Myexp_v,Myexp_d from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_me_views_me_downs.png")

# Taverna 2
ggplot(data2,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_me_views_me_downs.png")

# Taverna 1
ggplot(data1,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_me_views_me_downs.png")

# Rapidminer
ggplot(data3,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_me_views_me_downs.png")

# Others
ggplot(data4,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_me_views_me_downs.png")

# -----------------------------------
# MyExp only: Downloads vs. Views, where d<400 (minus outliers)

#All
data1=dbGetQuery(con,"select Myexp_v,Myexp_d from taverna_1 where Myexp_d<400")
data2=dbGetQuery(con,"select Myexp_v,Myexp_d from taverna_2 where Myexp_d<400")
data3=dbGetQuery(con,"select Myexp_v,Myexp_d from rapidminer where Myexp_d<400")
data4=dbGetQuery(con,"select Myexp_v,Myexp_d from others where Myexp_d<400")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_me_views_me_downs-o.png")

# Taverna 2
ggplot(data2,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2-o_me_views_me_downs-o.png")

# Taverna 1
ggplot(data1,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1-o_me_views_me_downs-o.png")

# Rapidminer
ggplot(data3,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_me_views_me_downs-o.png")

# Others
ggplot(data4,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_d,Myexp_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_me_views_me_downs-o.png")

# -----------------------------------
# MyExp only: Member Downloads vs. Member Views

#All
data1=dbGetQuery(con,"select Myexp_v_m,Myexp_d_m from taverna_1")
data2=dbGetQuery(con,"select Myexp_v_m,Myexp_d_m from taverna_2")
data3=dbGetQuery(con,"select Myexp_v_m,Myexp_d_m from rapidminer")
data4=dbGetQuery(con,"select Myexp_v_m,Myexp_d_m from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_me_member_views_downs.png")

# Taverna 2
ggplot(data2,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_me__member_views_downs.png")

# Taverna 1
ggplot(data1,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_me_member_views_downs.png")

# Rapidminer
ggplot(data3,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_me_member_views_downs.png")

# Others
ggplot(data4,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_d_m,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_me_member_views_downs.png")

# -----------------------------------
# MyExp only: anonymous Downloads vs. anonymous Views

#All
data1=dbGetQuery(con,"select Myexp_v_a,Myexp_d_a from taverna_1")
data2=dbGetQuery(con,"select Myexp_v_a,Myexp_d_a from taverna_2")
data3=dbGetQuery(con,"select Myexp_v_a,Myexp_d_a from rapidminer")
data4=dbGetQuery(con,"select Myexp_v_a,Myexp_d_a from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_me_anon_views_downs.png")

# Taverna 2
ggplot(data2,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_me__anon_views_downs.png")

# Taverna 1
ggplot(data1,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_me_anon_views_downs.png")

# Rapidminer
ggplot(data3,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_me_anon_views_downs.png")

# Others
ggplot(data4,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_d_a,Myexp_v_a)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_me_anon_views_downs.png")

# -----------------------------------
# MyExp only: external views vs. external Downloads

#All
data1=dbGetQuery(con,"select Ext_v,Ext_d from taverna_1")
data2=dbGetQuery(con,"select Ext_v,Ext_d from taverna_2")
data3=dbGetQuery(con,"select Ext_v,Ext_d from rapidminer")
data4=dbGetQuery(con,"select Ext_v,Ext_d from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_me_ext_views_me_ext_downs.png")

# Taverna 2
ggplot(data2,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_me_ext_views_me_ext_downs.png")

# Taverna 1
ggplot(data1,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_me_ext_views_me_ext_downs.png")

# Rapidminer
ggplot(data3,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_me_ext_views_me_ext_downs.png")

# Others
ggplot(data4,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Ext_d,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_me_ext_views_me_ext_downs.png")

# -----------------------------------
# MyExp only: member views vs. anonymous views

#All
data1=dbGetQuery(con,"select Myexp_v,Myexp_v_m from taverna_1")
data2=dbGetQuery(con,"select Myexp_v,Myexp_v_m from taverna_2")
data3=dbGetQuery(con,"select Myexp_v,Myexp_v_m from rapidminer")
data4=dbGetQuery(con,"select Myexp_v,Myexp_v_m from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_myexp_member_views.png")

# Taverna 2
ggplot(data2,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_myexp_member_views.png")

# Taverna 1
ggplot(data1,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_myexp_member_views.png")

# Rapidminer
ggplot(data3,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_myexp_member_views.png")

# Others
ggplot(data4,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_v,Myexp_v_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_myexp_member_views.png")

# -----------------------------------
# MyExp only: member downloads vs. anonymous downloads

#All
data1=dbGetQuery(con,"select Myexp_d,Myexp_d_m from taverna_1")
data2=dbGetQuery(con,"select Myexp_d,Myexp_d_m from taverna_2")
data3=dbGetQuery(con,"select Myexp_d,Myexp_d_m from rapidminer")
data4=dbGetQuery(con,"select Myexp_d,Myexp_d_m from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_myexp_member_down.png")

# Taverna 2
ggplot(data2,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_myexp_member_down.png")

# Taverna 1
ggplot(data1,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_myexp_member_down.png")

# Rapidminer
ggplot(data3,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_myexp_member_down.png")

# Others
ggplot(data4,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_d,Myexp_d_m)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_myexp_member_down.png")

# -----------------------------------
# MyExp only: onsite views vs. external views

#All
data1=dbGetQuery(con,"select Myexp_v,Ext_v from taverna_1")
data2=dbGetQuery(con,"select Myexp_v,Ext_v from taverna_2")
data3=dbGetQuery(con,"select Myexp_v,Ext_v from rapidminer")
data4=dbGetQuery(con,"select Myexp_v,Ext_v from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_myexp_ext_views.png")

# Taverna 2
ggplot(data2,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_myexp_ext_views.png")

# Taverna 1
ggplot(data1,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_myexp_ext_views.png")

# Rapidminer
ggplot(data3,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_myexp_ext_views.png")

# Others
ggplot(data4,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_v,Ext_v)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_myexp_ext_views.png")

# -----------------------------------
# MyExp only: onsite downloads vs. external downloads

#All
data1=dbGetQuery(con,"select Myexp_d,Ext_d from taverna_1")
data2=dbGetQuery(con,"select Myexp_d,Ext_d from taverna_2")
data3=dbGetQuery(con,"select Myexp_d,Ext_d from rapidminer")
data4=dbGetQuery(con,"select Myexp_d,Ext_d from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_myexp_ext_down.png")

# Taverna 2
ggplot(data2,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data2,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t2_myexp_ext_down.png")

# Taverna 1
ggplot(data1,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data1,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="t1_myexp_ext_down.png")

# Rapidminer
ggplot(data3,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data3,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="rm_myexp_ext_down.png")

# Others
ggplot(data4,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data4,aes(Myexp_d,Ext_d)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="o_myexp_ext_down.png")

# -----------------------------------
# Tags vs. Downloads

# Taverna 2
data=dbGetQuery(con,"select Downloads,Number_Tags from taverna_2")
ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_num_tags_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Downloads,Number_Tags from taverna_1")
ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_num_tags_downloads.png")

#Rapidminer
data=dbGetQuery(con,"select Downloads,Number_Tags from rapidminer")
ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_num_tags_downloads.png")

#Others
data=dbGetQuery(con,"select Downloads,Number_Tags from others")
ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_num_tags_downloads.png")

#All
data1=dbGetQuery(con,"select Downloads,Number_Tags from taverna_1")
data2=dbGetQuery(con,"select Downloads,Number_Tags from taverna_2")
data3=dbGetQuery(con,"select Downloads,Number_Tags from rapidminer")
data4=dbGetQuery(con,"select Downloads,Number_Tags from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Downloads,Number_Tags)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_num_tags_downloads.png")

# -----------------------------------
# Bipcod vs. Downloads

# Taverna 2
data=dbGetQuery(con,"select Downloads,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_2")
ggplot(data,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_bipcod_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Downloads,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_1")
ggplot(data,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_bipcod_downloads.png")

# Tavernas
data1=dbGetQuery(con,"select Downloads,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_1")
data2=dbGetQuery(con,"select Downloads,Beanshells,Inputs,Processors,Outputs,Datalinks,Coordinators from taverna_2")
data_all= rbind(data1, data2)
ggplot(data_all,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Downloads,Beanshells+Inputs+Processors+Outputs+Datalinks+Coordinators)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_bipcod_downloads.png")


# -----------------------------------
# Versions vs. Downloads

# Should also probably be a different type of graph

# Taverna 2
data=dbGetQuery(con,"select Downloads,Versions from taverna_2")
ggplot(data,aes(Downloads,Versions)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Versions)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_versions_downloads.png")

#Taverna 1
data=dbGetQuery(con,"select Downloads,Versions from taverna_1")
ggplot(data,aes(Downloads,Versions)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,Versions)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_versions_downloads.png")

# Rapidminer and Others only have one version each.

# Tavernas
data1=dbGetQuery(con,"select Downloads,Versions from taverna_1")
data2=dbGetQuery(con,"select Downloads,Versions from taverna_2")
data_all= rbind(data1, data2)
ggplot(data_all,aes(Downloads,Versions)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Downloads,Versions)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_versions_downloads.png")

# -----------------------------------
# Length of description against amount of downloads
#
# Taverna 2
data=dbGetQuery(con,"select Description,Downloads from taverna_2")
ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_description_len_downloads.png")
	
# Taverna 1
data=dbGetQuery(con,"select Description,Downloads from taverna_1")
ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_description_len_downloads.png")

# RapidMiner
data=dbGetQuery(con,"select Description,Downloads from rapidminer")
ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_description_len_downloads.png")

# Others
data=dbGetQuery(con,"select Description,Downloads from others")
ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_description_len_downloads.png")

#All
data1=dbGetQuery(con,"select Description,Downloads from taverna_1")
data2=dbGetQuery(con,"select Description,Downloads from taverna_2")
data3=dbGetQuery(con,"select Description,Downloads from rapidminer")
data4=dbGetQuery(con,"select Description,Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Downloads,nchar(Description))) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_description_len_downloads.png")

# -----------------------------------
# Length of title against amount of downloads
#
# Taverna 2
data=dbGetQuery(con,"select Title,Downloads from taverna_2")
ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_title_len_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Title,Downloads from taverna_1")
ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_title_len_downloads.png")

#rapidminer
data=dbGetQuery(con,"select Title,Downloads from rapidminer")
ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_title_len_downloads.png")

# others
data=dbGetQuery(con,"select Title,Downloads from others")
ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_title_len_downloads.png")

#All
data1=dbGetQuery(con,"select Title,Downloads from taverna_1")
data2=dbGetQuery(con,"select Title,Downloads from taverna_2")
data3=dbGetQuery(con,"select Title,Downloads from rapidminer")
data4=dbGetQuery(con,"select Title,Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Downloads,nchar(Title))) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_title_len_downloads.png")

# -----------------------------------
# Versions against views
#
# Taverna 2
data=dbGetQuery(con,"select Views,Versions from taverna_2")
ggplot(data,aes(Views,Versions)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Views,Versions)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_views_versions.png")

# Taverna 1
data=dbGetQuery(con,"select Views,Versions from taverna_1")
ggplot(data,aes(Views,Versions)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Views,Versions)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_views_versions.png")

# Rapidminer and Others only have one version each.

# Tavernas
data1=dbGetQuery(con,"select Views,Versions from taverna_1")
data2=dbGetQuery(con,"select Views,Versions from taverna_2")
data_all= rbind(data1, data2)
ggplot(data_all,aes(Views,Versions)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Views,Versions)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_views_downloads.png")

# -----------------------------------
# Favorites against downloads

# Only five favourites at top favourited. 

# Taverna 2
data=dbGetQuery(con,"select Favs,Downloads from taverna_2")
ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_favs_downloads.png")

# Taverna 1
# Seems to have more favourites
data=dbGetQuery(con,"select Favs,Downloads from taverna_1")
ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_favs_downloads.png")

#No Favs for either rapidminer 

# Rapidminer
data=dbGetQuery(con,"select Favs,Downloads from rapidminer")
ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_favs_downloads.png")

#Only four favs for others

#Others
data=dbGetQuery(con,"select Favs,Downloads from others")
ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_favs_downloads.png")


#All
data1=dbGetQuery(con,"select Favs,Downloads from taverna_1")
data2=dbGetQuery(con,"select Favs,Downloads from taverna_2")
data3=dbGetQuery(con,"select Favs,Downloads from rapidminer")
data4=dbGetQuery(con,"select Favs,Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Favs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_favs_downloads.png")

# -----------------------------------
# Citations against downloads

# Taverna 2
# Only two citations

data=dbGetQuery(con,"select Citations,Downloads from taverna_2")
ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_citations_downloads.png")

# Taverna 1
# Only 5
data=dbGetQuery(con,"select Citations,Downloads from taverna_1")
ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_citations_downloads.png")

# Rapidminer
# Only three, negative slope
data=dbGetQuery(con,"select Citations,Downloads from rapidminer")
ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_citations_downloads.png")

#Others
# 3, positive slope
data=dbGetQuery(con,"select Citations,Downloads from others")
ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_citations_downloads.png")

#All
data1=dbGetQuery(con,"select Citations,Downloads from taverna_1")
data2=dbGetQuery(con,"select Citations,Downloads from taverna_2")
data3=dbGetQuery(con,"select Citations,Downloads from rapidminer")
data4=dbGetQuery(con,"select Citations,Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Citations,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_citations_downloads.png")

# -----------------------------------
# Embeds against downloads

# Didnt measure for others, as they were so different. Rapidminer had no measure, either.

# Taverna 2
data=dbGetQuery(con,"select Embeds,Downloads from taverna_2")
ggplot(data,aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_embeds_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Embeds,Downloads from taverna_1")
ggplot(data,aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_embeds_downloads.png")

# Tavernas
data1=dbGetQuery(con,"select Embeds,Downloads from taverna_1")
data2=dbGetQuery(con,"select Embeds,Downloads from taverna_2")
data_all= rbind(data1, data2)
ggplot(data_all,aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Embeds,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_embeds_downloads.png")

# -----------------------------------
# Embeds descriptions against downloads

# Didnt measure for others, as they were so different. Rapidminer had no measure, either.

# Taverna 2 didnt have any.

# Taverna 1
data=dbGetQuery(con,"select WF_Descriptions,Downloads from taverna_1")
ggplot(data,aes(nchar(WF_Descriptions),Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(nchar(WF_Descriptions),Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_embeds_desc_downloads.png")

# -----------------------------------
# total descriptions against downloads

# Taverna 2 - no different from normal description len against Downloads

# Taverna 1
data=dbGetQuery(con,"select WF_Descriptions,Description,Downloads from taverna_1")
ggplot(data,aes(nchar(WF_Descriptions)+nchar(Description),Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(nchar(WF_Descriptions)+nchar(Description),Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_desc_len_tot_downloads.png")


# -----------------------------------
# Outputs vs. Downloads

#Taverna 2
data=dbGetQuery(con,"select Outputs,Downloads from taverna_2")
ggplot(data,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_outputs_downloads.png")

#Taverna 1
data=dbGetQuery(con,"select Outputs,Downloads from taverna_1")
ggplot(data,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_outputs_downloads.png")

# Tavernas
data1=dbGetQuery(con,"select Outputs,Downloads from taverna_1")
data2=dbGetQuery(con,"select Outputs,Downloads from taverna_2")
data_all= rbind(data1, data2)
ggplot(data_all,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_outputs_downloads.png")

#Rapidminer
# ONly 4 non-zeros
data=dbGetQuery(con,"select Outputs,Downloads from rapidminer")
ggplot(data,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Outputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_outputs_downloads.png")

#Others not possible. 


# -----------------------------------
# Outputs vs. Inputs

#This is definitely not the right graph for this.

# Taverna 2
data=dbGetQuery(con,"select Outputs,Inputs from taverna_2")

ggplot(data,aes(factor(Inputs),Outputs)) +geom_boxplot()
file = ggplot(data,aes(factor(Inputs),Outputs)) +geom_boxplot()
ggsave(file,file="tavernas_inputs_outputs_box.png")

ggplot(data,aes(Inputs,Outputs)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Inputs,Outputs)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_inputs_outputs.png")


# -----------------------------------
# Inputs vs. Downloads

#Taverna 2
data=dbGetQuery(con,"select Inputs,Downloads from taverna_2")
ggplot(data,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_inputs_downloads.png")

#Taverna 1
data=dbGetQuery(con,"select Inputs,Downloads from taverna_1")
ggplot(data,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_inputs_downloads.png")

# Tavernas
data1=dbGetQuery(con,"select Inputs,Downloads from taverna_1")
data2=dbGetQuery(con,"select Inputs,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(Inputs),Downloads)) +geom_boxplot()
file = ggplot(data_all,aes(factor(Inputs),Downloads)) +geom_boxplot()
ggsave(file,file="tavernas_inputs_downloads_box.png")

ggplot(data_all,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_inputs_downloads.png")

#Rapidminer
# ONly 7 non-zeros
data=dbGetQuery(con,"select Inputs,Downloads from rapidminer")
ggplot(data,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Inputs,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_inputs_downloads.png")

#Others not possible. 

# -----------------------------------
# Beanshells vs Downloads

#Taverna 2
data=dbGetQuery(con,"select Beanshells,Downloads from taverna_2")
ggplot(data,aes(Beanshells,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Beanshells,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_beanshells_downloads.png")

#Taverna 1
data=dbGetQuery(con,"select Beanshells,Downloads from taverna_1")
ggplot(data,aes(Beanshells,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Beanshells,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_beanshells_downloads.png")

#Tavernas
data1=dbGetQuery(con,"select Beanshells,Downloads from taverna_1")
data2=dbGetQuery(con,"select Beanshells,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(Beanshells),Downloads)) +geom_boxplot()
file = ggplot(data_all,aes(factor(Beanshells),Downloads)) +geom_boxplot()
ggsave(file,file="tavernas_beanshells_downloads_box.png")

ggplot(data_all,aes(Beanshells,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Beanshells,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_beanshells_downloads.png")

#For all of these, 89 workflows denied scraping access to myExperiment. 

# -----------------------------------
# Amount of descriptions in the workflow vs. downloads

#Taverna 2 (only one available)
data=dbGetQuery(con,"select Descriptions,Downloads from taverna_2")

ggplot(data,aes(factor(Descriptions),Downloads)) +geom_boxplot()
file = ggplot(data,aes(factor(Descriptions),Downloads)) +geom_boxplot()
ggsave(file,file="t2_descriptions_in_wfmeta_downloads_box.png")

ggplot(data,aes(Descriptions,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Descriptions,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_descriptions_in_wfmeta_downloads.png")

# -----------------------------------
# Title in the workflow vs. Downloads

#Taverna2 (ibid.)
data=dbGetQuery(con,"select Titles, Downloads from taverna_2")

ggplot(data,aes(factor(Titles),Downloads)) +geom_boxplot()
file = ggplot(data,aes(factor(Titles),Downloads)) +geom_boxplot()
ggsave(file,file="t2_titles_downloads_box.png")

ggplot(data,aes(Titles,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Titles,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_titles_downloads.png")

# -----------------------------------
# Amount of information in the workflow (Authors, Title, Descriptions) vs. Downloads

#Taverna 2 (ibid.)
data=dbGetQuery(con,"select Titles, Authors, Descriptions,Downloads from taverna_2")
ggplot(data,aes(Titles+Authors+Descriptions,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Titles+Authors+Descriptions,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_tad_downloads.png")

# -----------------------------------
# Authors vs. Downloads
# One vs. All - would be useful to have this sort of judge

# Taverna 2
data=dbGetQuery(con,"select Authors,Downloads from taverna_2")
ggplot(data,aes(factor(Authors),Downloads)) +geom_boxplot()
file = ggplot(data,aes(factor(Authors),Downloads)) +geom_boxplot()
ggsave(file,file="t2_authors_downloads.png")

# -----------------------------------
# local vs. downloads

# Taverna 2
data=dbGetQuery(con,"select Local_N,Downloads from taverna_2")
ggplot(data,aes(Local_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Local_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_local_n_downloads.png")

#Taverna 1
data=dbGetQuery(con,"select Local_N,Downloads from taverna_1")
ggplot(data,aes(Local_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Local_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_local_n_downloads.png")

#Tavernas
data1=dbGetQuery(con,"select Local_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Local_N,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(Local_N),Downloads)) +geom_boxplot()
box = ggplot(data_all,aes(factor(Local_N),Downloads)) +geom_boxplot()
ggsave(box, file="tavernas_Local_N_downloads_box.png")

ggplot(data_all,aes(Local_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Local_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_Local_N_downloads.png")

# -----------------------------------
# string vs. downloads

# Taverna 2
data=dbGetQuery(con,"select String_N,Downloads from taverna_2")
ggplot(data,aes(String_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(String_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_string_n_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select String_N,Downloads from taverna_1")
ggplot(data,aes(String_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(String_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_string_n_downloads.png")

#Tavernas
data1=dbGetQuery(con,"select String_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select String_N,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(String_N),Downloads)) +geom_boxplot()
box = ggplot(data_all,aes(factor(String_N),Downloads)) +geom_boxplot()
ggsave(box, file="tavernas_String_N_downloads_box.png")

ggplot(data_all,aes(String_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(String_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_String_N_downloads.png")

# -----------------------------------
# wsdl vs. downloads

# Taverna 2
data=dbGetQuery(con,"select Wsdl_N,Downloads from taverna_2")
ggplot(data,aes(Wsdl_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Wsdl_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_wsdl_n_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Wsdl_N,Downloads from taverna_1")
ggplot(data,aes(Wsdl_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Wsdl_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_wsdl_n_downloads.png")

#Tavernas
data1=dbGetQuery(con,"select Wsdl_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Wsdl_N,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(Wsdl_N),Downloads)) +geom_boxplot()
box = ggplot(data_all,aes(factor(Wsdl_N),Downloads)) +geom_boxplot()
ggsave(box, file="tavernas_wsdl_n_downloads_box.png")

ggplot(data_all,aes(Wsdl_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Wsdl_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_Wsdl_N_downloads.png")

# -----------------------------------
# XML vs. downloads

###Something might not be working here.

# Taverna 2
data=dbGetQuery(con,"select Xml_N,Downloads from taverna_2")
ggplot(data_all,aes(factor(Xml_N),Downloads)) +geom_boxplot()
box = ggplot(data_all,aes(factor(Xml_N),Downloads)) +geom_boxplot()
ggsave(box, file="tavernas_xml_n_downloads_box.png")

ggplot(data,aes(Xml_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Xml_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_xml_n_downloads.png")

# Taverna 1 brought up zero.

# -----------------------------------
# Bio vs. downloads

# Taverna 2
data=dbGetQuery(con,"select Bio_N,Downloads from taverna_2")
ggplot(data,aes(Bio_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Bio_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_bio_n_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Bio_N,Downloads from taverna_1")
ggplot(data,aes(Bio_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Bio_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_bio_n_downloads.png")

#Tavernas
data1=dbGetQuery(con,"select Bio_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Bio_N,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(Bio_N),Downloads)) +geom_boxplot()
box = ggplot(data_all,aes(factor(Bio_N),Downloads)) +geom_boxplot()
ggsave(box, file="tavernas_bio_n_downloads_box.png")

ggplot(data_all,aes(Bio_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Bio_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_Bio_N_downloads.png")

# -----------------------------------
# SOAP vs. downloads

# Taverna 2
data=dbGetQuery(con,"select Soap_N,Downloads from taverna_2")
ggplot(data,aes(Soap_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Soap_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_soap_n_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Soap_N,Downloads from taverna_1")
ggplot(data,aes(Soap_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Soap_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_soap_n_downloads.png")

#Tavernas
data1=dbGetQuery(con,"select Soap_N,Downloads from taverna_1")
data2=dbGetQuery(con,"select Soap_N,Downloads from taverna_2")
data_all= rbind(data1, data2)

ggplot(data_all,aes(factor(Soap_N),Downloads)) +geom_boxplot()
box = ggplot(data_all,aes(factor(Soap_N),Downloads)) +geom_boxplot()
ggsave(box, file="tavernas_soap_n_downloads_box.png")

ggplot(data_all,aes(Soap_N,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Soap_N,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="tavernas_Soap_N_downloads.png")


# -----------------------------------
# myExperiment use: attributions, credits, reviews, favourites, ratings, comments vs. downloads

# Taverna 2
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from taverna_2")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_community_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from taverna_1")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_community_downloads.png")

# Rapid Miner
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from rapidminer")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_community_downloads.png")

# Others
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from others")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_community_downloads.png")

#All
data1=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from taverna_1")
data2=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from taverna_2")
data3=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from rapidminer")
data4=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Comments, Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews + Comments,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_community_downloads.png")

# -----------------------------------
# myExperiment use: attributions, credits, reviews, favourites, ratings vs. downloads
# minus comments as those are often from the Authors

# Taverna 2
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from taverna_2")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t2_community_nc_downloads.png")

# Taverna 1
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from taverna_1")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="t1_community_nc_downloads.png")

# Rapid Miner
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from rapidminer")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews, Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="rm_community_nc_downloads.png")

# Others
data=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from others")
ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews, Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file,file="o_community_nc_downloads.png")

#All
data1=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from taverna_1")
data2=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from taverna_2")
data3=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from rapidminer")
data4=dbGetQuery(con,"select Attributions, Credits, Favs, Ratings, Citations, Reviews, Downloads from others")
data_all= rbind(data1, data2, data3, data4)
ggplot(data_all,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
file = ggplot(data_all,aes(Attributions + Credits + Favs + Ratings + Citations + Reviews,Downloads)) +geom_point() +geom_smooth(method=lm)
ggsave(file, file="all_community_nc_downloads.png")

# --------------------------------------------------------------------------------------------------------------------------------------------

#Things  I would like to do:

# -----------------------------------
# When Updated vs. Downloads

# -----------------------------------
# When Uploaded vs. Rate of Downloads

# Look up specific tags, processors, datalinks, embedded workflows, etc. which help downloadability
# What are credits? Attributions? how are they different from citations?

data=read.csv(file='~/Desktop/Taverna_1_view.csv',header=T)
p <- ggplot(data, aes(factor(User_URL), Downloads))
p + geom_boxplot()