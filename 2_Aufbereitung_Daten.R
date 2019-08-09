library(plyr)
library(dplyr)
library(tidyr)
library(stringr)
library(plotly)


## Set working directory ####
setwd("ENTER_WOKRING_DIRECTORY")
getwd()


## Read data ####
df_votes_input <- read.csv("Data_output/votes_50.csv")
df_votes_input$Name <- str_c(df_votes_input$FirstName, " ", df_votes_input$LastName)

# Identifikator einführen, weil Daniel Frei die Partei gewechselt hat!
df_votes_input$ident <- str_c(df_votes_input$FirstName, " ", df_votes_input$LastName, "_", df_votes_input$ParlGroupName)


## Select if all data or only "Schlussabstimmungen" should be analysed: ####
# skip if all data is used
index_gesamtantrag <- (df_votes_input[, "Subject"] == "Schlussabstimmung") | 
  (df_votes_input[, "Subject"] == "Gesamtabstimmung") |
  (df_votes_input[, "Subject"] == "Votazione sul complesso") |
  (df_votes_input[, "Subject"] == "Votazione finale") |
  (df_votes_input[, "Subject"] == "Vote final") |
  (df_votes_input[, "Subject"] == "Vote sur l'ensemble")

# make sure NAs are also not regarded
index_gesamtantrag[is.na(index_gesamtantrag)] <- FALSE

# only consider Schlussabstimmung
df_votes <- df_votes_input[index_gesamtantrag, ]

# or consider everything:
df_votes <- df_votes_input


## Prepare data ####

# create lookup for party
dfx_lkp <- unique(df_votes[, c("ident", "Name", "PersonNumber", "ParlGroupName")])

df_long <- df_votes[, c("IdVote", "DecisionText", "ident")]

# change to wide table
df_wide <- spread(df_long, ident, DecisionText)

# dataframe with pure vote-data, no metainfo
df_votesRaw <- df_wide[, 2:length(df_wide)]

# dataframe with info about votes, start with filling in the names of the votes
df_IdVote <- as.data.frame(df_wide[, 1])
colnames(df_IdVote)[1] <- "IdVote"
df_IdVote <- join(df_IdVote, df_votes[, c("IdVote", "RegistrationNumber", "BusinessTitle", "Subject", "IdSession")], by = "IdVote", match = "first")


## Analyse votes ####

# get number of "valid" votes (--> Anzahl abgegebener Stimmen. Abwesend und Enthaltung nicht berücksichtigt)
df_valid <- as.data.frame(df_votesRaw == "Ja" | df_votesRaw == "Nein")

# wie häufig waren die Parlamentarier anwesend? (wichtig um geschlossenheit der Fraktion zu berechnen später)
df_anwesend <- as.data.frame(df_votesRaw == "Ja" | df_votesRaw == "Nein" | df_votesRaw == "Enthaltung")

# store number of valid votes in df for final results
df_IdVote$NrValid <- apply(df_valid, 1, sum,na.rm=TRUE)

# Wie oft wurde "Ja" gestimmt für etwas?
df_Yes <- as.data.frame(df_votesRaw == "Ja")
df_IdVote$Yes <- apply(df_Yes, 1, sum,na.rm=TRUE)

# Verhältniss von "Ja" Stimmen zur Anzahl abgegebender Stimmen
df_IdVote$Result_share_yes <- df_IdVote$Yes / df_IdVote$NrValid
df_IdVote$Result <- df_IdVote$Result_share_yes>0.5

# Ja/Nein Ergebniss für jede Abstimmung
df_IdVote$Result[df_IdVote$Result == TRUE] <- "Ja"
df_IdVote$Result[df_IdVote$Result == FALSE] <- "Nein"


## Parlamentarierbetrachtung ####
# Wie oft hatten die Parlamentarier "recht" (--> mit Enthaltung hat man nie Recht)
df_Success <- as.data.frame(df_votesRaw == df_IdVote$Result)

# Wie viele Enthaltungen?
df_Enthaltung <- as.data.frame(df_votesRaw == "Enthaltung")

# Create dataframe to store all the results per parliamentarian
dfx_mps <- data.frame(apply(df_Success, 2, sum,na.rm=TRUE)) # How often is Yes|No correct?
colnames(dfx_mps)[1] <- "Successes"

# wie häufig anwesen?
dfx_mps$anwesend <- apply(df_anwesend, 2, sum,na.rm=TRUE) # Ja|Nein|Enthaltung

# Wie viele valide Stimmen abgegeben? (Ja/Nein)
dfx_mps$valid <- apply(df_valid, 2, sum,na.rm=TRUE) # Ja|Nein

# Wie häufig enthalten?
dfx_mps$enthaltung <- apply(df_Enthaltung, 2, sum,na.rm=TRUE) # Enthaltung

# In wie vielen fällen mit der Mehrheit übereinstimmend?
dfx_mps$Sucess_share <- dfx_mps$Successes / dfx_mps$anwesend
dfx_mps$Sucess_share[dfx_mps$anwesend == 0] <- 0 # div0 durch 0 ersetzen

# Informationen über Partei aus der Lookuptable hinzufügen
dfx_mps$ident <- rownames(dfx_mps)
dfx_mps <- merge(dfx_mps, dfx_lkp, by = "ident")

# File exportieren
#write.csv(dfx_mps, "Data_output/Ranking_leg49_alleAbstimmungen.csv")


## Abstimmungsbetrachtung für Koalitionsanalyse ####

# create lookup for businesses
dfy_lkp <- data.frame((colnames(df_votesRaw)))
colnames(dfy_lkp)[1] <- "ident"

dfy_lkp <- join(dfy_lkp, df_votes[, c("ident", "Name", "PersonNumber", "ParlGroupName")], by="ident", type="left", match="first")

# Parteien Dataframe erstellen um zu überprüfen zu welcher Partei jemand gehört
# achtung, CVP Fraktion Name ändert Namen zwischen 49 und 50 Legislatur! Anpassen bei Bedarf
dfy_party <- as.data.frame(t(dfy_lkp)) 

unique(df_votes$ParlGroupName)

#erstellen von dataframes welche nur die Stimmen der jeweiligen Parteien beinhalten

index_svp <- dfy_party["ParlGroupName", ] == "Fraktion der Schweizerischen Volkspartei"
dfz_svp <- df_votesRaw[, index_svp]
dfz_svp_valid <- df_anwesend[, index_svp]

index_sp <- dfy_party["ParlGroupName", ] == "Sozialdemokratische Fraktion"
dfz_sp <- df_votesRaw[, index_sp]
dfz_sp_valid <- df_anwesend[, index_sp]

index_cvp <- dfy_party["ParlGroupName", ] == "CVP-Fraktion"
dfz_cvp <- df_votesRaw[, index_cvp]
dfz_cvp_valid <- df_anwesend[, index_cvp]

index_fdp <- dfy_party["ParlGroupName", ] == "FDP-Liberale Fraktion"
dfz_fdp <- df_votesRaw[, index_fdp]
dfz_fdp_valid <- df_anwesend[, index_fdp]

index_gruene <- dfy_party["ParlGroupName", ] == "Grüne Fraktion"
dfz_gruene <- df_votesRaw[, index_gruene]
dfz_gruene_valid <- df_anwesend[, index_gruene]

# für jede Pareil aufsummieren, wie häufig sie Ja gestimmt hat für eine Vorlage
df_IdVote$ja_svp <- apply(dfz_svp == "Ja", 1, sum, na.rm=TRUE)
df_IdVote$ja_fdp <- apply(dfz_fdp == "Ja", 1, sum, na.rm=TRUE) 
df_IdVote$ja_cvp <- apply(dfz_cvp == "Ja", 1, sum, na.rm=TRUE) 
df_IdVote$ja_sp <- apply(dfz_sp == "Ja", 1, sum, na.rm=TRUE) 
df_IdVote$ja_gruene <- apply(dfz_gruene == "Ja", 1, sum, na.rm=TRUE) 

# für jede Partei aufsummieren, wie viele Parlamentarier bei einer Vorlage anwesend waren
df_IdVote$valid_svp <- apply(dfz_svp_valid == TRUE, 1, sum, na.rm=TRUE)
df_IdVote$valid_fdp <- apply(dfz_fdp_valid == TRUE, 1, sum, na.rm=TRUE) 
df_IdVote$valid_cvp <- apply(dfz_cvp_valid == TRUE, 1, sum, na.rm=TRUE) 
df_IdVote$valid_sp <- apply(dfz_sp_valid == TRUE, 1, sum, na.rm=TRUE) 
df_IdVote$valid_gruene <- apply(dfz_gruene_valid == TRUE, 1, sum, na.rm=TRUE) 

# für jede Partei bestimmen, wie viele der anwsenden Parlamentarier für eine Vorlage gestimmt haben
df_IdVote$ja_share_svp <- df_IdVote$ja_svp / df_IdVote$valid_svp
df_IdVote$ja_share_fdp <- df_IdVote$ja_fdp / df_IdVote$valid_fdp
df_IdVote$ja_share_cvp <- df_IdVote$ja_cvp / df_IdVote$valid_cvp
df_IdVote$ja_share_sp <- df_IdVote$ja_sp / df_IdVote$valid_sp
df_IdVote$ja_share_gruene <- df_IdVote$ja_gruene / df_IdVote$valid_gruene

# export results
#write.csv(df_IdVote, "Data_output/Koalitionen_leg50_nurGesamtabstimmungen.csv")
