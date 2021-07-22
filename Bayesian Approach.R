library(dplyr)
library(tidyverse)
source("get data function.R")
data <- get.data()
data <- filter(data, Nation == "England")
data <- filter(data.time, date > as.Date("2020-01-31"))
data <- data %>% select(cases, hospital) 

# 126 participants who tested positive with known symptom status in the week prior to their swab, 39 reported symptoms while 87 did not
# p(symptom|covid-19) ~ Beta(39, 87)

# Day ~ Geo(1/7)

# who interview
# p(in hospital| covid-19) ~ Beta(2,8)