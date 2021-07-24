# Understanding the effect of sampling effort on covid-19 case numbers

### Wang Hanlin

This project use 2 approaches to simulate the daily increasing covid-19 cases. 

Here are the common assumptions of this model

1. The serial interval of covid-19 keeps constant

2. Non-pharmaceutical interventions would impact the reproduction number of covid-19

## Using death data to simulate the number of covid-19 cases

Based on a few assumptions, daily covid-19 data could be simulated by the daily death data.

### Assumptions

1. The probability that a infected patient would dead is constant (Mean = 1% Less than 2%)

2. The daily death number is accurated. 

3. The day distribution of a person from infection to death is fixed, comfort a certain distribution [1]

### flowchart

![avatar](/chart/flowchartdeath.png)

## Using people in mechanical ventilation beds data to simulate the number of covid-19 cases

### Assumptions

1. The probability that a infected patient would on mechanical ventilation beds is constant

    Using severe rate (13.8%) of covid-19 as the prior of this probability  [2]
    
    Additional a small assumption: the severe rate in WUHAN at early stage is as same as in UK

2. The number of people in mechanical ventilation beds data is not accurated, influenced by the daily people in hospital becasue of the limitation of mechanical ventilation beds, many patients who need to be in mechanical ventilation beds but they do not on the beds

    Using Bayesian regression to cope to this problem.
    
3. The day distribution of a person from infection to on the bed is fixed, comfort a certain distribution. Firstly, the day distribution from infection to have symptom is known, comforting a log-normal distribution[3]. Meanwhile, the WHO said, this mild patient would be severe quickly [4], I add a shift of this distribution. 

### flowchart

![avatar](/chart/flowchartbeds.png)

## Reference

 [1]: https://www.nature.com/articles/s41586-020-2405-7 Estimating the effects of non-pharmaceutical interventions on COVID-19 in Europe

 [2,4]: https://www.who.int/publications/i/item/report-of-the-who-china-joint-mission-on-coronavirus-disease-2019-(covid-19)    Report of the WHO-China Joint Mission on Coronavirus Disease 2019 (COVID-19)

 [3]: https://www.acpjournals.org/doi/full/10.7326/M20-0504    The Incubation Period of Coronavirus Disease 2019 (COVID-19) From Publicly Reported Confirmed Cases: Estimation and Application

