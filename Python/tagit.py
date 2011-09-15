#An R-graph producing script by Richard L.
#Coded,run,released on July 27th, 2011. 
#Released into the Public Domain like pythons south of Tallahassee. Free.  

#This integrates R with Python using rpy2, although that is fairly limited due to some issues with
#the code. In the end, this is basically a hard-code with argv. It feeds on a document with a list 
#of variables in an SQL column. It will uniquify them, and then run a simple graph to see how the
#the ones with it fare against those that don't have that tag. Argv means it can be pretty well
#changed.

#Let's import some stuff.
import sys
import re
from sets import Set

#The unique function. Gotten off of the web. 
def countDuplicatesInList(dupedList):
   uniqueSet = Set(dupedList.split())
   return [[dupedList.count(item), item] for item in uniqueSet]


#The arguments are as follows:
#python
#code file
#[1] input file
#[2] database
#[3] mined column
#[4] against column
#[5] amount of [1] - either TOP or VIEWS
#[6] amount of [5] you want. 

'''
#Here are the ones I ran:

python tagit.py t1_beanshell_names taverna_1 Beanshell_Names Downloads top 10
python tagit.py t1_input_names taverna_1 Input_Names Downloads top 10
python tagit.py t1_output_names taverna_1 Output_Names Downloads top 10
python tagit.py t1_processor_names taverna_1 Processor_Names Downloads top 10
python tagit.py t1_wf_names taverna_1 WF_Names Downloads top 10
python tagit.py t1_tags taverna_1 Tags Downloads views 50
python tagit.py t2_beanshell_names taverna_2 Beanshell_Names Downloads top 10
python tagit.py t2_input_names taverna_2 Input_Names Downloads top 10
python tagit.py t2_output_names taverna_2 Output_Names Downloads top 10
python tagit.py t2_processor_names taverna_2 Processor_Names Downloads top 10
python tagit.py t2_wf_names taverna_2 WF_Names Downloads top 10
python tagit.py t2_tags taverna_2 Tags Downloads views 50
python tagit.py rapidminer_tags rapidminer Tags Downloads top 10
python tagit.py others_tags others Tags Downloads top 10
python tagit.py rm_op_names rapidminer Op_Names Downloads top 10
'''

#Open a file, into which a list of the amount of times each string is used is added. 
file = open(sys.argv[1])
output_file_name = sys.argv[1]+"-count.txt"
output = open(output_file_name,'a')

#This figures out that list. It also keeps a subset to be graphed. 
graph = []
for line in file.readlines():   
	x = countDuplicatesInList(line)
	x.sort()
	x.reverse()
	h = int(sys.argv[6])
	if (sys.argv[5] == "views"):
		for y in x:
			if y[0] >= h:
				graph.append(y[1])
	if (sys.argv[5] == "top"):
		for y in x[:int(sys.argv[6])]:
			graph.append(y[1])
	output.write(str(x)+ "\n")	
output.close()

#Just to see what you'll be graphing, with the total amount of original strings.
print graph, len(x)

#Another output file, this one makes a document full of ready-to-run R code. 
output_file_name = sys.argv[1]+"-code.r"
output = open(output_file_name,'a')

#After it was all said and done, this turned out to be the easiest way for me to get the length. Go figure. 
#This bit connects to R and gets the information itself. 
from rpy2 import *
from rpy2.robjects import r
f = open('rdata.dat', 'r')

r.library("RMySQL")

#This is how you shouldn't ever code. 
database = "select "
database += sys.argv[4]
database += " from "
database += sys.argv[2]
print database

#Connect to the database. Note, this requires Sequel Pro, probably. 
con=r.dbConnect(r.MySQL(),user="root",password="root",dbname="myExperiment",host="127.0.0.1",port=8889)
data=r.dbGetQuery(con, database)
#All it is used for is to get the length, because that's a common problem. 
row = r.length(data[0])

#This is the first hardcoded graph, with all of the tags combined. It needs some work, I think.
def printfirst():
	print("#"+sys.argv[2] + " " + sys.argv[3] + " (All) by "+sys.argv[4]+"\n data=dbGetQuery(con,\"select "+sys.argv[3]+", "+sys.argv[4]+" from " + sys.argv[2] + "\")\n ggplot(data,aes("+sys.argv[3]+", "+sys.argv[4]+")) + geom_boxplot() +xlab(\"All "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n file = ggplot(data,aes("+sys.argv[3]+", "+sys.argv[4]+")) + geom_boxplot() +xlab(\"All "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n ggsave(file, file=\""+sys.argv[2]+"_"+sys.argv[3]+"_all_"+sys.argv[4]+".png\")\n \n")
	output.write("#"+sys.argv[2] + " " + sys.argv[3] + " (All) by "+sys.argv[4]+"\n data=dbGetQuery(con,\"select "+sys.argv[3]+", "+sys.argv[4]+" from " + sys.argv[2] + "\")\n ggplot(data,aes("+sys.argv[3]+", "+sys.argv[4]+")) + geom_boxplot() +xlab(\"All "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n file = ggplot(data,aes("+sys.argv[3]+", "+sys.argv[4]+")) + geom_boxplot() +xlab(\"All "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n ggsave(file, file=\""+sys.argv[2]+"_"+sys.argv[3]+"_all_"+sys.argv[4]+".png\")\n \n")

#Print it.
printfirst()

#This is the hardcode that actually results in the R code. 
#I wouldn't suggest looking too hard at it, argv isn't pretty.
for x in range(len(graph)):
	graph[x] = graph[x].replace("'","").replace(",","")

	print("#"+sys.argv[2] + " " + sys.argv[3] + " " + graph[x] + " by "+sys.argv[4]+"\n data=dbGetQuery(con,\"select "+sys.argv[3]+", "+sys.argv[4]+" from " + sys.argv[2] + "\")\n regex=which(grepl(\"" + graph[x] + "\",data$"+sys.argv[3]+", ignore.case=T))\n data$"+graph[x]+"_flag <- rep(NA, "+str(row[0])+")\n data$"+graph[x]+"_flag[regex]=\"Yes\"\n data$"+graph[x]+"_flag[-(regex)]=\"No\"\n ggplot(data,aes("+graph[x]+"_flag,"+sys.argv[4]+")) + geom_boxplot() +xlab(\""+graph[x]+" - "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n file = ggplot(data,aes("+graph[x]+"_flag,"+sys.argv[4]+")) + geom_boxplot() +xlab(\"" + graph[x] + " - "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n ggsave(file, file=\""+sys.argv[2]+"_"+sys.argv[3]+"_"+graph[x]+"_"+sys.argv[4]+".png\")\n \n")	

	output.write("#"+sys.argv[2] + " " + sys.argv[3] + " " + graph[x] + " by "+sys.argv[4]+"\n data=dbGetQuery(con,\"select "+sys.argv[3]+", "+sys.argv[4]+" from " + sys.argv[2] + "\")\n regex=which(grepl(\"" + graph[x] + "\",data$"+sys.argv[3]+", ignore.case=T))\n data$"+graph[x]+"_flag <- rep(NA, "+str(row[0])+")\n d
	data$"+graph[x]+"_flag[regex]=\"Yes\"\n data$"+graph[x]+"_flag[-(regex)]=\"No\"\n ggplot(data,aes("+graph[x]+"_flag,"+sys.argv[4]+")) + geom_boxplot() +xlab(\""+graph[x]+" - "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n file = ggplot(data,aes("+graph[x]+"_flag,"+sys.argv[4]+")) + geom_boxplot() +xlab(\"" + graph[x] + " - "+sys.argv[3]+"\") +ylab(\""+sys.argv[4]+"\")\n ggsave(file, file=\""+sys.argv[2]+"_"+sys.argv[3]+"_"+graph[x]+"_"+sys.argv[4]+".png\")\n \n")	

#Close it up. 
output.close()

#woot.