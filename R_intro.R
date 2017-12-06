#Some resouces

#See here for R: https://www.r-project.org/
#See here for Rstudio: https://www.rstudio.com/
#See here for bioconductor: https://www.bioconductor.org/
#See here for ggplot2: http://ggplot2.org/
#Cool ggplot2 cheat sheet: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
#Other useful cheat sheets for R/Rstudio: https://www.rstudio.com/resources/cheatsheets/
#Software Carpentry R tutorial: http://swcarpentry.github.io/r-novice-inflammation/

#############Data Structures in R#####################
#vectors are the simplest form of data storage#
#There are three basic types of data in R (numbers, charaxters, and logicals)
#plus one special type (factors) that we can discuss later
#Data can be stored in four basic data structures
#vectore, matrices, lists, and dataframes

#vectors can be created with the c() function
#we can check what kind of data we are looking at with the is() function

#Example of a numeric vector
c(4,2,8,10)
is(c(4,2,8,10))

#logical
c(TRUE,FALSE,T,F)
is(c(TRUE,FALSE,T,F))

#character
c("I", "like","sandwiches")
is(c("I", "like","sandwiches"))

#data in vectors can only be one type, R will try to guess what it is
c(1,"sandwich is delicious",TRUE)
is(c(1,"sandwich is delicious",TRUE))

#c() and is() are functions, or commands that operate on specific objects
# You can get help with a function using a ?
?c

#You can save data in an object this can be done with an equal sign
#or an arrow
x=c(4,2,8,10.5)
x

#Operations can be preformed on data 
x
x + 2
x + x
x * 2
c(x,x)

#There are many other functions that operate on vectors
sum(x)
max(x)
min(x)
median(x)
mean(x)

#A vector of numbers can be specified by a colon
1:10
200:240
x<-1:10
x
x<-rev(1:10)
x
#Extracting part of a dataset is called subseting. 
#For vectors we can accomplish this by specifying the position in the vector we want to extract
x[3]
x[3:5]

#We can subset by a logical as well. To compare numerics we typically use >,<,==,>=,<=,!=
x
x>4
x[x>4]
x[x<4]
x[x==4]
x[x>=4]
x[x!=3]

#A matrix is a way to store two dimensional data of one type
y<-matrix(x,nrow=2,ncol=5)
y
is(y)

#There are many functions to get information about a matrix
#The simplest will tell you the dimensions of the matrix
dim(y)
ncol(y)
nrow(y)

#Others will preform tasks across a rows or columns
rowSums(y)
colSums(y)

#Matrices can be subseted as well, but this is usually done in two dimensions separated by a quote
y
y[1,]
y[,2]
y[1,2]

#In statistics datasets often include numerical and factor data
#For example one might measure populations of different cities across the US
#dataframes allow for many data types to be stored together
#Lets read in some data to analyze with R
#R can read in data in many ways, see ?read.table() ?read.csv() read.delim
#This dataset contains a series of mpg data for popular cars in the 1990's and 2000's
#read mpg dataset
mpgdata<-read.csv("DATA/mpg.csv")
#What kind of data structure is this?
#How would you figure out what kind of data it is?

#lets take a quick peak at the data
dim(mpgdata)
head(mpgdata)

#this dataframe has column names, which allows us to subset the data in a new way:
mpgdata[,2]
mpgdata$model

#Did you notice something unusual with the output?
#The levels at the bottom of the output are an attribute of a factor
#Factors are like character vectors, but they have a special characteristic of being ordered
c("I'm first!","I'm second")
factor(c("I'm first!","I'm second"))

#Having relative levels can be useful when summarizing or plotting data, for example:
the_seasons<-c("Winter","Summer","Summer","Spring")
#We can summarize the occurances of the seasons using table:
table(the_seasons)
#However they are in alphabetical order, but in real life they have a different order
#Plus, there is no entry 0 for fall we can specify levels to fix this problem
table(factor(the_seasons))
table(factor(the_seasons,levels=c("Winter","Spring","Summer","Fall")))

#In the case of our mpg data, levels don't really make a ton of sense for manufacturer
#But in some cases it does
#for example, for the class of cars
table(mpgdata$class)
table(factor(mpgdata$class,levels = c("2seater","subcompact","compact","midsize","minivan","pickup","suv")))

#If we specify levels, the order of the classes makes more sense
#We can replace parts of an object as follows
mpgdata$class<-factor(mpgdata$class,levels = c("2seater","subcompact","compact","midsize","minivan","pickup","suv"))
#Now the data will be re-leveled by car size
table(mpgdata$class)

#Ok, lets explore the data with visualization!
#We would like to understand how these different vehicles differ in miles per gallon
#The first thing to explore is what is the distribution of the data
mpgdata$cty
hist(mpgdata$cty)
hist(mpgdata$cty,breaks=10)

#This plot type is a histogram and shows the overall distribution of the data.
#It is important to visualize datsets in this way
#First, it allows you to spot mistakes in the dataset if they are far outside of most of the range
#Also, it allows you to explore whether the data are distributed normally, which is essential
#To descide how to plot/do statistics/transform the dataset
#Question: Is this data normal?

#R makes it easy to calculate summary statistics
mean(mpgdata$cty)
median(mpgdata$cty)
sd(mpgdata$cty)

#This is fine, but maybe we would like to compare mpg by class
#This kind of analysis is where R is particularly powerful
#One way to do this would be to subset based on the classes
mean(mpgdata$cty[mpgdata$class=="2seater"])
mean(mpgdata$cty[mpgdata$class=="suv"])

#Howver, this is annoyingly slow
#This can be accomplished witht he aggregate function
class_means<-aggregate(mpgdata$cty~mpgdata$class,FUN=mean)
class_means

#we can plot this data like this:
plot(class_means)

#this is obviously a very simple plot, but the plot function has may ways to modify output
#We can modify the range of the y axis like this
plot(class_means,ylim=c(0,40))

#We can modify the direction of the labels with las
plot(class_means,ylim=c(0,40),las=2)

#There are many, many different modifications that can be made
#See ?par for these options

#While our plot of the means is useful, it hides the variation within each class
#A typical representation that includes this variation is a boxplot
boxplot(mpgdata$cty~mpgdata$class)

#Now we can see that the means were overall reflective of the distribution, but
#Some data was hidden
#What do the line, box, wiskers and points means here?
#Hint:see the boxplot help

#perhaps the simplest type of plot is a scatter plot
#For example, we could explore the relationship between mpg in the city and hwy
plot(mpgdata$cty,mpgdata$hwy)

#We can make many modifications to this plot, for example, we can change the type of symbol that is plotted
plot(mpgdata$cty,mpgdata$hwy,pch=1)
plot(mpgdata$cty,mpgdata$hwy,pch=2)
plot(mpgdata$cty,mpgdata$hwy,pch=3)
plot(mpgdata$cty,mpgdata$hwy,pch=16)
#We can also change the size of the symbols like this:
plot(mpgdata$cty,mpgdata$hwy,pch=16,cex=1)
plot(mpgdata$cty,mpgdata$hwy,pch=16,cex=.5)
plot(mpgdata$cty,mpgdata$hwy,pch=16,cex=2)

#We also might be interested in coloring the points
#R is very flexible in specifying color
#A simple way to specify color is to use the prespecified color names
colors()
plot(mpgdata$cty,mpgdata$hwy,pch=16,col="tomato")
plot(mpgdata$cty,mpgdata$hwy,pch=16,col="thistle")

#We can also specify colors on the rgb scale using the rgb command
plot(mpgdata$cty,mpgdata$hwy,pch=16,col=rgb(0,0,0))
plot(mpgdata$cty,mpgdata$hwy,pch=16,col=rgb(1,0,0))
plot(mpgdata$cty,mpgdata$hwy,pch=16,col=rgb(1,0,1))
plot(mpgdata$cty,mpgdata$hwy,pch=16,col=rgb(.5,0,.5))

#A common problem in statistical plotting is that there are overlapping points
#This is the case in our current plot
#There are many ways to deal with this issue
#One is to add transparency to the plot, which can be done with the alpha of the rgb command
plot(mpgdata$cty,mpgdata$hwy,pch=16,col=rgb(.5,0,.5))
plot(mpgdata$cty,mpgdata$hwy,pch=16,col=rgb(.5,0,.5,.2))

#Now overlapping points are darker in color
#Another way to do this is to add jitter
plot(jitter(mpgdata$cty),jitter(mpgdata$hwy),pch=16,col=rgb(.5,0,.5,.2))
#jitter will slightly modify the value so that overlapping values are no longer exactly
#the same. Of course this means that the data is no longer exactly the same either
#and this must be mentioned in a legened
#However a small amount of jitter will not change the over all appearance of the plot
#and prevents overlaps from being hidden
#The amount of jitter can be controlled directly in the jitter function

#We might want the colors in the plot to mean something
#For example maybe we want to color by class

#We can do this simply as follows
plot(jitter(mpgdata$cty),jitter(mpgdata$hwy),pch=16,col=mpgdata$class,cex=.7)
#We can also add a legend as follows
legend(8,45,unique(mpgdata$class),col=1:length(mpgdata$class),pch=16)

#As you can see, our plot is getting quite a bit more complicated to specify.
#and it is not yet really publication quality
#R has two main plotting systems
#So far we have been using Base, which is great for making simple plots
#It can also make complicated plots, but the commands get pretty complicated
#An alternative is found in the ggplot2 package
#ggplot2 is designed to make the production of nice looking plots simplified
#let's load ggplot2 and try it out 
library(ggplot2)
#This loads the ggplot2 package
#There are thousands of packages that are availiable in R that add functionality
#We will not have time to explore these today, but it is important to be aware\
#Of their existance
#Lets try a plot:
g<-ggplot(mpgdata,
       aes(x=cty,
           y=hwy,
           color=class))+
  geom_point()
g

#Let's break this down
#In ggplot we creat a plot from two basic parts
#1: aesthetic which is something you can see
#This could be the position of a point, a color or a shape for example.
#2: geometric objects. These are the actual things we will draw on the plot
#For example, a line, a point, a bar, or a boxplot

#here is an example of a boxplot
g<-ggplot(mpgdata,
          aes(x=class,
              y=hwy,
              ))+
  geom_boxplot()
g

#Or the same data as points
g<-ggplot(mpgdata,
          aes(x=class,
              y=hwy,
          )) +
  geom_point()
g
#Perhaps we would like to show both the boxplot and the raw data
#We can add a second plot as follows
g<-ggplot(mpgdata,
          aes(x=class,
              y=hwy,
          ))+
  geom_boxplot()
g + geom_point()

#We can map additional aesthetic data onto a plot as follows
g<-ggplot(mpgdata,
          aes(x=cty,
              y=hwy
              )) +
  geom_point(aes(color=class,
                 shape=factor(cyl)))
g

#We can also make histograms or density plots
g <- ggplot(mpgdata, aes(x = cty))
g + geom_histogram(binwidth=4)
g + geom_density()
g + geom_density(aes(fill=1))

#ggplot has several themes that can be used to change the general plot appearance
g + geom_density(aes(fill=1))

#
g <- ggplot(mpgdata, aes(factor(year), cty))
g + geom_bar(stat = "identity")

g + geom_dotplot(binaxis = "y", stackdir = "center",binwidth=.3) + geom_boxplot(fill=rgb(0,0,0,0)) +  facet_grid(. ~ cyl)
# Plot
theme_set(theme_minimal())
g <- ggplot(mpg, aes(hwy))
g + geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="City Mileage Grouped by Number of cylinders",
       caption="Source: mpg",
       x="City Mileage",
       fill="# Cylinders")

theme_set(theme_grey())
g + geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="City Mileage Grouped by Number of cylinders",
       caption="Source: mpg",
       x="City Mileage",
       fill="# Cylinders")

theme_set(theme_classic())
g + geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
  labs(title="Density plot", 
       subtitle="City Mileage Grouped by Number of cylinders",
       caption="Source: mpg",
       x="City Mileage",
       fill="# Cylinders")



############################
library("biomaRt")
listMarts(host="plants.ensembl.org")
ensembl<-useMart("plants_mart",host="plants.ensembl.org")
listDatasets(ensembl)

#
ensembl<-useMart("plants_mart",host="plants.ensembl.org",dataset = "athaliana_eg_gene")
#
filters = listFilters(ensembl)
filters
#
attributes = listAttributes(ensembl)
attributes
#
dataset<-getBM(c("chromosome_name",
                 "start_position",
                 "end_position",
                 "ensembl_gene_id",
                 "transcript_biotype",
                 "external_gene_name",
                 "percentage_gene_gc_content"),
               mart=ensembl,
               filters="transcript_biotype",
               values="protein_coding")
#
dataset<-dataset[order(dataset[,1],dataset[,2]),]
#
plot(dataset[,2])
plot(dataset[,3]-dataset[,2])
plot(dataset[,7])
boxplot(dataset[,7]~dataset[,1])
