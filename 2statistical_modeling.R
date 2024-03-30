# ---------------------------------------------------------------------------------
#Project for Applied Statistics Course
# Author: Theodor Nowicki
# Finish date: 5.04.2022
# Script: Statistical Modeling
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


# Diagnostics for multiple regression model
# Check homoscedasticity
model1 <- lm(DASS~BRIEF+ SVK+BRIEF*SVK+Sex_num+Edu_num+Neu_num+Psy_num+Age,dataTN)
summary(model1)
yhat<-fitted(model1)
res1<-resid(model1)
plot(yhat,res1,main="predicted vs. residual")
abline(0,0)

# Check multicolliniearity
vif(model1)

# Retry model with centered predictors

# Center predictors
dataTN$cBRIEF<- scale(dataTN$BRIEF,scale = FALSE)
dataTN$cSVK<- scale(dataTN$SVK,scale = FALSE)
dataTN$cINTERACTION <- dataTN$cSVK*dataTN$cBRIEF


model2 <- lm(DASS~cBRIEF+ cSVK+cINTERACTION+Sex_num+Edu_num+Neu_num+Psy_num+Age, dataTN)
summary(model2)
vif(model2)

# Check linearity
crPlots(model1)
crPlots(model2)

# Check influential observations
summary(influence.measures(model2))

# Check normality of residuals
ress<-rstandard(model1)            
hist(ress,main="Histogram")
qqnorm(ress)
qqline(ress, col= 'red')

ress<-rstandard(model2)   
hist(ress,main="Histogram")
qqnorm(ress)
qqline(ress, col= 'red')


# Conduct Logistic regression analysis due to violations of Linearity, Normality and Homoscedasticity

# Transform DASS into dichotomous variable and perform logistic regression
dataTN$dass <- cut(dataTN$DASS,breaks= c(0,3,55), include.lowest = TRUE, labels = c('low','high'))
table(dataTN$dass)

# Check assumptions for logistic regression
logmodel <- glm(dass~BRIEF+ SVK+BRIEF*SVK +Sex_num+Edu_num+Neu_num+Psy_num+ Age,data =dataTN,family = binomial)
summary(logmodel)

# Check multicollinearity 
vif(logmodel)

# Use centered predictors
clogmodel <- glm(dass~cBRIEF+ cSVK+ cINTERACTION+Sex_num+Edu_num+Neu_num+Psy_num+ Age,data =dataTN,family = binomial)
summary(clogmodel)
vif(clogmodel) 

# Check linearity
dataTN <- dataTN %>%
  mutate(interaction = BRIEF*SVK)

logmodel <- glm(dass~BRIEF+ SVK+interaction +Sex_num+Edu_num+Neu_num+Psy_num+ Age,data =dataTN,family = binomial, na.action = na.exclude)
summary(logmodel)

# Create component + residual plot
dataTN %>%
  mutate(comp_res = coef(logmodel)["BRIEF"]*BRIEF + residuals(logmodel, type = "working")) |> 
  ggplot(aes(x = BRIEF, y = comp_res)) +
  geom_point() +
  geom_smooth(color = "red", method = "lm", linetype = 2, se = F) +
  geom_smooth(se = F)+
  labs(y= "Component plus residual", x = "BRIEF")


dataTN %>%
  mutate(comp_res = coef(logmodel)["SVK"]*SVK + residuals(logmodel, type = "working")) |> 
  ggplot(aes(x = SVK, y = comp_res)) +
  geom_point() +
  geom_smooth(color = "red", method = "lm", linetype = 2, se = F) +
  geom_smooth(se = F) +
  labs(y= "Component plus residual", x = "SVC")


dataTN %>%
  mutate(comp_res = coef(logmodel)["interaction"]*(interaction) + residuals(logmodel, type = "working")) |> 
  ggplot(aes(x = interaction, y = comp_res)) +
  geom_point() +
  geom_smooth(color = "red", method = "lm", linetype = 2, se = F) +
  geom_smooth(se = F)+
  labs(y= "Component plus residual", x = "Interaction")

dataTN %>% 
  mutate(comp_res = coef(logmodel)["Age"]*Age + residuals(logmodel, type = "working")) |> 
  ggplot(aes(x = Age, y = comp_res)) +
  geom_point() +
  geom_smooth(color = "red", method = "lm", linetype = 2, se = F) +
  geom_smooth(se = F)+
  labs(y= "Component plus residual", x = "Age")


# Check influential observations
summary(influence.measures(clogmodel))

# Check whether different DASS split makes a difference in analysis

# Transform DASS into dichotomous variable and perform logistic regression
dataTN$dass <- cut(dataTN$DASS,breaks= c(0,0.5,55), include.lowest = TRUE, labels = c('low','high'))
table(dataTN$dass)
clogmodel2 <- glm(dass~cBRIEF+ cSVK+ cINTERACTION+Sex_num+Edu_num+Neu_num+Psy_num+ Age,data =dataTN,family = binomial)
summary(clogmodel2)


# Calculate effect size and CI
clogmodel <- glm(dass~cBRIEF+ cSVK+ cINTERACTION+Sex_num+Edu_num+Neu_num+Psy_num+ Age,data =dataTN,family = binomial)
summary(clogmodel)

# 95% CI for coefficient
exp(cbind(coef(clogmodel),confint(clogmodel)))
exp(0.069370 + 2 * 0.010890)

# Transform to log odds
oddsratio<-exp(cbind("Odds ratio" = coef(clogmodel), confint.default(clogmodel, level = 0.95)))
round(oddsratio,digits=3)

# Calculate to odds ratio
oddsratio1<-exp(cbind("Odds ratio" = coef(clogmodel)))
round(oddsratio1,digits=3)

# Correlation matrix
cordata <- dataTN %>%
  select(BRIEF, SVK, DASS, Age)
cor(cordata, use = 'complete.obs')

# Calculate sensitivity of analysis
pwr.f2.test(u = 8, v = 326, sig.level = .05, power = .8 )

