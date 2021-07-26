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
  # data$LEP1 <- 0
  # data$LEP2 <- 0
  # data$LRE1 <- 0
  # data$LRE2 <- 0
  # data$LRE3 <- 0
  # data$LRE4 <- 0
  # data$LRE5 <- 0
  # data$LRE6 <- 0
  # data$LRE7 <- 0
  # data$LRE8 <- 0
  # data$LRE9 <- 0
  # data$LRI1 <- 0
  # data$LRI2 <- 0
  # data$LRI3 <- 0
  # data$LRI4 <- 0
  # data$LRI5 <- 0
  # data$LRI6 <- 0
  # data$LRI7 <- 0
  # data$LRI8 <- 0
  # data$LRI9 <- 0
  # data$LRI10 <- 0
  # data$LRI11 <- 0
  # data <- arrange(data, date)
  # # adding the policy data
  # for (d in 1:nrow(data)) {
  #   date <- data$date[d]
  #   if (date >= '2020-03-23') {
  #     data[d,"LRI1"] <- 1
  #   }
  #   if (date >= '2020-03-25') {
  #     data[d,"LEP1"] <- 1
  #   }
  #   if (date >= '2020-03-26') {
  #     data[d,"LRI2"] <- 1
  #   }
  #   if (date >= '2020-04-16') {
  #     data[d,"LRI3"] <- 1
  #   }
  #   if (date >= '2020-05-10') {
  #     data[d,"LRE1"] <- 1
  #   }
  #   if (date >= '2020-06-01') {
  #     data[d,"LRE2"] <- 1
  #   }
  #   if (date >= '2020-06-15') {
  #     data[d,"LRE3"] <- 1
  #   }
  #   if (date >= '2020-06-23') {
  #     data[d,"LRE4"] <- 1
  #   }
  #   if (date >= '2020-07-04') {
  #     data[d,"LRI4"] <- 1
  #     data[d,"LRE5"] <- 1
  #   }
  #   if (date >= '2020-07-18') {
  #     data[d,"LEP2"] <- 1
  #   }
  #   if (date >= '2020-08-03') {
  #     data[d,"LRE6"] <- 1
  #   }
  #   if (date >= '2020-08-14') {
  #     data[d,"LRE7"] <- 1
  #   }
  #   if (date >= '2020-09-14') {
  #     data[d,"LRI5"] <- 1
  #   }
  #   if (date >= '2020-09-22') {
  #     data[d,"LRI6"] <- 1
  #   }
  #   if (date >= '2020-10-14') {
  #     data[d,"LRI7"] <- 1
  #   }
  #   if (date >= '2020-11-05') {
  #     data[d,"LRI8"] <- 1
  #   }
  #   if (date >= '2020-11-24') {
  #     data[d,"LRE8"] <- 1
  #   }
  #   if (date >= '2020-12-02') {
  #     data[d,"LRI9"] <- 1
  #   }
  #   if (date >= '2020-12-15') {
  #     data[d,"LRE9"] <- 1
  #   }
  #   if (date >= '2020-12-21') {
  #     data[d,"LRI10"] <- 1
  #   }
  #   if (date >= '2020-12-26') {
  #     data[d,"LRI11"] <- 1
  #   }
  # }
  # pca <- prcomp(data[,(ncol(data)-21):ncol(data)])[["x"]]
  # data$PCA1 <- pca[,1]
  # data$PCA2 <- pca[,2]
  # data$PCA3 <- pca[,3]
  data$LRI <- 0
  data$LRE <- 0
  data <- arrange(data, date)
  # adding the policy data
  logit <- function(date_now, date_set, r=0.2) {
    dif <- as.numeric(difftime(date_now ,date_set))
    if (dif < 0) {
      return(0)
    } else if(dif == 0) {
      return(1)
    } else {
      round(1 - 0.1*exp(r*dif)/(0.9 + 0.1*exp(r*dif)),1)
    }
  }
  for (d in 1:nrow(data)) {
    date <- data$date[d]
    if (date >= '2020-03-23') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-03-23', r=0.05)
    }
    if (date >= '2020-03-26') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-03-26')
    }
    if (date >= '2020-04-16') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-04-16')
    }
    if (date >= '2020-06-01') {
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-06-01')*0.25
    }
    if (date >= '2020-06-15') {
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-06-15')*0.25
    }
    if (date >= '2020-07-04') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-07-04')*0.25
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-07-04')*0.5
    }
    if (date >= '2020-08-03') {
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-08-03')*0.5
    }
    if (date >= '2020-08-14') {
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-08-14')*0.5
    }
    if (date >= '2020-09-14') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-09-14')*0.25
    }
    if (date >= '2020-10-14') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-10-14')*0.5
    }
    if (date >= '2020-11-05') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-11-05')
    }
    if (date >= '2020-11-24') {
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-11-24')
    }
    if (date >= '2020-12-02') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-12-02')
    }
    if (date >= '2020-12-15') {
      data[d,"LRE"] <- data[d,"LRE"] + logit(date, '2020-12-15')
    }
    if (date >= '2020-12-21') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-12-21')
    }
    if (date >= '2020-12-26') {
      data[d,"LRI"] <- data[d,"LRI"] + logit(date, '2020-12-26')
    }
  }
  return(data)
}

# add.policy <- function(data){
#   library(dplyr)
#   data$Government_announcements <- 0
#   data$Lockdown <- 0
#   data$Legislation <- 0
#   data$schools_universities <- 0
#   data <- arrange(data, date)
#   # adding the policy data
#   for (d in 1:nrow(data)) {
#     date <- data$date[d]
#     if (date >= '2020-03-16') {
#       data[d,"government_announcements"] <- 1
#     }
#     if (date >= '2020-03-19') {
#       data[d,"government_announcements"] <- 0.7
#     }
#     if (date >= '2020-03-21') {
#       data[d,"schools_universities"] <- 1
#     }
#     if (date >= '2020-03-23') {
#       data[d,"Lockdown"] <- 1
#     }
#     if (date >= '2020-03-25') {
#       data[d,"Legislation"] <- 1
#     }
#     if (date >= '2020-03-26') {
#       data[d,"Lockdown"] <- 1.5
#     }
#     if (date >= '2020-04-16') {
#       data[d,"Lockdown"] <- 2
#     }
#     if (date >= '2020-04-30') {
#       data[d,"government_announcements"] <- 0.6
#     }
#     if (date >= '2020-05-10') {
#       data[d,"government_announcements"] <- 0.3
#       data[d,"Lockdown"] <- 1
#     }
#     if (date >= '2020-06-01') {
#       data[d,"schools_universities"] <- 0.7
#     }
#     if (date >= '2020-06-15') {
#       data[d,"Lockdown"] <- 0.5
#     }
#     if (date >= '2020-05-10') {
#       data[d,"government_announcements"] <- 0
#       data[d,"Lockdown"] <- 0.1
#     }
#     if (date >= '2020-06-29') {
#       data[d,"government_announcements"] <- 0.2
#       data[d,"Lockdown"] <- 0.3
#     }
#     if (date >= '2020-07-04') {
#       data[d,"Lockdown"] <- 0.5
#     }
#     if (date >= '2020-07-18') {
#       data[d,"Legislation"] <- 1.5
#     }
#     if (date >= '2020-08-03') {
#       data[d,"Lockdown"] <- 0.3
#     }
#     if (date >= '2020-08-14') {
#       data[d,"Lockdown"] <- 0
#     }
#     if (date >= '2020-09-14') {
#       data[d,"Lockdown"] <- 0.3
#     }
#     if (date >= '2020-09-22') {
#       data[d,"Lockdown"] <- 1
#       data[d,"government_announcements"] <- 1
#     }
#     if (date >= '2020-09-30') {
#       data[d,"government_announcements"] <- 1.2
#     }
#     if (date >= '2020-10-14') {
#       data[d,"Lockdown"] <- 1.2
#     }
#     if (date >= '2020-10-31') {
#       data[d,"Lockdown"] <- 1.4
#       data[d,"government_announcements"] <- 1.4
#     }
#     if (date >= '2020-11-05') {
#       data[d,"Lockdown"] <- 1.5
#     }
#     if (date >= '2020-11-24') {
#       data[d,"government_announcements"] <- 0.6
#     }
#     if (date >= '2020-12-02') {
#       data[d,"Lockdown"] <- 2
#     }
#     if (date >= '2020-12-15') {
#       data[d,"government_announcements"] <- 0.2
#     }
#     if (date >= '2020-12-19') {
#       data[d,"government_announcements"] <- 0.5
#     }
#     if (date >= '2020-12-21') {
#       data[d,"Lockdown"] <- 2.5
#     }
#     if (date >= '2020-12-26') {
#       data[d,"Lockdown"] <- 3
#     }
#     if (date >= '2021-03-07') {
#       data[d,"schools_universities"] <- 0.3
#     }
#   }
#   return(data)
# }


get.env.data <- function(AREA_NAME) {
  library(tidyr)
  library(dplyr)
  if (AREA_NAME == "Nation") {
    AREA_NAME <- "UK"
  }
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
  
  # impute temperature average
  data_file <- linear.impute(data_file, 2)
  data_file$Temperature_Avg <- round(data_file$Temperature_Avg, 1)
  # impute protest
  data_file <- linear.impute(data_file, 3)
  protest$Protest <- round(log(protest$Protest+1)/log(100),2)
  return(data_file)
}

get.covid.data <- function(AREA_NAME) {
  library(jsonlite)
  library(lubridate)
  # download data from the website
  # API request
  endpoint <- "https://coronavirus.data.gov.uk/api/v1/data"
  
  # Create filters:
  if (AREA_NAME == "UK"){
    filters <- c(sprintf("areaType=%s", "overview"))
  } else {
    filters <- c(
      sprintf("areaType=%s", "nation"),
      sprintf("areaName=%s", AREA_NAME)
    )
  }


  # Create the structure as a list or a list of lists:
  structure <- list(
    date = "date", 
    cases = "newCasesByPublishDate",
    deaths = "newDailyNsoDeathsByDeathDate", 
    # Patients adimitted to hospital
    hospital = "newAdmissions",
    inhospital = "hospitalCases",
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
  data$Nation <- AREA_NAME
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

get.data <- function(area = c("Country", "Nation")) {
  data <- NULL
  if (area == "Country") {
    List <- c("England", "Wales", "Scotland", "Northern Ireland")
  } else if (area == "Nation") {
    List <- c("UK")
  }
  
  for (country in List) {
      env.data <- get.env.data(AREA_NAME = country)
      covid.data <- get.covid.data(AREA_NAME = country)
      data.temp <- inner_join(env.data, covid.data, by = c("date"))
      data.temp <- add.policy(data.temp)
      if (country == "Wales") {
        data.temp$pop <- 3228120
      }
      if (country == "Scotland") {
        data.temp$pop <- 5494000
      }
      if (country == "England") {
        data.temp$pop <- 55892000
      }
      if (country == "Northern Ireland") {
        data.temp$pop <- 1905484
      }
      if (country == "UK") {
        data.temp$pop <- 66519604
      }
      data <- rbind(data, data.temp)
  }
  return(data)
}

data <- get.data("Nation")
