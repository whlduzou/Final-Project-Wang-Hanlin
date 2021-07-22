library(rstan)
library(dplyr)
library(tidyverse)
source("get data function.R")
data <- get.data()
data <- filter(data, Nation == "England")
data <- filter(data.time, date > as.Date("2020-01-01"))
data <- filter(data.time, date < as.Date("2020-06-01"))
pop <- data$pop[1]
data <- data %>% select(cases, hospital)


mycode <- "
data {
  int<lower=0> N; 
  real<lower=0> Cases[N];
  real<lower=0> Hospital[N]; 
  int<lower=0> pop;
}
parameters {
  real<lower=0,upper=1> p_sampling[N];
  real<lower=0,upper=1> p_symptom;
  real<lower=0,upper=1> p_servere;
  real<lower=0,upper=1> p_test;
  real<lower=0,upper=1> p_sensitive;
  real<lower=0,upper=1> p_hospital_symptom;
  real mu[N];
  real sigma[N];
}
transformed parameters {
  real<lower=0,upper=1> p_hospital_covid[N];
  real<lower=0,upper=1> p_hospital[N];
  real<lower=0,upper=1> p_cases_covid[N];
  real<lower=0,upper=1> p_cases[N];
  
  real<lower=0> E_hospital[N];
  real<lower=0> Var_hospital[N];
  real<lower=0> E_cases[N];
  real<lower=0> Var_cases[N];
  //p_hospital_symptom = p_servere / p_symptom;
  for (n in 1:N) {
      p_hospital_covid[n] = p_sampling[n] * p_servere;
      p_hospital[n] = p_hospital_covid[n] * p_sampling[n];
      E_hospital[n] = p_hospital[n] * pop;
      Var_hospital[n] = p_hospital[n] * pop * (1 - p_hospital[n]);
      p_cases_covid[n]  = p_hospital_covid[n] + p_symptom * (1 - p_hospital_symptom) * p_test * p_sensitive;
      p_cases[n] = p_cases_covid[n] * p_sampling[n];
      E_cases[n] = p_cases[n] * pop;
      Var_cases[n] = p_cases[n] * pop * (1 - p_cases[n]);
  }
}
model {
  p_servere ~ normal(0.138, 0.0001188);
  p_hospital_symptom ~ normal(0.4534, 0.005035);
  mu ~ gamma(0.001, 0.001);
  sigma ~ inv_gamma(0.001, 0.001);
  p_sampling ~ normal(mu, sigma);
  p_symptom ~ normal(0.3095, 0.001683);
  p_test ~ normal(0.7448,0003961);
  p_sensitive ~ normal(0.9399, 0.0001256);
  Hospital ~ normal(E_hospital, Var_hospital);
  Cases ~ normal(E_cases, Var_cases);
}
"

mydat <- list(
  N = 148, Cases = data$cases, Hospital = data$hospital, pop=pop
  )

fit <- stan(model_code=mycode, data = mydat, iter = 1000, chains = 4)

mycode <- "
data {int J;}
parameters {
real p[J];
for (j in 1:J){
  p[j] = beta_rng(20,30);
}
}
"
mydat <- list(J = 10)
fit <- stan(model_code=mycode, data = mydat, iter = 1000, chains = 4)

print(fit)

var <- var(rbeta(1000,138,862)/rbeta(1000,39,87))
mu <- mean(rbeta(1000,138,862)/rbeta(1000,39,87))
alpha <- mu^2*(1-mu)/var-mu
beta <- alpha*(1-mu)/mu

transformed parameters {
  real pp[J]
  
  for (j in 1:J) {
    pp[j] = exp(p[j])
    
  }
}