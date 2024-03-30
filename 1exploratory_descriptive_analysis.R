# ---------------------------------------------------------------------------------
#Project for Applied Statistics Course
# Author: Theodor Nowicki
# Finish date: 5.04.2022
# Script: Exploratory and Descriptive Analysis
# ---------------------------------------------------------------------------------

library(foreign)
library(tidyverse)
library(tidyselect)
library(car)
library(ggpubr)
library(rcompanion)
library(psych)
library(faraway)
library(broom)
library(pwr)


# Reading in the data
dataTN <- read.csv("dataTN.Rdata", 
                       header = TRUE, 
                       sep = ";")


# Descriptive analysis
str(dataTN)
summary(dataTN)

pie(table(dataTN$Sexf))    
pie(table(dataTN$Eduf))     
pie(table(dataTN$Neuf))     
pie(table(dataTN$Psyf))

hist(table(dataTN$Age),main = 'Age', xlab = 'Age')
hist(table(dataTN$BRIEF), main = 'BRIEF',xlab = 'BRIEF', ylab = 'Frequency', col = 'lightblue',axisnames =  TRUE)  
hist(table(dataTN$DASS),main = 'DASS',xlab = 'DASS', ylab = 'Frequency', col = 'orangered' ,axisnames =  TRUE)   
hist(table(dataTN$SVK),main = 'SVC',xlab = 'SVC', ylab = 'Frequency', col = 'lightgreen',axisnames =  TRUE )    

boxplot(dataTN$Age)
boxplot(dataTN$BRIEF)
boxplot(dataTN$DASS)
boxplot(dataTN$SVK)

# Winsorized variance and mean
# Download from: http://dornsife.usc.edu/labs/rwilcox/software/
source("Rallfun-v39.txt")
winmean(dataTN$Age,na.rm = TRUE)
winvar(dataTN$Age,tr = 0.2,na.rm = TRUE)

winmean(dataTN$BRIEF,na.rm = T)
winvar(dataTN$BRIEF,na.rm = T)

winmean(dataTN$DASS,na.rm = T)
winvar(dataTN$DASS,na.rm = T)

winmean(dataTN$SVK,na.rm = T)
winvar(dataTN$SVK,na.rm = T)

# Trimmed means and median
mean(dataTN$Age,trim= 0.1, na.rm= T)    
mad(dataTN$Age,na.rm= T)

mean(dataTN$BRIEF,trim= 0.1, na.rm= T)    
mad(dataTN$BRIEF, na.rm= T)

mean(dataTN$DASS,trim= 0.1, na.rm= T)
mad(dataTN$DASS,na.rm= T)

mean(dataTN$SVK,trim= 0.1, na.rm= T)
mad(dataTN$SVK,na.rm= T)

# Non-robust measures
mean(dataTN$Age, na.rm= T)    
median(dataTN$Age,na.rm= T)
sd(dataTN$Age, na.rm= T)

mean(dataTN$BRIEF,na.rm= T)    
median(dataTN$BRIEF,na.rm= T)
sd(dataTN$BRIEF,na.rm= T)

mean(dataTN$DASS, na.rm= T)
median(dataTN$DASS,na.rm= T)
sd(dataTN$DASS,na.rm= T)

mean(dataTN$SVK, na.rm= T)
median(dataTN$SVK,na.rm= T)
sd(dataTN$SVK,na.rm= T)

mean(dataTN$Edu_num, na.rm= T)
median(dataTN$Edu_num,na.rm= T)
sd(dataTN$Edu_num,na.rm= T)

# Difference between robust measures and non-robust measures small


# Simple bivariate analysis
# Correlations continuous variables
cor(dataTN$DASS,dataTN$BRIEF, 'pairwise.complete.obs')  
cor(dataTN$DASS,dataTN$SVK, 'pairwise.complete.obs')   
cor(dataTN$SVK,dataTN$BRIEF, 'pairwise.complete.obs')   
cor(dataTN$Age,dataTN$BRIEF, 'pairwise.complete.obs')   
cor(dataTN$Age,dataTN$SVK, 'pairwise.complete.obs')     

# Bivariate analysis categorical with continuous variables
# First check visually
ggboxplot(dataTN, x = "Sexf", y = "BRIEF", 
          color = "Sexf", palette = c("#00AFBB", "#E7B800"),
          ylab = "EF", xlab = "Sex")

ggboxplot(dataTN, x = "Sexf", y = "SVK", 
          color = "Sexf", palette = c("#00AFBB", "#E7B800"),
          ylab = "Visual complains", xlab = "Sex")

ggboxplot(dataTN, x = "Neuf", y = "BRIEF", 
          color = "Neuf", palette = c("#00AFBB", "#E7B800"),
          ylab = "EF", xlab = "Neurologist")

ggboxplot(dataTN, x = "Neuf", y = "SVK", 
          color = "Neuf", palette = c("#00AFBB", "#E7B800"),
          ylab = "visual complains", xlab = "Neurologist")          

ggboxplot(dataTN, x = "Psyf", y = "BRIEF", 
          color = "Psyf", palette = c("#00AFBB", "#E7B800"),    
          ylab = "EF", xlab = "Psychologist")                     

ggboxplot(dataTN, x = "Psyf", y = "SVK", 
          color = "Psyf", palette = c("#00AFBB", "#E7B800"),    
          ylab = "Visual complaints", xlab = "Psychologist")       

ggboxplot(dataTN, x = "Psyf", y = "DASS", 
          color = "Psyf", palette = c("#00AFBB", "#E7B800"),    
          ylab = "Depression and Anxiety", xlab = "Psychologist") 

# Conduct Wilcoxon rank sum test
Wtest1 <- wilcox.test(SVK ~ Neuf, data = dataTN,
                      exact = FALSE)
Wtest1 
Wtest2<- wilcox.test( SVK ~ Psyf, data = dataTN,
                      exact = FALSE)
Wtest2 
Wtest3<- wilcox.test( BRIEF ~ Psyf, data = dataTN,
                      exact = FALSE)
Wtest3 
Wtest4<- wilcox.test( DASS ~ Psyf, data = dataTN,
                      exact = FALSE)
Wtest4 

# Calculate effect sizes
wilcoxonR(x = dataTN$SVK, g= dataTN$Neuf,ci=TRUE,conf=0.95,type='perc')
wilcoxonR(x = dataTN$SVK, g= dataTN$Psyf,ci=TRUE,conf=0.95,type='perc')
wilcoxonR(x = dataTN$BRIEF, g= dataTN$Psyf,ci=TRUE,conf=0.95,type='perc')
wilcoxonR(x = dataTN$DASS, g= dataTN$Psyf,ci=TRUE,conf=0.95,type='perc')

# Conduct t-tests and CIs
table(dataTN$Neuf)
table(dataTN$Psyf)
t.test(dataTN$SVK~ dataTN$Neuf,conf.level = 0.95)
t.test(dataTN$SVK~ dataTN$Psyf,conf.level = 0.95)
t.test(dataTN$BRIEF~dataTN$Psyf,conf.level = 0.95)        
t.test(dataTN$DASS~ dataTN$Psyf,conf.level = 0.95)  

d1 <- cohen.d(dataTN$SVK,dataTN$Neuf)
d1
dci1 <- d.ci(0.23,n1=300,n2=100)
dci1
d2 <- cohen.d(dataTN$SVK,dataTN$Psyf)
d2
dci2 <- d.ci(0.19,n1=276,n2=124)
dci2
d3 <- cohen.d(dataTN$BRIEF,dataTN$Psyf)
d3
dci3 <- d.ci(0.39,n1=276,n2=124)
dci3
d4 <- cohen.d(dataTN$DASS,dataTN$Psyf)
d4
dci4 <- d.ci(0.36,n1=276,n2=124)
dci4
