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
# AREA_NAME <- "England"
get.data.overall <- function(AREA_NAME) {
  library(tidyr)
  library(dplyr)
  # temperature might have impact on the R_t, hence I download the  temperature data from 'https://www.wunderground.com/history/monthly/gb/london/EGLW/date/2020-5' as a csv data, and then read into R
  # the temperature data is the monthly data
  temperature <- read.csv("./data/temperature.csv")
  temperature <- remove_reference(temperature)
  temperature <- select.nation(temperature, AREA_NAME)
  temperature$Date <- as.Date(temperature$Date)
  
  # This is the Google trend data downloaded from Google
  protest <- read.csv("./data/protest data.csv")
  protest <- select.nation(protest, AREA_NAME)
  protest$Date <- as.Date(protest$Date)
  
  temp_protest <- inner_join(temperature, protest, by = "Date")
  
  # create a list from "2020-01-05" to today
  #all data generate to this file
  Date <- seq.Date(
    from = as.Date(
      "2020/01/05",format = "%Y/%m/%d"
    ), by = "day",
    length.out = as.numeric(
      difftime(Sys.Date(), "2020-01-05")
    )
  )
  data_file <- data.frame(date <- Date)
  data_file$t <-1
  colnames(data_file) <- c("Date", "try")
  data_file <- left_join(data_file, temp_protest, by = "Date")
  data_file <- subset(data_file, select = -c(try))
  
  # impute temperature max
  data_file <- linear.impute(data_file, 2)
  # impute temperature average
  data_file <- linear.impute(data_file, 3)
  # impute temperature min
  data_file <- linear.impute(data_file, 4)
  # impute protest
  data_file <- linear.impute(data_file, 5)
  
  
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
data <- get.data.overall("nation", "England")

