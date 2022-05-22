getwd()
setwd("/Users/robertmoncrief/Desktop/Twitter Data 2020/x2go/05-2020")
library(stringi)
library(readr)
library(stringr)
library(cld2)
library(dplyr)
library(tm)


# cleaning out environment
rm(list = ls())
# setting files to temp folder to be read into R
temp = list.files(path = "03-2020", pattern = "*.csv", full.names = TRUE)
temp = temp[file.size(temp) > 150]

# read csv files
CSV_data <- read_csv(temp, col_select = c("user_id_str", "text", "retweeted_status_lang"), show_col_types = FALSE)
CSV_data <- read.csv("2020-05-23-17.csv")
# Create data frame and take out languages that arent english.
CSV_data <- data.frame(CSV_data)

CSV_data <- subset(CSV_data, detect_language(CSV_data$text) == "en")
CSV_data <- subset (CSV_data, CSV_data$retweeted_status_lang == "en")#Gets rid of everything except english
CSV_data$text <- str_to_lower(CSV_data$text)

stopwords = c("covid19", "COVID19", "Corona", "corona", "Coronavirus", "coronavirus", "CORONAVIRUS", "COVID-19", "Covid-19", "COVID19.", "COVID_19", "COVID__19",
              "covid19", "COVID19,", "COVID19:", "CoronaVirus", "COVID", "coronavirus,", "COVID19...", "Covid19", "Covid_19", "covid_19", "COV...",
              "pandemic,", "COVID-19", "covid19nigeria", "coronavirusupdate", "covid_...", "coivd19.", "coronavi...", "virus", "virus-related", "covi", "Coronavirususa",
              "covid19on", "cirus", "cov", "covidー19", "covid", "coro", "covid1", "covi", "coronavi", "coronavir", "covid2019", "coronav", "cor", "coron", "coronaviru", 
              "coronavirusupdates", "coronaoutbreak", "covid19outbreak", "coronavirusoutbrea", "coronavirusp", "ital", "ice", "wuh", "coronaviruspandem", "coronavirusu", 
              "coronaviruspandemic", "coronavirusoutbreak", "coronaupdate", "coronacrisis", "coronaviruslockdown", "staya", "tru", "lot", "art", "chi", "and", "loc", "chin")



CSV_data$text <- removeWords(CSV_data$text, words = stopwords)
# Extracts hashtags from text 
hashtags1 <- str_extract_all(CSV_data$text, "#\\S+")
hashtags1 <- str_extract_all(hashtags1, '\\w{3,}')
hashtags1 <- unlist(hashtags1)
hashtags1

# delete all punctuation
hashtags <- gsub("[[:punct:]]+", " ", hashtags1)
hashtags <- gsub("character", "", as.character(hashtags))
hashtags <- str_extract_all(hashtags, '\\w{3,}')
hashtags <- unlist(hashtags)
hashtags
#This makes hashtags into a viewable table by decreasing order 
Hcount <- table(hashtags)
Hcount <- sort(Hcount, decreasing = TRUE)
Hcount

#This counts unique users
UniqueUsers <- count(CSV_data, user_id_str)
nrow(UniqueUsers)
duplicated(UniqueUsers) #checks to see if there is any duplicated users

#Top 300 most frequent hashtags / unique users
b <- Hcount[1:1001] / nrow(UniqueUsers)
b <- sort(b, decreasing = TRUE)
#Final Data frame
March2 <- data.frame(b)
March2$Count <- Hcount[1:1001]
March2$hashtags <- str_to_title(March2$hashtags)

