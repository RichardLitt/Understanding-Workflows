# -------------------------------------------------------------------------------------
# An R script to read (modify if you like), analyze and plot data from MySQL tables
# For Richard L.

# -------------------------------------------------------------------------------------
# LOADING LIBRARIES & SETTING WORKING DIRECTORY
# We'll use RMySQL to query the data & ggplot (see http://had.co.nz/ggplot2/ for examples)
# Type in install.packages('RMySQL') to install if you don't have it
# If you don't have ggplot, then run a similar command. install.packages('ggplot2')

library(RMySQL)
library(ggplot2) 

# Set a working directory so all files, especially results and figures are in Dropbox.

setwd("~/Dropbox/DataOne Workflows/DataONE_R")

# -------------------------------------------------------------------------------------
# CONNECTING TO THE DATABASE

# Next, we'll connect to the database. Pretty self-explanatory.
con<-dbConnect(MySQL(),user="inundata_richard",password="v+#c_^o]76cr",dbname="inundata_workflows",host="inundata.org")

# ------------------------------------------------------------------------------------
# Note to Bertram or anyone else trying to run this, I would need to add your hostname into my server's white list to give you access. If you want to play along, look up your hostname here (http://www.displaymyhostname.com/) and send it to me via email.
# ------------------------------------------------------------------------------------


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

dataset_1=dbGetQuery(con,"select Category,C1 from taverna_2 where C1>1000")

# To save this result into a local csv file
write.csv(dataset_1, file = "dataset_1.csv")

names(dataset_1) # shows you the names of the columns. Best to avoid periods in column names in the databsase. Use _ instead.
dim(dataset_1) # shows you how many rows and columns resulted from that query
head(dataset_1) # shows you the top few rows
tail(dataset_1) # shows you the bottom few.

# Now let's make a simple plot with this

ggplot(dataset_1,aes(Category,C1)) + geom_point()

# To save this plot as a jpg, first assign it to a variable
plot_1=ggplot(dataset_1,aes(Category,C1)) + geom_point()
# then save that variable into any format you like for blogging, publication or further editing
ggsave(plot_1,file="first_plot.png") #Use jpg,pdf, or eps to save in such a format



# -------------------------------------------------------------------------------------
# A few more example queries
# See here for some tips: http://www.mysqltutorial.org/mysql-select-statement-query-data.aspx
dataset_1=dbGetQuery(con,"select distinct Category from taverna_2 where C1>1000")

