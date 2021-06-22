setwd("/Users/wanghanlin/Desktop/final project")
get.data.overall <- function(AREA_TYPE = c("overview", "nation"), AREA_NAME) {
  # import packages
  library(dplyr)
  library(epidemia)
  library(rstanarm)
  library(httr)
  library(jsonlite)
  library(Hmisc)
  library(knitr)
  library(lubridate)
  library(ggplot2)
  library(tidyverse)
  
  # temperature might have impact on the R_t, hence I download the  temperature data from 'https://www.wunderground.com/history/monthly/gb/london/EGLW/date/2020-5' as a csv data, and then read into R
  # the temperature data is the monthly data
  temperature <- read.csv("./data/temperature.csv")
  temperature$date <- as.Date(temperature$date)
  
  # This is the Google trend data downloaded from Google
  protest <- read.csv("./data/protest.csv")
  protest$week <- as.Date(protest$week)
  
  # create a list from "2020-01-01" to today
  temp <- seq.Date(
    from = as.Date(
      "2020/01/01",format = "%Y/%m/%d"
    ), by = "day",
    length.out = as.numeric(
      difftime(Sys.Date(), "2020-01-01")
    )
  )
  temp <- data.frame(date <- temp)
  colnames(temp) <- c("date")
  colnames(protest) <- c("date", "protest")
  temp <- left_join(temp, protest, by = "date")
  temp <- left_join(temp, temperature, by = "date")
  
  # initial  variables
  protest.former <- NA
  protest.later <- NA
  protest.date.former <- NA 
  protest.date.later <- NA 
  for (i in row.names(temp)) {
    i <- as.numeric(i)
    # impute the temperature, all months has the same temperature
    if (is.na(temp$temperature[i]) == FALSE){
      temperature.month <- temp$temperature[i]
    } else {
      temp[i, "temperature"] <- temperature.month
    }
    # impute the protest data, from weekly to daily
    if (is.na(temp$protest[i])) {
      
      for (j in (i+1:nrow(temp))) {
        if (is.na(temp$protest[j]) == FALSE) {
          protest.date.later <- temp$date[j]
          protest.later <- temp$protest[j]
          break
        }
      }
      former.time <- as.numeric(
        difftime(temp$date[i], protest.date.former)
      )
      later.time <- as.numeric(
        difftime(protest.date.later, temp$date[i])
      )
      # the weighted average
      temp[i, "protest"] <- (
        former.time * protest.later + 
          later.time * protest.former
      )/(
        former.time + later.time
      )
    } else {
      protest.date.former <- temp$date[i]
      protest.former <- temp$protest[i]
    }
  }
  # impute the protest at the first and the last
  impute.data <- NA
  for (i in row.names(temp)) {
    i <- as.numeric(i)
    if (is.na(temp$protest[i])) {
      if (is.na(impute.data)) {
        for (j in (i+1: nrow(temp))) {
          if (is.na(temp$protest[j]) == FALSE) {
            impute.data <- temp$protest[j]
            break
          }
        }
        temp[i, "protest"] <- impute.data
        impute.data <- NA
      } else {
        temp[i, "protest"] <- impute.data
      }
    } else {
      impute.data <- temp$protest[i]
    }
  }
  
  # download data from the website
  # API request
  endpoint <- "https://coronavirus.data.gov.uk/api/v1/data"
  
  # Create filters:
  if (AREA_TYPE == "overview") {
    filters <- c(
      sprintf("areaType=%s", AREA_TYPE)
    )
  } else if (AREA_TYPE == "nation") {
    filters <- c(
      sprintf("areaType=%s", AREA_TYPE),
      sprintf("areaName=%s", AREA_NAME)
    )
  } else {
    return("Area type Error")
  }

  
  # Create the structure as a list or a list of lists:
  structure <- list(
    Nation = "areaName",
    date = "date", 
    cases = "newCasesByPublishDate",
    deaths = "newDeaths28DaysByDeathDate", 
    # Patients in hospital
    hospital = "hospitalCases",
    ventilationbeds = "covidOccupiedMVBeds",
    newfirstVaccination = "newPeopleVaccinatedFirstDoseByPublishDate",
    cumfirstVaccination = "cumPeopleVaccinatedFirstDoseByPublishDate",
    newsecondVaccination = "newPeopleVaccinatedSecondDoseByPublishDate",
    cumsecondVaccination = "cumPeopleVaccinatedSecondDoseByPublishDate",
    newVirusTests = "newPillarTwoTestsByPublishDate",
    # Patients in mechanical ventilation beds
    Beds = "covidOccupiedMVBeds"
  )
  
  response <- GET(
    url = endpoint,
    query = list(
      filters = paste(filters, collapse = ";"),
      structure = jsonlite::toJSON(
        structure, auto_unbox = TRUE
      )
    ),
    content_type("application/json"),
    timeout(10)
  ) 
  
  # Handle errors:
  if (response$status_code >= 400) {
    err_msg = httr::http_status(response)
    stop(err_msg)
  }
  
  # Convert response from binary to JSON:
  json_text <- content(response, "text")
  data      <- fromJSON(json_text)$data
  data$date <- as.Date(data$date)
  rownames(data) <- data$date
  
  # UK firstly injected vaccination from 8th Dec 2020
  for (d in row.names(data)) {
    differ = as.numeric(difftime(d, '2020-12-8'))
    if (differ < 0) {
      data[
        d, c(
          "newfirstVaccination", "cumfirstVaccination",
          "newsecondVaccination", "cumsecondVaccination"
        )] <- c(0,0,0,0)
    }
  }
  
  # linear impute the vaccination injection data
  for (d in row.names(data)) {
    if (is.na(data[d, "cumfirstVaccination"])) {
      differ.all = as.numeric(difftime('2021-01-10', '2020-12-7'))
      differ = as.numeric(difftime(d, '2020-12-7'))
      cum <- data['2021-01-10', "cumfirstVaccination"] / differ.all
      data[d, "cumfirstVaccination"] <- round(cum * differ)
    }
  }
  for (d in row.names(data)) {
    if (is.na(data[d, "newfirstVaccination"])) {
      cum <- data[d, "cumfirstVaccination"]
      x <- ymd(d)
      day(x) <- day(d) - 1
      x <- as.character(x)
      data[d, "newfirstVaccination"] <- cum - data[x, "cumfirstVaccination"]
    }
  }
  for (d in row.names(data)) {
    if (is.na(data[d, "cumsecondVaccination"])) {
      if (difftime(d, '2021-01-04') > 0) {
        differ.all = as.numeric(difftime('2021-01-10', '2021-01-04'))
        differ = as.numeric(difftime(d, '2021-01-04'))
        cum <- data['2021-01-10', "cumsecondVaccination"] / differ.all
        data[d, "cumsecondVaccination"] <- round(cum * differ)
      } else {
        data[d, "cumsecondVaccination"] <- 0
      }
    }
  }
  
  for (d in row.names(data)) {
    if (is.na(data[d, "newsecondVaccination"])) {
      cum <- data[d, "cumsecondVaccination"]
      x <- ymd(d)
      day(x) <- day(d) - 1
      x <- as.character(x)
      data[
        d, "newsecondVaccination"
      ] <- cum - data[x, "cumsecondVaccination"]
    }
  }
  

  # adding the policy data 
  for (d in row.names(data)) {
    if (as.numeric(difftime(d, '2020-03-11')) > 0) {
      data[d,"self_isolating_if_ill"] <- 1
      if (as.numeric(difftime(d, '2020-03-15')) > 0) {
        data[d,"social_distancing_encouraged"] <- 1
        if (as.numeric(difftime(d, '2021-03-28')) > 0) {
          data[d,"social_distancing_encouraged"] <- 0.2
        }
        if (as.numeric(difftime(d, '2020-03-20')) > 0) {
          data[d,"schools_universities"] <- 1
          if (as.numeric(difftime(d, '2020-09-20')) > 0) {
            data[d,"schools_universities"] <- 0.7
            if (as.numeric(difftime(d, '2021-03-07')) > 0) {
              data[d,"schools_universities"] <- 0.3
            }
          }
          if (as.numeric(difftime(d, '2020-03-23')) > 0) {
            data[d,"public_events"] <- 1
            if (as.numeric(difftime(d, '2021-05-16')) > 0) {
              data[d,"public_events"] <- 0.5
            }
            data[d,"lockdown"] <- 1
          } 
        } 
      } 
    } 
  }
  
  # change the index
  data$index = c(1:nrow(data))
  data <- data[order(data$index),]
  row.names(data) <- data$index
  # impute Na with 0
  for (i in row.names(data)) {
    for (j in colnames(data)) {
      if (is.na(data[i,j])) {
        data[i,j] <- 0
      }
    }
  }
  data$index <- NULL
  data <- left_join(data, temp, by = "date")
  data <- data[-1,] # the latest daily data is problematic
}

get.data <- function(AREA_TYPE = c("overview", "nation")) {
  data <- NULL
  if (AREA_TYPE == "overview"){
    data <- get.data.overall(AREA_TYPE)
    data$pop <- 68231235
  } else if (AREA_TYPE == "nation") {
    for (
      nation in c("England", "Wales", "Scotland", "Northern Ireland")
      ) {
      data.temp <- get.data.overall(
        AREA_TYPE = "nation", AREA_NAME = nation
        )
      if (nation == "Wales") {
        data.temp$pop <- 3228120
      }
      if (nation == "Scotland") {
        data.temp$pop <- 5494000
      }
      if (nation == "England") {
        data.temp$pop <- 55892000
      }
      if (nation == "Northern Ireland") {
        data.temp$pop <- 1905484
      }
      data <- rbind(data, data.temp)
    }
  } else {
    return("Area type Error")
  }
  # the injection rate
  data$FirstVaccinationRate = data$cumfirstVaccination / data$pop
  data$SecondVaccinationRate = data$cumsecondVaccination / data$pop
  
  return(data)
}
data <- get.data("nation")

