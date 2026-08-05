setwd("C:/Users/Lenovo/Desktop/DSA/data")

DATA = read.csv("DATA.csv")



library("rpart")
library("rpart.plot")

fit <- rpart(response ~ lab1+lab2+lab3,
             method="class",
             data=DATA,
             control=rpart.control(minsplit=1),
             parms=list(split='information')
)
rpart.plot(fit, type=4, extra=2, varlen=0, faclen=0, clip.right.labs=FALSE)


# method:
# "anova"   → regression (numeric response, minimize squared error)
# "class"   → classification (factor response)
# "poisson" → count data (rates / counts)
# "exp"     → survival data (time-to-event)


# split (only for classification, inside parms):
# "gini"        → default, measures node impurity
# "information" → entropy / information gain
# (both decide HOW to split, not tree size)



fit <- rpart(response ~ lab1+lab2+lab3,
             method="class",
             data=DATA,
             control=rpart.control(maxdepth = 6),    
             parms=list(split='information')
)
rpart.plot(fit, type=4, extra=2, varlen=0, faclen=0, clip.right.labs=FALSE)

# cp:
# Smaller cp → more splits → larger, more complex tree
# Larger cp → fewer splits → simpler tree (more pruning)

# maxdepth:
# Maximum levels of the tree
# Smaller → simpler model; larger → more complex

# minsplit:
# Minimum observations needed to try a split
# Smaller → easier to split → larger tree
# Larger → harder to split → simpler tree

# minbucket:
# Minimum observations in a leaf node
# Smaller → finer splits; larger → smoother model

# xval:
# Number of folds for cross-validation
# Larger → more accurate but slower



fit <- rpart(response ~ lab1+lab2+lab3,
             method="class",
             data=DATA,
             control=rpart.control(cp = 0.001),    
             parms=list(split='information')
)
rpart.plot(fit, type=4, extra=2, varlen=0, faclen=0, clip.right.labs=FALSE)

#varlen = length of variable's name,varlen = 0 means full name of input variables is shown
#faclen = length of category's name, faclen = 0 means full name of categories
#clip.right.labs: TRUE means don't print the name of variable for the right stem
# You can try with varlen = 4 to see the difference compared to varlen = 0.
# type = 0, 1, ..., 5
# extra = 0, 1,..., 11




### Prediction & If no need to change threshold

newdata <- data.frame(Lab1= c("A", "B"), Lab2= c("C","D"),
                      Lab3=c("X", "Y"), Lab4=c(FALSE, TRUE))
newdata
predict(fit,newdata=newdata,type="prob")


best_cp = cp_seq[3]
fit <- rpart( response~lab1+lab2+lab3+lab4,
              method="class",
              data=train.set,
              control=rpart.control(cp = best_cp),
              parms=list(split='information')) 
rpart.plot(fit, type=4, extra=2, varlen=0, faclen=0, clip.right.labs=FALSE)


newdata <- data.frame(Lab1= c("A", "B"), Lab2= c("C","D"),
                      Lab3=c("X", "Y"), Lab4=c(FALSE, TRUE))
newdata

predict(fit,newdata=newdata,type="prob")
# or
predict(fit,newdata=newdata,type="class") # getthe class








### If need to change the threshold

n = dim(data)[1]
set.seed(304)
test.index = sample(1:n, size = floor(0.2 * n)) 

train.set = data[-test.index,] 
test.set = data[test.index,] 


library("rpart")
library("rpart.plot")

cp_seq <- 10^seq(-6, -1, 1)
acc = numeric(6)
fpr = numeric(6)
tpr = numeric(6)

for (i in 1:6){
  fit <- rpart( response~lab1+lab2+lab3+lab4+lab5,
                method="class",
                data=train.set,
                control=rpart.control(cp = cp_seq[i]),
                parms=list(split='information')) 
  pred2_prob = predict(fit, newdata = test.set, type = "prob")[,2]
  pred2 = ifelse(pred2_prob >= 0.2, 1, 0)
  
  
  confusion_matrix <- table(test.set$response,pred2)
  acc[i]=mean(test.set$response == pred2) 
  FP <- confusion_matrix[1,2]
  TN <- confusion_matrix[1,1]
  fpr[i] <- FP / (FP + TN)
  TP <- confusion_matrix[2, 2]    
  FN <- confusion_matrix[2, 1]    
  tpr[i] <- TP / (TP + FN)
  
}
acc 
fpr 
tpr






### visualize (extra stuff for choosing best parameter)

cp <- cp_seq

# threshold = 0.2
acc_02 <- c(0.95630, 0.95630, 0.96365, 0.97220, 0.97220, 0.97220)
tpr_02 <- c(0.7573271, 0.7573271, 0.7438453, 0.6740914, 0.6740914, 0.6740914)
fpr_02 <- c(0.02514486, 0.02514486, 0.01585219, 0, 0, 0)

# threshold = 0.5
acc_05 <- c(0.96545, 0.96545, 0.96810, 0.97220, 0.97220, 0.97220)
tpr_05 <- c(0.7121923, 0.7121923, 0.6987104, 0.6740914, 0.6740914, 0.6740914)
fpr_05 <- c(0.010932546, 0.010932546, 0.006778179, 0, 0, 0)


### 1. ACC ###
plot(cp, acc_02, type="b", xlab="cp", ylab="Accuracy",main="Accuracy vs cp", col = "red")

lines(cp, acc_05, type="b", pch=17, lty=2, col = "blue")

legend("bottomright",
       legend=c("Threshold = 0.2", "Threshold = 0.5"),
       lty=c(1,2), pch=c(16,17))


### 2. TPR ###
plot(cp, tpr_02, type="b", pch=16, lty=1, xlab="cp", ylab="TPR", main="TPR vs cp", col = "red")

lines(cp, tpr_05, type="b", pch=17, lty=2 , col = "blue")

legend("bottomright",
       legend=c("0.2","0.5"),
       lty=c(1,2), pch=c(16,17),
       title="Threshold")

### 3. FPR ###
plot(cp, fpr_02, type="b", pch=16, lty=1, xlab="cp", ylab="FPR", main="FPR vs cp", col = "red")

lines(cp, fpr_05, type="b", pch=17, lty=2 , col = "blue")

legend("topright",
       legend=c("0.2","0.5"),
       lty=c(1,2), pch=c(16,17),
       title="Threshold")









### ROC curve and after cp is defined

library(ROCR)
score <- predict(fit, newdata = test.set, type = "prob")[,2]
pred <- prediction(score , test.set$diabetes)
perf <- performance(pred , "tpr", "fpr")
plot (perf, lwd =2) 
abline (a=0, b=1, col ="blue", lty =3)
auc <- performance(pred , "auc")@y.values[[1]]
auc 






###

# Entropy:  H=−∑pi*log(pi,base =2 )  ->  This number tells you how mixed the classes are in a node.
# Conditional Entropy:  H(Y|X)=∑P(Xi)* H(Y|Xi=xi) ->  (group size weight)×H(group) 

length(data$lab1)
table(data$lab1)


### Calculating conditional entropy when 'lab1' is splitted as
# as x1 = failure, other, unknown and x2 = success

x1=which(data$lab1!="success") # index of the rows where poutcome = x1
length(x1)

x2=which(data$lab2=="success") # index of the rows where poutcome = x2
length(x2) 

table(data$esponse[x1]) 
# counting how many "yes" and how many "no" for response among those with lab1 = x1
table(data$response[x2]) 
# counting how many "yes" and how many "no" for Subscribed among those with lab2 = x2







###  Example for n-folds and complex classes


iris = read.csv("iris.csv")
head(iris)

table(iris$class) # 3 categories, each class has 50 observations

"
So for 5-fold equal split between categories: 
Each category will have 10 in test and 40 in train in each fold. 

Steps: 
1) Randomly split 50 observations in each category into 2 parts: 
train (40) and test (10)

2) Combine 40 of setosa, versicolor, virginica to get full train set of 120.
Combine 10 of setosa, versicolor, virginica to get full test set of 30. 

3) Create decision tree model using train set (120). Apply tree to test set 
to get accuracy. 
"

n_folds = 5 

set.seed(888)

folds_1 <- sample(rep(1:n_folds, length.out = 50)) # for type 1 = setosa
folds_2 <- sample(rep(1:n_folds, length.out = 50)) # for type 2 = versicolor
folds_3 <- sample(rep(1:n_folds, length.out = 50)) # for type 3 = virginica

table(folds_1) # still equal split

# Coincidentally, in actual dataset, observations are sorted by "class"
data1 = iris[1:50,] # first 50 is setosa
data2 = iris[51:100,] # next is versicolor
data3 = iris[101:150,] # last 50 is virginica

# Alternative method  ( more general )
data1 = iris[iris$class == "Iris-setosa",]
data2 = iris[iris$class == "Iris-versicolor",]
data3 = iris[iris$class == "Iris-virginica",]


# to store the value of accuracy for each fold
acc = numeric(n_folds) 

for (j in 1:n_folds) {
  
  # get the 10 rows with indexes = j to put in the test set
  test1 <- which(folds_1 == j) 
  test2 <- which(folds_2 == j)
  test3 <- which(folds_3 == j) 
  
  # take the rest 40 to be train set
  train.1 = data1[-test1, ] 
  train.2 = data2[-test2, ] 
  train.3 = data3[-test3, ] 
  
  # Stacking them to make train set of 120 rows
  train = rbind(train.1, train.2, train.3)
  test = rbind(data1[test1,], data2[test2,], data3[test3,] )
  
  fit.iris <- rpart(class ~ ., # . means all features
                    method = "class", 
                    data = train, 
                    control = rpart.control(minsplit = 1),
                    parms = list(split ='information'))
  
  pred = predict(fit.iris, newdata = test[,1:4], type = 'class')
  confusion.matrix = table(test[,5],pred)
  
  acc[j] = sum(diag(confusion.matrix))/sum(confusion.matrix)
}

acc 
mean(acc)

# ( can add internal loop to find best control)
