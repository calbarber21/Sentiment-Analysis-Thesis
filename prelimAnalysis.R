library(readxl)
library(dplyr)
library(tidyverse)
setwd("~/Thesis ")
#read in results produced by python file
fileName <- "initialResults (2).xlsx"
initialResults_2 <- read_excel(fileName, col_types = c("date", "numeric"))
#Read in Michigan consumer sentiment survey 
fileTwo <- "UMCSENT.csv"
consumerSentiment <- read_csv(fileTwo)
consumerSentiment$DATE <- as.Date(consumerSentiment$DATE , format = "%y/%m/%d")
consumerSentiment$UMCSENT <- as.numeric(consumerSentiment$UMCSENT)
#remove rows corresponding to dates that we do not have news sentiemnt for 
consumerSentiment<-consumerSentiment[-c(1:707),]
#Ensure that Date column is of type date
initialResults_2$Date <- as.Date(initialResults_2$Date , format = "%d/%m/%y")
initialResults_2 <- initialResults_2 %>% mutate(month = format(Date, "%m"), year = format(Date, "%Y")) 
#Group articles by day and month and determine the average score on that day or month.
averageResults <- initialResults_2 %>% filter(!is.na(Date)) %>% group_by(Date,month,year) %>% summarise(Average = mean(`Average Score`,na.rm = TRUE),'Number of Articles' = n())
averageResultsMonthly <- initialResults_2 %>% filter(!is.na(Date)) %>% group_by(month,year) %>% summarise(AverageMonthly = mean(`Average Score`,na.rm = TRUE),'Number of Articles' = n())
#Here we are normalizing the news sentiment scores. We determine the mean and standard deviation of all scores on a daily
#and monthly basis so each article can recieve a Z score
averageScoreDaily <- mean(averageResults$Average, na.rm = TRUE)
sdScoreDaily <- sd(averageResults$Average, na.rm = TRUE)
averageScoreMonthly<- mean(averageResultsMonthly$AverageMonthly, na.rm = TRUE)
sdScoreMonthly <- sd(averageResultsMonthly$AverageMonthly, na.rm = TRUE)
averageScoreConsumer <- mean(consumerSentiment$UMCSENT,na.rm = TRUE)
sdScoreConsumer <- sd(consumerSentiment$UMCSENT,na.rm = TRUE)
#Create a z score column. Daily scores are conpared to daily average and SD, monthly scores are conpared to monthly values
averageResults <- averageResults %>% mutate(normalizedScore = (Average - averageScoreDaily) / sdScoreDaily)
monthlyResults <- averageResultsMonthly %>%  mutate(normalizedScoreMonthly = (AverageMonthly - averageScoreMonthly) / sdScoreMonthly) %>% arrange(year,month)
consumerSentiment <- consumerSentiment %>% mutate(normalizedConsumerScore = (UMCSENT - averageScoreConsumer)/sdScoreConsumer)
#Give monthly values a date time column for ease of plotting
df <- data.frame(date = seq.Date(from =as.Date("01/10/2011", "%d/%m/%Y"), to=as.Date("01/09/2020", "%d/%m/%Y"), by="month"))
monthlyResults <- cbind.fill(monthlyResults,df,consumerSentiment$normalizedConsumerScore,fill = NA)
#Plot average daily results including the volume of articles read included as a bar graph, and consumer sentiemnt as an orange line
ggplot(averageResults)  + 
  geom_line(aes(x = Date, y = normalizedScore *max(averageResults$`Number of Articles`)), stat = 'identity') +
  labs(x="Date",y="Number of Articles (Red)") +
  geom_bar(aes(x = Date, y = `Number of Articles` ),stat = 'identity', fill = "brown") +
  scale_y_continuous(sec.axis = sec_axis(~./max(averageResults$`Number of Articles`),name = "Sentiment Z Score (Black)")) +
  ggtitle("Daily News Sentiment Score and number of Articles ") +
  theme_classic()

#Plot average monthly results including the volume of articles read included as a bar graph
ggplot(NULL)  + 
  geom_bar(data = monthlyResults,aes(x = date, y = `Number of Articles` ),stat = 'identity', fill = "brown") +
  labs(x="Date",y="Number of Articles (Red)") +
  geom_line(data = monthlyResults,aes(x = date, y = normalizedScoreMonthly *max(monthlyResults$`Number of Articles`)), stat = 'identity') +
  geom_line(data = consumerSentiment, aes(x = DATE, y = normalizedConsumerScore *max(monthlyResults$`Number of Articles`)),stat = 'identity', color = "orange") +
  scale_y_continuous(sec.axis = sec_axis(~./max(monthlyResults$`Number of Articles`),name = "Sentiment Z Score (Black)")) +
  ggtitle("Monthly News Sentiment Score and number of Articles ") +
  theme_classic()





