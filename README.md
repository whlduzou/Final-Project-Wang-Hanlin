# Understanding the effect of sampling effort on covid-19 case numbers

### Wang Hanlin

This project use 2 approaches to simulate the daily increasing covid-19 cases. 

Here are the common assumptions of this model

1. The serial interval of covid-19 keeps constant with the mean of 5 days [1,2]

2. Non-pharmaceutical interventions would impact the reproduction number of covid-19

3. During the simulation period, delta strain did not occur

When reviewing the data, there is data missing in the beds data, hence a quadratic imputation has been used to impute the data of beds from 5 Mar 2020 to 1 Apr 2020

## Using death data to simulate the number of covid-19 cases

Based on a few assumptions, daily covid-19 data could be simulated by the daily death data. R～t～

### Assumptions

1. The probability that a infected patient would dead is constant (Mean = 0.66% ) [3]

2. The daily death number is accurated. 

3. The day distribution of a person from infection to death is fixed, comfort a certain distribution [4]

## Using people in mechanical ventilation beds data to simulate the number of covid-19 cases

### Assumptions

1. The probability that a infected patient would on mechanical ventilation beds is constant

    Using severe rate (8.8%) of covid-19 as the prior of this probability  [5] 
    
    Additional a small assumption: the severe rate in WUHAN at early stage is as same as in UK

2. The number of people in mechanical ventilation beds data is not accurated, influenced by the daily people in hospital becasue of the limitation of mechanical ventilation beds, many patients who need to be in mechanical ventilation beds but they do not on the beds

    Using Bayesian regression to cope to this problem.
    
3. The day distribution of a person from infection to on the bed is fixed, comfort a certain distribution. Firstly, the day distribution from infection to have symptom is known, comforting a log-normal distribution[6]. Meanwhile, the WHO said, this mild patient would be severe quickly [7], I add a shift of this distribution. 

## Flowchart of 2 approaches

![avatar](/chart/flowchart.png)

## Result

It could be found that the common shape of the simulated cases are similar between this two approaches, but the number of them has a small gap

As to the posterior reproduction number, the round 1 REACT group result of it is 0.57 (0.45, 0.72) between 1st May 2020 and 1 June 2020, which is identical with the simulation result [8] The round 2 result is 0.89 (0.86, 0.93), between 1st May 2020 and early July 2020 [9]. The round 3 result is 1.3 (1.2, 1.4) between 24 July 2020 and 7 Sept 2020, round 4 result is 1.7 (1.4, 2.0) [10]. The round 5 result is 1.06 (0.74, 1.46) between 18 and 26 September 2020 [11]

The cumulative covid-19 patient tends to be 3.822 (3.695, 3.886) million until 15 July 2020 [12]


![avatar](/chart/basic-tutorial.png)

## Reference

 [1,4]: https://www.nature.com/articles/s41586-020-2405-7 Estimating the effects of non-pharmaceutical interventions on COVID-19 in Europe

 [2]: https://www.sciencedirect.com/science/article/pii/S2213398420301895 Estimates of serial interval for COVID-19: A systematic review and meta-analysis

 [3]: https://www.bmj.com/content/369/bmj.m1327.long Covid-19: death rate is 0.66% and increases with age, study estimates 

 [5,7]: https://www.who.int/publications/i/item/report-of-the-who-china-joint-mission-on-coronavirus-disease-2019-(covid-19)    Report of the WHO-China Joint Mission on Coronavirus Disease 2019 (COVID-19)

 [6]: https://www.acpjournals.org/doi/full/10.7326/M20-0504    The Incubation Period of Coronavirus Disease 2019 (COVID-19) From Publicly Reported Confirmed Cases: Estimation and Application

[8]:  https://spiral.imperial.ac.uk/handle/10044/1/83637 Community prevalence of SARS-CoV-2 virus in England during May 2020: REACT study

[9]: https://spiral.imperial.ac.uk/handle/10044/1/83632 Transient dynamics of SARS-CoV-2 as England exited national lockdown

[10]: https://spiral.imperial.ac.uk/handle/10044/1/83635 Resurgence of SARS-CoV-2 in England: detection by community antigen surveillance

[11]: https://spiral.imperial.ac.uk/handle/10044/1/83691 High prevalence of SARS-CoV-2 swab positivity in England during September 2020: interim report of round 5 of REACT-1 study

[12]: https://www.nature.com/articles/s41467-021-21237-w SARS-CoV-2 antibody prevalence in England following the first peak of the pandemic

