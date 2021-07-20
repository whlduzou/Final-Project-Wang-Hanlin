#setwd("/Users/wanghanlin/Desktop/final project")

remove_reference <- function(file) {
  # the acknowledge and reference is in the bottom of the file
  # remove it because it is useless for the file
  file <- drop_na(file)
}

select.nation <- function(file, AREA_NAME) {
  file <- subset(file, Nation == AREA_NAME)
  # the AREA_NAME is known, hence the Nation list should be drop
  file <- subset(file, select = -c(Nation))
}

linear.impute <- function(file, j) {
  # first col is date, others has missing data
  # j is the index of the col, which is needed to impute
  repeat_time <- nrow(file) - sum(is.na(file[,j]))
  ini_col <- file[1,j]
  ini <- 1
  end <- 0
  for (r in 1:repeat_time) {
    for (i in (ini + 1):nrow(file)) {
      if (is.na(file[i,j]) == FALSE) {
        end_col <- file[i,j]
        end <- i-1
        break
      }
      if (i == nrow(file)) {
        end_col <- ini_col
      }
    }
    for (i in (ini+1):end) {
      file[i,j] = (end_col - ini_col)/(end+1 - ini)*(i - ini) + ini_col
    }
    ini_col  <- end_col 
    ini <- end + 1
  }
  return(file)
}

# #impute.vac <- function(data) {
#   # UK firstly injected vaccination from 8th Dec 2020
#   # for (d in row.names(data)) {
#   #   differ = as.numeric(difftime(d, '2020-12-8'))
#   #   if (differ < 0) {
#   #     data[
#   #       d, c(
#   #         "newfirstVaccination", "cumfirstVaccination",
#   #         "newsecondVaccination", "cumsecondVaccination"
#   #       )] <- c(0,0,0,0)
#   #   }
#   # }
# 
#   # linear impute the vaccination injection data
#   # for (d in row.names(data)) {
#   #   if (is.na(data[d, "cumfirstVaccination"])) {
#   #     differ.all = as.numeric(difftime('2021-01-10', '2020-12-7'))
#   #     differ = as.numeric(difftime(d, '2020-12-7'))
#   #     cum <- data['2021-01-10', "cumfirstVaccination"] / differ.all
#   #     data[d, "cumfirstVaccination"] <- round(cum * differ)
#   #   }
#   # }
#   # for (d in row.names(data)) {
#   #   if (is.na(data[d, "newfirstVaccination"])) {
#   #     cum <- data[d, "cumfirstVaccination"]
#   #     x <- ymd(d)
#   #     day(x) <- day(d) - 1
#   #     x <- as.character(x)
#   #     data[d, "newfirstVaccination"] <- cum - data[x, "cumfirstVaccination"]
#   #   }
#   # }
#   # for (d in row.names(data)) {
#   #   if (is.na(data[d, "cumsecondVaccination"])) {
#   #     if (difftime(d, '2021-01-04') > 0) {
#   #       differ.all = as.numeric(difftime('2021-01-10', '2021-01-04'))
#   #       differ = as.numeric(difftime(d, '2021-01-04'))
#   #       cum <- data['2021-01-10', "cumsecondVaccination"] / differ.all
#   #       data[d, "cumsecondVaccination"] <- round(cum * differ)
#   #     } else {
#   #       data[d, "cumsecondVaccination"] <- 0
#   #     }
#   #   }
#   # }
#   #
#   # for (d in row.names(data)) {
#   #   if (is.na(data[d, "newsecondVaccination"])) {
#   #     cum <- data[d, "cumsecondVaccination"]
#   #     x <- ymd(d)
#   #     day(x) <- day(d) - 1
#   #     x <- as.character(x)
#   #     data[
#   #       d, "newsecondVaccination"
#   #     ] <- cum - data[x, "cumsecondVaccination"]
#   #   }
#   # }
# #}

add.policy <- function(data){
  library(dplyr)
  data$Government_announcements <- 0
  data$Lockdown <- 0
  data$Legislation <- 0
  data$schools_universities <- 0
  data <- arrange(data, date)
  # adding the policy data 
  for (d in 1:nrow(data)) {
    date <- data$date[d]
    if (date >= '2020-03-16') {
      data[d,"government_announcements"] <- 1
    }
    if (date >= '2020-03-19') {
      data[d,"government_announcements"] <- 0.7
    }
    if (date >= '2020-03-21') {
      data[d,"schools_universities"] <- 1
    }
    if (date >= '2020-03-23') {
      data[d,"Lockdown"] <- 1
    }
    if (date >= '2020-03-25') {
      data[d,"Legislation"] <- 1
    }
    if (date >= '2020-03-26') {
      data[d,"Lockdown"] <- 1.5
    }
    if (date >= '2020-04-16') {
      data[d,"Lockdown"] <- 2
    }
    if (date >= '2020-04-30') {
      data[d,"government_announcements"] <- 0.6
    }
    if (date >= '2020-05-10') {
      data[d,"government_announcements"] <- 0.3
      data[d,"Lockdown"] <- 1
    }
    if (date >= '2020-06-01') {
      data[d,"schools_universities"] <- 0.7
    }
    if (date >= '2020-06-15') {
      data[d,"Lockdown"] <- 0.5
    }
    if (date >= '2020-05-10') {
      data[d,"government_announcements"] <- 0
      data[d,"Lockdown"] <- 0.1
    }
    if (date >= '2020-06-29') {
      data[d,"government_announcements"] <- 0.2
      data[d,"Lockdown"] <- 0.3
    }
    if (date >= '2020-07-04') {
      data[d,"Lockdown"] <- 0.5
    }
    if (date >= '2020-07-18') {
      data[d,"Legislation"] <- 1.5
    }
    if (date >= '2020-08-03') {
      data[d,"Lockdown"] <- 0.3
    }
    if (date >= '2020-08-14') {
      data[d,"Lockdown"] <- 0
    }
    if (date >= '2020-09-14') {
      data[d,"Lockdown"] <- 0.3
    }
    if (date >= '2020-09-22') {
      data[d,"Lockdown"] <- 1
      data[d,"government_announcements"] <- 1
    }
    if (date >= '2020-09-30') {
      data[d,"government_announcements"] <- 1.2
    }
    if (date >= '2020-10-14') {
      data[d,"Lockdown"] <- 1.2
    }
    if (date >= '2020-10-31') {
      data[d,"Lockdown"] <- 1.4
      data[d,"government_announcements"] <- 1.4
    }
    if (date >= '2020-11-05') {
      data[d,"Lockdown"] <- 1.5
    }
    if (date >= '2020-11-24') {
      data[d,"government_announcements"] <- 0.6
    }
    if (date >= '2020-12-02') {
      data[d,"Lockdown"] <- 2
    }
    if (date >= '2020-12-15') {
      data[d,"government_announcements"] <- 0.2
    }
    if (date >= '2020-12-19') {
      data[d,"government_announcements"] <- 0.5
    }
    if (date >= '2020-12-21') {
      data[d,"Lockdown"] <- 2.5
    }
    if (date >= '2020-12-26') {
      data[d,"Lockdown"] <- 3
    }
    if (date >= '2021-03-07') {
      data[d,"schools_universities"] <- 0.3
    }
  }
  return(data)
}



get.env.data <- function(AREA_NAME) {
  library(tidyr)
  library(dplyr)
  # temperature might have impact on the R_t, hence I download the  temperature data from 'https://www.wunderground.com/history/monthly/gb/london/EGLW/date/2020-5' as a csv data, and then read into R
  # the temperature data is the monthly data
  temperature <- read.csv("./data/temperature.csv")
  temperature <- remove_reference(temperature)
  temperature <- select.nation(temperature, AREA_NAME)
  temperature$date <- as.Date(temperature$date)
  
  # This is the Google trend data downloaded from Google
  protest <- read.csv("./data/protest data.csv")
  protest <- select.nation(protest, AREA_NAME)
  protest$date <- as.Date(protest$date)
  
  temp_protest <- inner_join(temperature, protest, by = "date")
  
  # create a list from "2020-01-05" to today
  #all data generate to this file
  date <- seq.Date(
    from = as.Date(
      "2020/01/05",format = "%Y/%m/%d"
    ), by = "day",
    length.out = as.numeric(
      difftime(Sys.Date(), "2020-01-05")
    )
  )
  data_file <- data.frame(date <- date)
  data_file$t <-1
  colnames(data_file) <- c("date", "try")
  data_file <- left_join(data_file, temp_protest, by = "date")
  data_file <- subset(data_file, select = -c(try))
  
  # impute temperature max
  data_file <- linear.impute(data_file, 2)
  # impute temperature average
  data_file <- linear.impute(data_file, 3)
  # impute temperature min
  data_file <- linear.impute(data_file, 4)
  # impute protest
  data_file <- linear.impute(data_file, 5)
  return(data_file)
}

get.covid.data <- function(AREA_NAME) {
  library(jsonlite)
  library(lubridate)
  # download data from the website
  # API request
  endpoint <- "https://coronavirus.data.gov.uk/api/v1/data"
  
  # Create filters:
  filters <- c(
    sprintf("areaType=%s", "nation"),
    sprintf("areaName=%s", AREA_NAME)
  )

  # Create the structure as a list or a list of lists:
  structure <- list(
    Nation = "areaName",
    date = "date", 
    cases = "newCasesByPublishDate",
    deaths = "newDailyNsoDeathsByDeathDate", 
    # Patients in hospital
    hospital = "hospitalCases",
    ventilationbeds = "covidOccupiedMVBeds",
    #newfirstVaccination = "newPeopleVaccinatedFirstDoseByPublishDate",
    #cumfirstVaccination = "cumPeopleVaccinatedFirstDoseByPublishDate",
    #newsecondVaccination = "newPeopleVaccinatedSecondDoseByPublishDate",
    #cumsecondVaccination = "cumPeopleVaccinatedSecondDoseByPublishDate",
    #newVirusTests = "newPillarTwoTestsByPublishDate",
    # Patients in mechanical ventilation beds
    Beds = "covidOccupiedMVBeds"
  )
  library(httr)
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
  

  # data <- impute.vac(data)
  
  # impute the date
  date <- seq.Date(
    from = as.Date(
      "2020/01/05",format = "%Y/%m/%d"
    ), by = "day",
    length.out = as.numeric(
      difftime(Sys.Date(), "2020-01-05")
    )
  )
  data.date <- data.frame(date <- date)
  data.date$Nation <- AREA_NAME
  colnames(data.date) <- c("date", "Nation")
  data <- left_join(data.date, data, by=c("date", "Nation"))
  
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
  data <- subset(data, select = -c(index))
  
  return(data)
}

get.data <- function() {
  data <- NULL
  nation.list <- c("England", "Wales", "Scotland", "Northern Ireland")
  for (nation in nation.list) {
      env.data <- get.env.data(AREA_NAME = nation)
      covid.data <- get.covid.data(AREA_NAME = nation)

      data.temp <- inner_join(env.data, covid.data, by = c("date"))
      data.temp <- add.policy(data.temp)
      
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
  return(data)
}

data <- get.data()
