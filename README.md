# Understanding the effect of sampling effort on covid-19 case numbers

### Wang Hanlin

## flowchart of the Simulation Approach

I use the idea of the Binomial Tree to infer the the real cases numbers

### Assumptions

1. p(symptom|  covid-19) keep constant

   I assume p(symptom|  covid-19) ~ beta(39, 87)

   because in the REACT study , 39 patients reported symptoms while 87 did not ^[1]^

   [1]: https://spiral.imperial.ac.uk/handle/10044/1/83637	"Community prevalence of SARS-CoV-2 virus in England during May 2020: REACT study"

2.  $$\lambda$$ keep constant

   

3. 

4. 

5. 

6. 

7. 

8. 

9. 

10. 

    

### ![avatar](/binomialtrees.png)



### Assumptions from infection to death

1. **The distribution of the day from infection to death is constant.**

I don’t think it is a good assumption. Also there is no specific medicine for the covid-19, the mechanical ventilation beds could definitely longer the survival time of the patients. However the number of mechanical ventilation beds is limited, many patients have no chance to use them. Hence when the more people in the mechanical ventilation beds, the shorter time from infection to death would be.

Because this parameter in this package have to be constant, **I assume that this time in a certain range (or 1 month) of time would be constant, but would change based on the people mechanical ventilation beds**

### Other assumptions

1. **Only non-pharmaceutical interventions would impact the reproduction number ($R_t$)**

(Forbid public events, schools and universities lock-down self-isolating if ill, social distancing encouraged and city lock-down)


I add two variables (**the environment temperature and the protest against the lock-down**), because the virus is sensitive to the environment temperature and not all people would abide by the lock-down rules, they want to protest on the street consequence to the increase of reproduction number.

Also **I change the dummy to the continuous variables (I would try factor variables later).**

2. **The death case confirmed by the government is certainly the truth number in the UK (with the same criteria).**

I think although it is certain that some death cases are omitted by the government, we cannot find the “truth number”, hence, this assumption should be held.

3. **The serial interval of covid-19 and the days to seed infection would be constant.**

I think it is the built-in attribute for the covid-19, which would not be impacted.

## flowchart from infection to death

![avatar](./flowchart.png)
