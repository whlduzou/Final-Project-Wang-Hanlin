# Understanding the effect of sampling effort on covid-19 case numbers

### Wang Hanlin

## Assumptions: 

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

## flowchart of a health person from infection to death
```flow

st=>start: a health person
op1=>operation: the probability that infected by the covid-19 is based on the $R_t$
op2=>operation: the $R_t$ is impacted by the lockdwon-associated variables, **temperature, protest condition** and, **comunity immunity could decrease $R_t$**
cond1=>condition: Is infected by the covid-19?
op3=>operation: keep healthy
op4 =>operation: become a infected person; case + 1

st->op1->cond1
op2->op1
cond1(yes)->op4
cond1(no)->op3(right)->op1




