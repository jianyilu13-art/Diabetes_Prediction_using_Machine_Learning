### Basic statistic metric

DATA <- read.csv("DATA.csv")

head(DATA)
label1 = round(DATA$DATA_label1, digits = 2)
label1

n = length(label1); n
summary(label1)


range(label1)
var(label1)
sd(label1)
IQR(label1)
label1[label2(label1)[1:5]] # The 5 smallest observations
label1[label2(label1)[(n-4):n]]# The 5 largest observations

# CORRELATION COEFFICIENT
label2 = DATA$label2
cor(label1, label2)

# r = covariance / (standard deviations)
# R² = 1 − unexplained / total variation


### Quantiles, IQR, Outliers

Q1 <- quantile(data, 0.25)
Q3 <- quantile(data, 0.75)
IQR_value <- IQR(data)

lower <- Q1 - 1.5 * IQR_value
upper <- Q3 + 1.5 * IQR_value

data[data < lower | data > upper]




### HISTOGRAM PLOTS
# HISTOGRAM in FREQUENCY

hist(label1, freq=TRUE, main = paste("Histogram of label1 DATA"),
     xlab = "label1", ylab="Frequency", col = "blue")


# HISTOGRAM WITH DENSITY LINE

hist(label1, freq=FALSE, main = paste("Histogram of label1 DATA"),
     xlab = "label1", ylab="Probability", 
     col = "blue", ylim = c(0, 0.0045))
lines(density(label1), col = "red") # this is the density curve of "label1"

# If we don't add ylim
# the density curve of "label1" will cut off at the top part
# since the shown y-axis is not long enough


# HISTOGRAM WITH NORMAL DENSITY

hist(label1, freq=FALSE, main = paste("Histogram of label1 DATA"),
     xlab = "label1 DATA", ylab="Probability", 
     col = "grey", ylim = c(0, 0.002))
x <- seq(0, max(label1), length.out=n)
y <- dnorm(x, mean(label1), sd(label1))
lines(x, y, col = "red") # this is the normal density curve




### BOX PLOTS

boxplot(label1, xlab = "label1 DATA", col = "blue", main = "Boxplot for ...") 
# order matters only when you don’t name arguments

outlier = boxplot(label1)$out; outlier
# get the values that are outliers

length(outlier) 
# count the number of outliers:

index = which(label1 %in% outlier) ; index 
# get the indexes of the outlier points

DATA[c(index),]
#information of all the outliers:

# BOX PLOTS OF MULTIPLE GROUP
boxplot(label1 ~ DATA$label3, col = "blue")
# numerical ~ categorical



### QQ plot
qqnorm(label1, main = "QQ Plot", pch = 20)
qqline(label1, col = "red")





### SCATTER PLOT
plot(label2,label1, pch = 20, col = "darkblue")

attach(DATA)
plot(label2,label1, type = "n") # a scatter plot with no point added
points(label2[DATA$label3=="A"],label1[DATA$label3=="A"],pch = 2, col = "blue") # Type A
points(label2[DATA$label3=="B"],label1[DATA$label3=="B"],pch = 20, col = "red") # Type B
legend(1,7500,legend=c("Type A", "Type B"),col=c("red", "blue"), pch=c(20,2))
detach(DATA)
# (x = 1, y =7500) tells R the place where you want to put the lengend box in the plot
# do note on the size of the points since the points added latter will overlay on the points added earlier
# hence, the points added latter should be chosen with smaller size so that they will not cover the points earlier




### BARPLOT FOR CATEGORICAL VARIABLE

count = table(DATA$label3); count # frequency table
barplot(count)




### PIE CHART
pie(count)




### CATEGORIZING "label2"
label2 = DATA$num_of_label2s
label2.size = ifelse(label2<=5, "small", "large")
table(label2.size)



### CONTINGENCY TABLE
table = table(DATA$label3,label2.size);table # table(cols, rows)

tab = prop.table(table, 1); tab # proportion by label3

tab[1]/(1-tab[1]) # the odds of large label2 among Type B 

tab[2]/(1-tab[2]) # the odds of large label2 among Type A

OR = (tab[1]/(1-tab[1]))/(tab[2]/(1-tab[2])); OR 
# it means: the odds of larger label2s among Type B is OR times the odds of large label2s among Type A.

# X Y
# A    1 1
# B    1 0
# 
# [1] A-X
# [2] B-X
# [3] A-Y
# [4] B-Y

# tab["A","X"]  save and precise



###  Example for box plot for multiple kinds
boxplot(data$price[data$year %in% 2016:2020] ~ data$year[data$year %in% 2016:2020], col = "blue")
# can add x lab and y lab


### Example for new filtering method

library(ggplot2)
library(dplyr)

data %>%
  filter(year %in% 2016:2020) %>%
  ggplot(aes(x = factor(year), y = price)) +
  geom_boxplot(fill = "blue") +
  xlab("Year") + ylab("Price") +
  ggtitle("Car Prices by Year (2016-2020)")





### Example for combine 2 plots tgt 
# Arrange a figure of 1 row and 2 columns
opar <- par(mfrow=c(1,2))

# Plot the two histogram
hist(female$FEV, 
     col = "pink", 
     freq = FALSE, 
     xlim = c(0,6), # align x-axis
     ylim = c(0,0.52), # align y-axis
     main = "Histogram of Female FEV")

hist(male$FEV, 
     col = "lightblue", 
     freq = FALSE, 
     xlim = c(0,6), # align x-axis
     ylim = c(0,0.52), # align y-axis
     main = "Histogram of Male FEV")

# Rmb to reset to a figure of 1 row and 1 column
opar <- par(mfrow=c(1,1))

