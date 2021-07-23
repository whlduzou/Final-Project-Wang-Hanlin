Sys.setlocale("LC_TIME","English")
library(rstan)
library(dplyr)
library(ggplot2)
source("get data function.R")
data <- get.data()
data <- filter(data, Nation == "England")
data <- filter(data, date > as.Date("2020-01-20"))
data <- filter(data, date < as.Date("2020-06-01"))
pop <- data$pop[1]
data <- data %>% select(date, cases, hospital)
data$difference = data$cases - data$hospital
data$max <- 0 # 95%
data$max_h <- 0 # 50%
data$covid <- 0
data$min_h <- 0
data$min <- 0
iter <- 1000
for (i in 1:266) {
  if (data$difference[i] < 0) {
    data$difference[i] <- 0
  }
  covid <- sort(round(
    (
      data$difference[i]/(
        rbeta(iter, 422,27)*rbeta(iter, 75, 25)
        ) + data$hospital[i]
     )/rbeta(iter, 39, 87)
    ))
  for (c in 1:covid[iter/2]) {
    n <- rgeom(1, 0.16)
    data$covid[i-n] <- data$covid[i-n] + 1
  }
  for (c in 1:covid[iter*0.025]) {
    n <- rgeom(1, 0.16)
    data$min[i-n] <- data$min[i-n] + 1
  }
  for (c in 1:covid[iter*0.25]) {
    n <- rgeom(1, 0.16)
    data$min_h[i-n] <- data$min_h[i-n] + 1
  }
  for (c in 1:covid[iter*0.75]) {
    n <- rgeom(1, 0.16)
    data$max_h[i-n] <- data$max_h[i-n] + 1
  }
  for (c in 1:covid[iter*0.975]) {
    n <- rgeom(1, 0.16)
    data$max[i-n] <- data$max[i-n] + 1
  }
}


ggplot(data) + 
  geom_line(aes(x = date, y = covid), color = "red", size = 1) + 
  geom_ribbon(
    aes(ymin=min_h, ymax=max_h, x=date), fill = "red", alpha = 0.5
    ) +
  geom_ribbon(
    aes(ymin=min, ymax=min_h, x=date), fill = "red", alpha = 0.2
    ) +
  geom_ribbon(
    aes(ymin=max_h, ymax=max, x=date), fill = "red", alpha = 0.2
    ) +
  geom_line(aes(x = date, y = cases), color = "green", size = 1) +
  geom_line(aes(x = date, y = hospital), color = "blue", size = 1)