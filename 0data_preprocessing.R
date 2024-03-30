# ---------------------------------------------------------------------------------
#Project for Applied Statistics Course
# Author: Theodor Nowicki
# Finish date: 5.04.2022
# Script: Data Preprocessing and Cleaning
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




# Reading in the data
data_total <- read.csv("Data_total.csv", 
                       header = TRUE, 
                       sep = ";")


# Creating a new data frame with only the relevant variables
df <- subset(data_total, select = c(Age, Sex, Education_3levels, 
                                    Neurologist, Psychiatrist, BRIEF_total, 
                                    DASS_total, SVK_Total))

# Selecting a subset of participants
set.seed(7)
dataTN <- sample_n(df, 400)


# Check datatypes
str(dataTN)   

# Add categorical variables as factors and numeric, others only as numeric
dataTN <- dataTN %>%
  mutate(Sex_num = as.numeric(Sex) , Neu_num = as.numeric(Neurologist), Psy_num = as.numeric(Psychiatrist), 
         Edu_num = as.numeric(Education_3levels),BRIEF = as.numeric(BRIEF_total),DASS = as.numeric(DASS_total),SVK = as.numeric(SVK_Total), 
         Age = as.numeric(Age)) 

dataTN <- dataTN %>%
  mutate(Eduf = factor(Edu_num, labels= c("low","medium","high")), 
         Sexf = factor(Sex, labels= c("male","female")),Neuf = factor(Neurologist, labels= c("no","yes")), 
         Psyf = factor(Psychiatrist, labels= c("no","yes"))) 

# Delete wrong datatype variables
dataTN <- dataTN %>%
  select(-Sex, -Education_3levels, 
         -Neurologist, -Psychiatrist, -BRIEF_total, 
         -DASS_total, -SVK_Total)

# Save dataset
save(dataTN, file = "dataTN.Rdata")
rm(data_total,df)


# Download Wilcox's functions from: https://rdrr.io/rforge/WRS/man/out.html
source(file.choose())

# Check for outliers according to wilcox
out(dataTN$Age)      
out(dataTN$BRIEF)       
out(dataTN$DASS)      
out(dataTN$SVK)     

# Check for NA
sum(is.na(dataTN$Age)) 
sum(is.na(dataTN$Sex_num))  
sum(is.na(dataTN$Edu_num))               
sum(is.na(dataTN$Neu_num))      
sum(is.na(dataTN$Psy_num)) 
sum(is.na(dataTN$BRIEF))       
sum(is.na(dataTN$DASS))       
sum(is.na(dataTN$SVK))   
mean(is.na(dataTN$Age)) 
mean(is.na(dataTN$Sex_num)) 
mean(is.na(dataTN$Edu_num)) 
mean(is.na(dataTN$Neu_num)) 
mean(is.na(dataTN$Psy_num)) 
mean(is.na(dataTN$BRIEF))  
mean(is.na(dataTN$DASS))   
mean(is.na(dataTN$SVK))    

# Are NA correlated with a control variable?
# Create a variable indicating NA or not
dataTN <- dataTN %>%
  mutate(na_Edu = as.numeric(is.na(Edu_num)), 
         na_BRIEF = as.numeric(is.na(BRIEF)),na_DASS = as.numeric(is.na(DASS))) 

# Check pattern of NA regarding control variable
# First check visually
ggboxplot(dataTN, x = "na_BRIEF", y = "Age", 
          color = "na_BRIEF", palette = c("#00AFBB", "#E7B800"),
          ylab = "Age", xlab = "NA")
ggboxplot(dataTN, x = "na_DASS", y = "Age", 
          color = "na_DASS", palette = c("#00AFBB", "#E7B800"),
          ylab = "Age", xlab = "NA")
agewtest <- wilcox.test(Age ~ na_DASS, data = dataTN,
                        exact = FALSE)
wilcoxonR(x = dataTN$Age, g= dataTN$na_DASS,ci=TRUE,conf=0.95,type='perc')

# Look at frequencies and conduct Chi-square test 
freqnaBRIEFsex <- dataTN %>%
  select(na_BRIEF,Sexf) %>%    
  count(na_BRIEF, Sexf) %>%
  spread(Sexf,n) 

freqnaDASSsex <- dataTN %>%
  select(na_DASS, Sexf) %>%    
  count(na_DASS, Sexf) %>%
  spread(Sexf,n)

freqnaBRIEFedu <- dataTN %>%
  select(na_BRIEF, Eduf) %>%    
  count(na_BRIEF, Eduf) %>%
  spread(Eduf,n)
Briefedu <- freqnaBRIEFedu [,c(2:4)] 

freqnaDASSedu <- dataTN %>%
  select(na_DASS,Eduf) %>%  
  count(na_DASS, Eduf) %>%
  spread(Eduf,n)
Dassedu <- freqnaDASSedu[,c(2:4)]

BRIEFneu <- dataTN %>%
  select(na_BRIEF,Neuf) %>%    
  count(na_BRIEF, Neuf) %>%
  spread(Neuf,n)
Briefneu <- BRIEFneu[,c(2,3)]

DASSneu <- dataTN %>%
  select(na_DASS, Neuf) %>%       
  count(na_DASS, Neuf) %>%
  spread(Neuf,n)
Dassneu <- DASSneu[,c(2,3)]

BRIEFpsy <- dataTN %>%
  select(na_BRIEF,Psyf) %>%    
  count(na_BRIEF, Psyf) %>%
  spread(Psyf,n)
Briefpsy <- BRIEFpsy[,c(2,3)]

DASSpsy <- dataTN %>%
  select(na_DASS, Psyf) %>%       
  count(na_DASS, Psyf) %>%
  spread(Psyf,n)
Dasspsy <- DASSpsy[,c(2,3)]

# Conduct Chi-square tests  
# H0 the categorical variable and the missingness indicator are not significantly correlated with each other
# HA the categorical variable and the missingness indicator are significantly correlated with each other
chi1 <- chisq.test(Briefedu)    
print(chi1)
chi2 <- chisq.test(Dassedu)     
print(chi2)
chi3 <- chisq.test(Briefneu)          
print(chi3)
chi4 <- chisq.test(Dassneu)         
print(chi4)
chi5 <- chisq.test(Briefpsy)         
print(chi5)
chi6 <- chisq.test(Dasspsy)          
print(chi6)

# Correlate with NA
NADASSBRIEF <- dataTN %>%
  select(na_BRIEF,na_DASS) %>%    
  count(na_BRIEF, na_DASS) %>% 
  spread(na_BRIEF,n, fill = 0)
NADassBrief <- NADASSBRIEF[,c(2,3)]

# Conduct Chi-square test
chi7 <- chisq.test(NADassBrief)          
print(chi7)

# Calculate effect size for test
wsqr = Xsqr/N
w = sqrt(333.79/400)
pie(table(dataTN$na_BRIEF))
pie(table(dataTN$na_Edu))
pie(table(dataTN$na_DASS))
