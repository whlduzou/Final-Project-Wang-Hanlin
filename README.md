# Understanding the effect of sampling effort on covid-19 case numbers

### Wang Hanlin

## Prior reproduction number

The **lock-down** of city and schools would significantly **reduce the reproduction number** of the coronavirus, while the **protest** of the citizens would **eliminate** the efforts of lock-down. Hence, the shape of the prior reproduction number has been determined by the variation of these two conditions. To determine the number (location) of prior reproduction, the maximum reproduction number should be figured out at the early stage of epidemics(3.38, 95% confidence interval, 2.81 to 3.82) [1]. 

![avatar](/chart/timeline.png)

From figure 1, it could be found that there are lots of lock-down and reopen policies for UK, if all policies are add to the model as dummy variables, the Pareto k diagnostic value would come to the Inf, which means this model cannot fit well, hence, I **combine all policy variables to a single continuious variable**, meaning the effort of lock-down in UK. As the passage of time, the Real-time Assessment of Community Transmission (REACT) group has tested the monthly varied reproduction number. These results are also used to determine the parameters of prior reproduction number. The round 1 REACT group result of it is 0.57 (0.45, 0.72) between 1st May 2020 and 1 June 2020, which is identical with the simulation result [2] The round 2 result is 0.89 (0.86, 0.93), between 1st May 2020 and early July 2020 [3]. The round 3 result is 1.3 (1.2, 1.4) between 24 July 2020 and 7 Sept 2020, round 4 result is 1.7 (1.4, 2.0) [4]. The round 5 result is 1.06 (0.74, 1.46) between 18 and 26 September 2020 [5]. Figure 1 is the prior reproduction number of this project (the blue area is the result of REACT group)

![avatar](/chart/chart/chart_01.png)

### Assumptions and Simulation

1. The serial interval of covid-19 keeps constant with the mean of 5 days [7,8]

2. During the simulation period, delta strain did not occur

Hence, if the time series data of reproduction number is known, the daily increasing cases could be infered.

## Using death data to simulate the number of covid-19 cases

Based on a few assumptions, daily covid-19 data could be simulated by the daily death data.

### Assumptions and Simulation

1. **The daily death number is accurate.**

![avatar](/chart/chart/chart_02.png)

From figure 6, it could be found that this model fits the observed death data well, nearly all observed death data are in the 95% confident interval of the fitted model. 

2. **The probability that a infected patient would dead is constant (Mean = 0.66% )** [9]

3. **The day distribution of a person from infection to death is fixed, comfort a certain distribution** [10]

![avatar](/chart/chart/chart_04.png)

Combining the assumption 2 & 3 and prior reproduction number, the posterior reproduction number could be inferred as figure 4 and the variance of the reproduction number is significantly reduced. Based on it, the daily increasing cases could be inferred.

![avatar](/chart/chart/chart_03.png)

From the figure 2, it could be found that the **peak of simulated daily increasing cases is nearly 550K (450k ,980k) 95%**, which is approximately 20 days ahead of the peak of the daily data (1250). 

The cumulative covid-19 patient tends to be 3.822 (3.695, 3.886) million until 15 July 2020 in the result of **REACT group (red)**[6].  And the similar experiment has conducted withe the **ONS, these results are the yellow one** [14, 15, 16, 17]. The Oxford University also has anther research in the **Oxford area (purple)**, indicating 5.3% (4%, 6.9%)  people have been infected [18]. Meanwhile, in **Greater Glasgow region (green)**, 8.57% (6.095%, 11.05%) people have been infected [19]. The cumulative cases simulated from the death data could been seen from figure 7.

![avatar](/chart/chart/chart_08.png)

## Using people in mechanical ventilation beds data to simulate the number of covid-19 cases

When reviewing the data, there is **data missing in the beds and in hospital data**, hence a quadratic imputation has been used to impute these data.

### Assumptions and Simulation

1. The number of people in mechanical ventilation beds data is **not accurate**, influenced by the daily people in hospital becasue of the limitation of mechanical ventilation beds, many patients who need to be in mechanical ventilation beds but they do not on the beds

![avatar](/chart/chart/chart_05.png)

From the figure 7, it could be found that at the early stage of the epidmic, the daily increasing patient in the ventilation beds is rather underestimated. This fitness result from other aspect to checking the news that there is insufficient ventilation beds for patients in UK

2. The probability that a infected patient would on mechanical ventilated beds is constant

    Using severe rate (13.8%) of covid-19 as the prior of this probability  [11] 
    
3. The day distribution of a person from infection to on the bed is fixed, comfort a certain distribution. Firstly, the day distribution from infection to have symptom is known, comforting a log-normal distribution[12]. Meanwhile, the WHO said, this mild patient would be severe quickly [13], I add a shift of this distribution. 

![avatar](/chart/chart/chart_06.png)

Combining the assumption 2 & 3 and prior reproduction number, the posterior reproduction number could be infered as figure 5. Based on it, the daily increasing cases could be infered

![avatar](/chart/chart/chart_07.png)

From the figure 3, it could be found that the shape of the simulated cases are similar between this two approaches, but the number of them has a small gapthe. The **peak of simulated daily increasing cases is nearly 410K (330k ,610k) 95%**, which is approximately 20 days ahead of the peak of the daily increasing ventilation data (3250). 

The cumulative covid-19 patient tends to be 3.822 (3.695, 3.886) million until 15 July 2020 in the result of **REACT group (red)**[6].  And the similar experiment has conducted withe the **ONS, these results are the yellow one**. The Oxford University also has anther research in the **Oxford area (purple)**, indicating 5.3% (4%, 6.9%)  people have been infected. Meanwhile, in **Greater Glasgow region (green)**, 8.57% (6.095%, 11.05%) people have been infected. The cumulative cases simulated from the ventilated beds data could been seen from figure 7.

![avatar](/chart/chart/chart_09.png)

## Flowchart of 2 approaches

![avatar](/chart/flowchart.png)

## Reference

[1]: [Estimate of the Basic Reproduction Number for COVID-19: A Systematic Review and Meta-analysis](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7280807) 

[2]: [Community prevalence of SARS-CoV-2 virus in England during May 2020: REACT study](https://spiral.imperial.ac.uk/handle/10044/1/83637) 

[3]: [Transient dynamics of SARS-CoV-2 as England exited national lockdown](https://spiral.imperial.ac.uk/handle/10044/1/83632) 

[4]: [Resurgence of SARS-CoV-2 in England: detection by community antigen surveillance](https://spiral.imperial.ac.uk/handle/10044/1/83635) 

[5]: [High prevalence of SARS-CoV-2 swab positivity in England during September 2020: interim report of round 5 of REACT-1 study](https://spiral.imperial.ac.uk/handle/10044/1/83691) 

[6]: [SARS-CoV-2 antibody prevalence in England following the first peak of the pandemic](https://www.nature.com/articles/s41467-021-21237-w) 

[7,10]: [Estimating the effects of non-pharmaceutical interventions on COVID-19 in Europe](https://www.nature.com/articles/s41586-020-2405-7) 

[8]: [Estimates of serial interval for COVID-19: A systematic review and meta-analysis](https://www.sciencedirect.com/science/article/pii/S2213398420301895) 

[9]: [Covid-19: death rate is 0.66% and increases with age, study estimates](https://www.bmj.com/content/369/bmj.m1327.long)

[11,13]: [Report of the WHO-China Joint Mission on Coronavirus Disease 2019 (COVID-19)](https://www.who.int/publications/i/item/report-of-the-who-china-joint-mission-on-coronavirus-disease-2019-(covid-19))   

[12]: [The Incubation Period of Coronavirus Disease 2019 (COVID-19) From Publicly Reported Confirmed Cases: Estimation and Application](https://www.acpjournals.org/doi/full/10.7326/M20-0504)    

[14]: Coronavirus "COVID-19) Infection Survey pilot: 28 May 2020 - Office for National Statistics](https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/28may2020"

[15]: Coronavirus "COVID-19) Infection Survey pilot: 5 June 2020 - Office for National Statistics](https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/5june2020"

[16]: Coronavirus "COVID-19) Infection Survey pilot: 18 June 2020 - Office for National Statistics](https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/18june2020"

[17]: Coronavirus "COVID-19) Infection Survey pilot: 2 July 2020 - Office for National Statistics](https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/2july2020"

[18]: [SARS-CoV-2 antibody prevalence, titres and neutralising activity in an antenatal cohort, United Kingdom, 14 April to 15 June 2020](https://pubmed.ncbi.nlm.nih.gov/33094717)

[19]: [Detection of neutralising antibodies to SARS-CoV-2 to determine population exposure in Scottish blood donors between March and May 2020](https://pubmed.ncbi.nlm.nih.gov/33094713)
