
#How to fail at integrating R, SQL, and Python. 

'''
#---- Below is the (failed) R integration

Also,
	lm0 = graph[x]
	lm1 = "data$sys.argv[2]"
	lm2 = "data$sys.argv[3]"
	lm3 = "ignore.case=T"
	lm4 = "data$lm0_flag"
	regex=r.which(r.grepl(lm0,lm2,lm3))
	na = "NA"
	num = str(row[0])
	lm1[regex] = "Yes"
	lm1[-(regex)]="No"
	lmstr = "graph[x]_flag~data$sys.argv[4]"
	model=r.lm(lmstr,data=data)
	print r.summary(model)


from rpy2 import *

f = open('rdata', 'r')

from rpy2.robjects import r
import rpy2.robjects as robjects

r.library("RMySQL")
r.library("ggplot2") 
r.library("lubridate")

con=r.dbConnect(r.MySQL(),user="root",password="root",dbname="myExperiment",host="127.0.0.1",port=8889)
table_list=r.dbGetQuery(con,"show tables")

c = robjects.r['c']

# Taverna 2 - "Example"
data=r.dbGetQuery(con,"select Tags,Downloads from taverna_2")
data = list(data)
regex=r.which(r.grepl("Example",data['Tags'])) 
print regex
#r.data$flag[regex]="Yes"
#r.data$flag[-(regex)]="No"
#r.ggplot(data,aes(flag,Downloads)) + geom_boxplot() +xlab("'Example' Tag")
#file = r.ggplot(data,aes(flag,Downloads)) + geom_boxplot() +xlab("'Example' Tag")
#r.ggsave(file, file="t2_tag_example_download.png")
'''