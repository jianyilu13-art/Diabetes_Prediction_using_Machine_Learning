# Histogram

"
The sample of the resale price is not normally distributed, 
it is in fact right (positively) skewed. 

It is also unimodal, with one peak around 400,000-450,000

Range is from 200,000 to 1,000,000.

It also has possible upper-tail outliers. 
"

# Box Plot

"
Many outliers on the high-end, not low-end -> Right-skewed & Upper-tail outliers
Outliers are around 650,000 and above

Lower Quartile is slightly below 400,000. Median is slightly above 400,000. 
Upper Quartile is slightly below 500,000. 
"

# QQ Plot

"
Left tail sample quantiles are larger than expected, 
hence left tail shorter than normal. 

Right tail sample quantiles larger than expected, 
hence right tail longer than normal.

Combined with histogram in 1b, it's clear that the sample of 
FEV is not normal and quite right skewed
"

# cor

"
The correlation coefficient is ~0.87, indicating a strong positive 
linear association between FEV and height. 

The range of FEV for males appears larger than for females, 
as does the range of heights. 

The variability of FEV increases with height, showing greater spread at taller heights 
compared to shorter heights (heteroscedasticity).
"

# LM
"
There seems to be a strong positive linear association of x and y.

The variability of y (price) is also quite stable when x (size) changes. (Homoscedasticity)
"

"
`For two houses of the same size (fixed x), the house in the more desirable part 
(NW = 1) is $30569.1 more than the one in the less desirable part (NW = 0).`
"


"
Reporting either R^2 or Adjusted R^2 or both is fine for this question.

The Adjusted R^2 of model LM is 0.348, meaning only about 34.8% of the 
variation in the diabetes status is explained by the six input features.

Although the F-statistic (89.76, p-value < 2.2e-16) indicates the model is 
jointly significant, the relatively low R^2 and adj R^2 values suggests a 
poor fit.
"



"
We need to check if column resale_price satisfies: 
(1) Quantitative
(2) Symmetric
(3) Variability is stable when other quantitative regressor(s) change.

Since it is right-skewed as noted by the histogram, resale price is NOT suitable to be the 
response of a linear model. 

For a right skewed variable, it is suggested to try with a transformation by taking log_e.
"

"
The histogram of the log of the resale price is more symmetric -> more suitable than the original
resale price as a response of a linear model. 

We may check to see if the variability of log(resale price) is stable as x (floor area) 
changes by the scatter plot (which leads us to our next question!)
"

"
The scatter plot shows a strong, positive and quite linear association between 
log(price) and the floor area. 

The variability of the log(price) seems QUITE stable when the floor area changes.
Note: the variability is not strongly stable (as we can see near the right end of floor area),
but it's can be considered as somewhat stable.

From (b) and (c), it’s quite suitable to fit a linear model for log(price).
"


"
R-squared is 0.712. That means model M_hdb can explain 71.2% the variability of the 
response in the sample.
"
# Check R-squared: higher value = better fit (explains more price variation)
# Check adjusted R-squared: better for models with multiple predictors
# Check overall p-value (F-test): small p-value = model is useful
# Residuals show issues (unequal spread), so fit is limited




#DT

"
sepal length and sepal width is not as important while
petal length and petal width is more important.
most important feature is petal length

RMB: in this course  we don't use iris_fit$variable.importance to determine 
important features. We simply choose the feature closest to root node
"

"
From the plot, we could observe that cp = 0.01 (10^-2) is a reasonable 
choice with low mis-classification rate.

High cp → only large improvements allowed → small/simple tree
Low cp → even small improvements allowed → larger/deeper tree
"
#NB

"
For continuous features, Naive Bayes assumes a 
Gaussian (normal) distribution. It estimates the 
mean and sd of each feature for each class 
(diabetes = 0 and 1) from the training data, and uses 
these to compute probabilities during prediction.
"

# Logistic Regression

"
log_odds <- 2.0438 +
            (-1.0181) * I(Class == 2nd) +
            (-1.7778) * I(Class == 3rd) +
            (-0.8577) * I(Class == Crew) +
            (-2.4201) * I(Sex == Male) +
            (1.0615)  * I(Age == Child)
"



"
SexMale: -2.4201

Fixing other variables, being male DECREASES 
the LOG ODDS OF SURVIVING by 2.4201 compared to 
being female.

Fixing other variables, being male multiplies 
the ODDS of surviving by e^(-2.4201) = 0.0889 
compared to being female

Alternatively you can say:
Fixing other variables, being FEMALE multiplies 
the ODDS of surviving by e^(2.4201) = 11.25 compared 
to being MALE
"


"
From the ROC curves and AUS values, it suggests that 
logistic regression is slightly better than Naive Bayes
in predicting the survival status for this data set.
"


"
Given that both people have the same values for the 
other features, having hypertension (hypertension = 1) 
multiples the odds of having diabetes by e^(0.885) = 2.423 
compared to a person without hypertension (hypertension = 0)

odds_w_hypertension = odds_wo_hypertension * 2.423

so the odd ratio is simply:
odds_w_hypertension / odds_wo_hypertension = 2.423
"

# K-Means
"
Recall that one weakness of K-means 
is that its final clusters can vary 
a lot depending on the initialization 
of centroids!

nstart = 20 here will run the kmeans 
20 times with diff initialization
and returns the one is lowest wcss 
"


"
Using the elbow method, a possible best k 
is k = 3 as the reduction in WSS from k = 3 to 
k = 4 is not too significant.
"

# Association Rule
"
Key on how to read this graph:
1. Larger circle -> Higher Support 
2. Darker circle -> Higher Lift

Each circle is a rule. Arrows going into the circle is
LHS of rule and arrows going out of circle is RHS of rule
"

