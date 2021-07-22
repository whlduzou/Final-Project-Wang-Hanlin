library(rstan)
library(dplyr)
library(tidyverse)
source("get data function.R")
data <- get.data()
data <- filter(data, Nation == "England")
data <- filter(data.time, date > as.Date("2020-01-31"))
data <- data %>% select(cases, hospital)


mycode <- "
data {
  int<lower=0> N; 
  real<lower=0> Cases[N];
  real<lower=0> Hospital[N]; 
  real<lower=0> pop;
}
parameters {
  real<lower=0,upper=1> p_sampling[N];
  real<lower=0,upper=1> p_symptom;
  real<lower=0,upper=1> p_servere;
  real<lower=0,upper=1> p_test;
  real<lower=0,upper=1> p_sensitive;
  real<lower=0,upper=1> test_prior;
  real<lower=0,upper=1> servere_prior;
  real<lower=0> c[N];
}
transformed parameters {
  real<lower=0,upper=1> p_hospital_symptom;
  real<lower=0,upper=1> p_hospital_covid;
  real<lower=0,upper=1> p_hospital;
  real<lower=0,upper=1> p_cases_covid;
  real<lower=0,upper=1> p_cases;
  p_hospital_symptom <- p_servere / p_symptom;
  p_hospital_covid <- p_sampling*p_servere;
  p_hospital <- p_hospital_covid *p_sampling;
  p_cases_covid  <- p_hospital_covid  + p_symptom*(1-p_hospital_symptom)*p_test*p_sensitive;
  p_cases <- p_cases_covid *p_sampling;
}
model {
  c ~ gamma(0.001, 0.001); // Non-informative prior
  p_sampling ~ poission(c);
  p_sympotm ~ beta(39,87);
  servere_prior ~ beta(138, 862) // Informative prior
  p_servere ~ bernoulli(servere_prior);
  test_prior ~ beta(35,12) // Informative prior
  p_test ~ bernoulli(test_prior);
  p_sensitive ~ binomial(449, 0.94);
  Hospital ~ binomial(pop, p_hospital);
  Cases ~ binomial(pop, p_cases);
}
"


mydat <- list(J = 8, y = c(28, 8, -3, 7, -1, 1, 18, 12),
              sigma = c(15, 10, 16, 11, 9, 11, 10, 18))




fit <- stan(model_code=mycode, data = mydat, iter = 1000, chains = 4)




print(fit)