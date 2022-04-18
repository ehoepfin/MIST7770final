#install packages
install.packages("caret")
install.packages("tidyverse") 
install.packages("cluster")
install.packages("factoextra")

#loading librarys
library(tidyverse)
library(cluster)
library(factoextra)
library(caret)



#dataset adding genre categorization
spotify_charts <- read_csv("spotify_dataset_clean.csv")

#Convert Week of highest rating to month
spotify_charts <- spotify_charts %>%
  rename("Month" = "Week of Highest Charting")

#triming chart date to month of charting
spotify_charts$"Month" <- 
  substr(spotify_charts$"Month", 6, 7)

#Trimming leading 0's on month
spotify_charts <- spotify_charts %>%
  mutate(Month = case_when(
    Month == "01" ~ 1,
    Month == "02" ~ 2,
    Month == "03" ~ 3,
    Month == "04" ~ 4,
    Month == "05" ~ 5,
    Month == "06" ~ 6,
    Month == "07" ~ 7,
    Month == "08" ~ 8,
    Month == "09" ~ 9,
    Month == "10" ~ 10,
    Month == "11" ~ 11,
    Month == "12" ~ 12
  ))

#Creating the seasons based on the month
spotify_charts <- spotify_charts %>%
  mutate(season = case_when(
    Month >= 3 & Month <= 5 ~ "Spring", 
    Month >= 6 & Month <= 8 ~ "Summer", 
    Month >= 9 & Month <= 11 ~ "Fall", 
    Month >= 1 & Month <= 2 ~ "Winter",
    Month == 12 ~ "Winter"
  ))

#Converting seasons to nominal variables
spotify_charts <- spotify_charts %>%
  mutate(seasonN = case_when(
    season == "Spring" ~ 1,
    season == "Summer" ~ 2,
    season == "Winter" ~ 3,
    season == "Fall" ~ 4
  ))

#Nominalizing Genre Data
# spotify_charts <- spotify_charts %>%
#   mutate(Genre = case_when(
#     Genre == "alternative" ~ 1,
#     Genre == "comedy" ~ 2,
#     Genre == "country" ~ 3,
#     Genre == "dance" ~ 4,
#     Genre == "disco" ~ 5,
#     Genre == "electronic" ~ 6,
#     Genre == "eurovision" ~ 7,
#     Genre == "francoton" ~ 8,
#     Genre == "hip hop" ~ 9,
#     Genre == "holiday" ~ 10,
#     Genre == "indie rock" ~ 11,
#     Genre == "k-pop" ~ 12,
#     Genre == "latin" ~ 13,
#     Genre == "pop" ~ 14,
#     Genre == "r&b" ~ 15,
#     Genre == "rap" ~ 16,
#     Genre == "reggae" ~ 17,
#     Genre == "rock" ~ 18,
#     Genre == "weirdcore" ~ 19
#     
#   ))

#setting seed for reproducibility
set.seed(12L)

#dropping N/A Values
spotify_charts_clean <- drop_na(spotify_charts)

#partitioning data
trainIndex <- createDataPartition(spotify_charts_clean$Month,
                                  p = 0.8, 
                                  list = FALSE, 
                                  times = 1)

#create dataset based on partition
trainData <- spotify_charts_clean[trainIndex,]
testData <- spotify_charts_clean[-trainIndex,]


#build training model
model <- train(Month ~ Danceability + Energy + Loudness + Tempo +
                 Valence + Acousticness + Liveness + seasonN,
               data = trainData, 
               na.action=na.exclude,
               method="lm")

#model summary
summary(model)

#Predicting data
prediction <- predict(model, testData)

#Evaluate model performance
postResample(pred = prediction, obs = testData$Month)
