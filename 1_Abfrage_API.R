library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(stringr)


## Set working directory ####
setwd("ENTER_WOKRING_DIRECTORY")
getwd()


## get all businesses in legislative period 49 or 50 ####
legislative_period <- 49 # choose legislative period

url_vote <- str_c("https://ws.parlament.ch/odata.svc/Vote?$top=10000&$filter=Language%20eq%20'DE'%20and%20IdLegislativePeriod%20eq%20", legislative_period, "&$format=json")
r <- GET(url_vote)
r$status_code
temp_a <- jsonlite::fromJSON(content(r, "text"))
df_Ids <- as.data.frame(temp_a$d)
df_Ids_lean <- df_Ids[, c("ID", "RegistrationNumber", "BusinessTitle", "IdLegislativePeriod", "IdSession", "Subject", "SessionName")]

# store ids
#write.csv(df_Ids_lean, "Data_output/voteIds.csv")


## get all votes ####
df_votes <- data.frame()
i <- 1
# This loop takes about 1 hour to complete
for (IdVote in df_Ids_lean$ID){
  print(i)
  print(IdVote)
  
  url <- str_c("https://ws.parlament.ch/odata.svc/Voting?$top=10000&$filter=Language%20eq%20'DE'%20and%20IdVote%20eq%20", IdVote, "&$format=json")
  
  r <- GET(url)
  r$status_code
  
  a <- jsonlite::fromJSON(content(r, "text"))
  temp <- a$d
  df_temp <- as.data.frame(temp)
  df_votes_temp <- df_temp[, c("IdVote", "ID", "RegistrationNumber", "PersonNumber", "FirstName", "LastName", "ParlGroupName", "DecisionText", "BusinessTitle", "IdLegislativePeriod", "IdSession", "Subject")]
  
  df_votes <- rbind(df_votes, df_votes_temp)
  i <- i+1
}
rm(df_votes_temp)

# add full name as identifier --> Carefull, Daniel Frei changed party, add better identifier later
df_votes$Name <- str_c(df_votes$FirstName, " ", df_votes$LastName)

# store votes
#write.csv(df_votes, "Data_output/votes_50.csv")




