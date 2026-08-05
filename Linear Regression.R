setwd("C:/Users/Lenovo/Desktop/DSA/data")


### 1 predictor example

DATA0 = read.csv("DATA0.csv") # make the DATA0set
head(DATA0)
y = DATA0$coly

# Not recommend. Harder to manage with many variable.
# x = DATA0$colx
# y = DATA0$coly
# lm(y~x) 

M1 = lm(coly~colx, data=DATA0) # best way


TSS = var(y)*(length(y) -1) # or
TSS = sum((y- mean(y)) ^2)

RSS =sum((y- M1$fitted )^2) # or 
RSS = sum(M1$residuals^2)

ESS = sum((M1$fitted-mean(y))^2)


R2 = 1 - RSS/TSS; R2 # or 
summary(M1)$r.squared

RSE = sqrt(RSS / df.residual(M1)) # df(d2)  =  n-p-1 (p for predictor)
summary(M1)$sigma                 # d1 = p


new=data.frame(coly = c(2, 4, 6, 8))
predict(M1,newdata=new)

# df(d2)  =  n-p-1 (p for predictor)
# d1 = p

F=(RSS/d2)(ESS/d1)






### More than one predictor example

readLines("DATA.csv", n = 3)

DATA
head(DATA)
str(DATA)

DATA$p1 = as.factor(DATA$p1)
DATA$p2 = as.factor(DATA$p2)

attach(DATA)


#Scatter plot of p4 against p3 for different condition of p1.

cols <- c("black", "lightblue", "pink")
plot(p3, p4, col = cols[p1], pch = 20)
legend("topleft", legend = c("p1 = 1", "p1 = 2", "p1 = 3"),
       col = cols, pch = 20)

# Method 2
plot(p3, p4, type = "n")
points(p3[p1==1], p4[p1==1], pch = 20, col = "black")
points(p3[p1==2], p4[p1==2], pch = 20, col = "lightblue")
points(p3[p1==3], p4[p1==3], pch = 20, col= "pink")
legend("topleft", legend = c("p1 = 1", "p1 = 2", "p1 = 3"),
       col = c("black", "lightblue", "pink"), pch = c(20, 20, 20))



# Linear regression model for p4 which has two explanatories: p3 and p1

M1 <- lm(p4 ~ p3 + p1, data = DATA)
summary(M1)
# Whether the fitted model significant -> check the p-value <0.05


summary(M1)$coefficients # report the equation:
"
p4_hat = -3.93 + (0.244 x p3) + (0.0554 x I(p1 = 2)) 
             − (0.0697 x I(p1 = 3))
"


new = data.frame(p3 = 27, p1 = "3") # use factor!
predict(M1, new) 




### Function to get TPR and FPR given a threshold

data <- data.frame(
  Yi = c(1, 1, 0, 1, 1, 0, 0, 1, 0, 0),
  Yi_hat = c(0.9, 0.5, 0.7, 0.4, 0.5, 0.2, 0.7, 0.9, 0.1, 0.1)
)
data 

get_rates <- function(data, threshold) {
  
  pred <- ifelse(data$Yi_hat > threshold, 1, 0)
  print(pred)
  
  conf_mat <- table(actual = data$Yi, pred = pred)
  print(conf_mat)
  
  TPR <- conf_mat[2, 2] / sum(conf_mat[2, ])
  FPR <- conf_mat[1, 2] / sum(conf_mat[1, ])
  print(c(TPR, FPR))
  
  return(c(TPR = TPR, FPR = FPR))
}

# Get rates for each threshold
rates_0.3 <- get_rates(data, 0.3)
rates_0.6 <- get_rates(data, 0.6)
rates_0.8 <- get_rates(data, 0.8)


# Manually draw ROC

# 1. Start with blank plot
plot(NULL, type = "n", 
     xlim = c(0, 1), ylim = c(0, 1), 
     xlab = "FPR", ylab = "TPR")

# 2. Add FPR and TPR points for different threshold
points(rates_0.3["FPR"], rates_0.3["TPR"], pch = 16, col = "blue")
points(rates_0.6["FPR"], rates_0.6["TPR"], pch = 17, col = "red")
points(rates_0.8["FPR"], rates_0.8["TPR"], pch = 18, col = "black")

# 3. Add legend
legend("bottomright",
       legend = c("Threshold = 0.3", "Threshold = 0.6", "Threshold = 0.8"),
       col = c("blue", "red", "black"), pch = c(16, 17, 18))




### Q: Can we add the two points (0, 0) and (1, 1) to the plot of 
###    ROC plot in part (a). Explain why or why not.

"
TPR = TP / (TP + FN) 
FPR = FP / (FP + TN) 

(0,0) means TPR = FPR = 0 (you never predict positive for anything).
Hence no true positives or no false positives.

(1,1) means TPR = FPR = 1 (you predict positive for everything).
Hence you catch all true positives, but flag all negatives to positives.

For this question:
If threshold > 0.9, then all points predicted as negative (TPR = FPR = 0)
If threshold < 0.1, then all points predicted as positive (TPR = FPR = 1)

Since there exist σ within the range from 0 to 1 for the two points to happen, 
these two points can be added to the plot.
"






### 3D plot

set.seed(520)
x1 = rnorm(100) 
x2 = rnorm(100) 
y = 1 + 2*x1 -5*x2+ rnorm(100)
lm(y~x1+x2)


library(rgl)
M.2 = lm(y~x1+x2)
# 3D plot to illustrate the data points
plot3d (x1 , x2 , y, xlab = "x1", ylab = "x2", zlab = "y",
        type = "s", size = 1.5 , col = "red")

coefs = coef(M.2)
a <- coefs[2] # coef of x1
b <- coefs[3] # coef of x2
c <- -1       # coef of y in the equation: ax1 + bx2 -y + d = 0.
d <- coefs[1] # intercept
planes3d (a, b, c, d, alpha = 0.5) # the plane is added to the plot3d above.





### If want to separate train and test

set.seed(1)
n = dim(resale)[1] 
index.train = sample(1:n)[1:(0.8*n)] 

train.data = resale[index.train, ]
test.data = resale[ - index.train, ]


M3 = lm(response ~ x1 + x2 + x3, data = train.data)
summary(M3)


# predict the response for test set:

prediction = predict(M3, test.DATA0)
prediction

cbind(prediction, test.data$response)




### Extension

# ASSUMPTIONS OF RESPONSE TO FORM A LINEAR MODEL
# the errors/residuals ε must be symmetric around 0   ε∼Normal(0,σ^2)

# (1). response should be symmetric  (residuals should be symmetric)
# (2). variability of response is stable when regressors change (variance of residuals should be constant)

"
skewed y often comes with:
non-constant variance
skewed residuals
"

# check for (1) 
hist(data$response)


# check for (2)
# using scatter plot of y vs quantitative x
# (focus on the vertical spread)

plot(data$x1, data$response)
plot(data$x2, data$response)
# CHECK IF THE RANGE OF PRICE IS NOT STABLE WHEN FLOOR AREA CHANGES.


# If the response is NOT symmetric, very right skewed.
# it's NOT SUITABLE to fit a linear model for resale price.

# TRANSFORMATION IS BETTER, such as taking log-e, or sqrt.

hist(log(data$response)) # slightly better, more symmetric
model_log <- lm(log(response,base = exp(1)) ~ x1 + x2, data = data)
# hence, fitting a linear model for the log-e of the price is better than 
# fitting a LM for the price itself.


# extra stuff
hist(data$response)
qqnorm(data$response)
qqline(data$response)

plot(model$fitted.values, model$residuals)
abline(h = 0, col = "red")




################### EXTRA KNOWLEDGE #############################

# Polynomial model with both height and height^2
polynomial_model <- lm(FEV ~ height + I(height^2), data = fev_data)
summary(polynomial_model)$coef

# Plot
female <- fev_data[fev_data$Sex == 0,]
male <- fev_data[fev_data$Sex == 1,]

plot(fev_data$height, fev_data$FEV, type = "n") 

points(female$height, female$FEV, col = "red", pch = 20)  
points(male$height, male$FEV, col = "darkblue", pch = 20)

legend("topleft", 
       legend = c("Female", "Male"),
       col = c("red", "darkblue"), 
       pch = c(20, 20))
title(main = "Scatterplot of FEV against height (polynomial fit)")

# Add polynomial curve using curve()
curve(predict(polynomial_model, newdata = data.frame(height = x)), 
      add = TRUE, lwd = 3)

