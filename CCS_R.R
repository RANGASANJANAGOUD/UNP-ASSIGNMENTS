
df <- read.csv("C:\\Users\\user\\Downloads\\Concrete_Data (1).csv")

library(dplyr)
library(PerformanceAnalytics)
install.packages("performanceAnalytics")
library(ggplot2)
install.packages(chart.Correlation)
library(corrplot)
install.packages(corrplot)
library(RColorBrewer)
library(ggthemes)
library(caret)
library(caretEnsemble)
library(doParallel)
library(dslabs)
library(tidyverse)
library(lubridate)
install.packages("Metrics") 
library(Metrics)
install.packages("MLmetrics")
library(MLmetrics)

# EDA
summary(df)
corrplot(cor(df), method = "number",tl.cex = 0.5)
chart.Correlation(df)
anyNA(df)
sapply(df, {function(x) any(is.na(x))})
boxplot(df[-9], col = "orange", main = "Features Boxplot")
age_outliers <- which(df$Age > 100)
df[age_outliers, "Age"]


#train and test data
#model 1

set.seed(5)  # setting seed to reproduce results of random sampling
testData<- sample(nrow(df),200)  # row indices for training data
lm_fit <- lm(strength ~ Cement+Water+Age+Coarse.Aggregate+Fly.Ash+Fine.Aggregate+Superplasticizer+Blast.Furnace.Slag ,
             data = df, subset = -testData)
summary(lm_fit)
pred <- predict(lm_fit, df[testData,])
pred
summary(pred)
#mean square error
mean((df[testData,]$strength-pred)^2)
#correlation between original and prediction values
cor(df[testData,]$strength,predict(lm_fit,df[testData,]))
data_mod <- data.frame(Predicted = predict(lm_fit,df[testData,]),  
                       Observed = df[testData,]$strength)
ggplot(data_mod,aes(x = Predicted, y = Observed)) +geom_point() +geom_abline(intercept = 0, color = "red",size = 2)
rmse( df[testData,]$strength, predict(lm_fit,df[testData,]))
MAPE( df[testData,]$strength, predict(lm_fit,df[testData,]))

#model 2

set.seed(5)  # setting seed to reproduce results of random sampling
testData1<- sample(nrow(df),200)  # row indices for training data
lm_fit2 <- lm(strength ~ Cement+Water+Age+Coarse.Aggregate+Fine.Aggregate+Superplasticizer+Blast.Furnace.Slag ,
              data = df, subset = -testData)
summary(lm_fit2)
pred1 <- predict(lm_fit2, df[testData1,])
pred1
summary(pred1)
#mean square error
mean((df[testData1,]$strength-pred1)^2)
#correlation between original and prediction values
cor(df[testData1,]$strength,predict(lm_fit2,df[testData1,]))

data_mod1 <- data.frame(Predicted = predict(lm_fit2,df[testData1,]),  
                        Observed = df[testData1,]$strength)
ggplot(data_mod1,aes(x = Predicted, y = Observed)) +geom_point() +geom_abline(intercept = 0, slope = 1, color = "red",size = 2)
rmse( df[testData1,]$strength, predict(lm_fit2,df[testData1,]))
MAPE( df[testData1,]$strength, predict(lm_fit2,df[testData1,]))
