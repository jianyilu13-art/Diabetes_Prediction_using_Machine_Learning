setwd("C:/Users/Lenovo/Desktop/DSA/data")



data= read.csv("data.csv")

data<- data.frame(lapply(data, as.factor))
# go through every column in data and convert it to a factor

head(data)

drops <- c("unwanted variables")
data <- data[,!(names(data) %in% drops )]
dim(data)
head(data)

table(data$x1)
table(data$x2)
table(data$x3)





### Build the model

library(e1071)

model <- naiveBayes(reponse ~ x1+x2+x3, data = data)

newdata <- data.frame(x1=1,x2=1,x3=0)
newdata <- data.frame(lapply(newdata, as.factor))

results <- predict (model,newdata,"raw"); results
# A matrix of probabilities. One column per class

results <- predict (model,newdata,"class"); results
# default setting. Just the predicted label. 
# It simply picks the class with the highest probability







### If there are train set and test set:

set.seed(1)
index.train = sample(1:n, size = floor(0.8 * n)) 


train.set = data[index.train, ]
test.set  = data[-index.train , ] 


model <- naiveBayes( response ~ . , data = train.set)

nb_prediction <- predict(model, newdata = train.set[  , -11], type ='raw')

# IT'S RECOMMENDED TO TAKE OUT the response for the test set because the model was formed as: 
# response depends on all the rest columns: response ~.
# if we form the model where we do not use the dot but we specify the names of each regressor explicitly: x1, x2, x3..
# then we DO NOT NEED TO TAKE OUT the response in the test set in the function predict() above.



predicted.response = round(nb_prediction, digits = 3) 
# just rounding the probabilities to 3 decimal places

cbind(predicted.response, data[  ,"response_variable"])
# compare the predicted probability and the REAL RESPONSE






### PLOT ROC CURVE FOR THE NAIVE BAYES CLASSIFIER ABOVE:

#install.packages("ROCR") 
# https://cran.r-project.org/web/packages/ROCR/ROCR.pdf

library(ROCR)
score <- nb_prediction[, c("yes")] 
# score is the conditional PROBABILITY for Y= 1 from Naive Bayes classifier for each test point
# actual_class <- test.set$response == 'yes' 

pred <- prediction(score , data$response_variable) 
# this is to "format" the input so that we can use the function in ROCR to get TPR and FPR

perf <- performance(pred , "tpr", "fpr")
# perf is the S4 object of class "performance"
# It contains all the ROC information in different compartments (slots)
# which can be accessed by @

plot (perf, lwd =2) # lwd is to specify how thick the curve is
abline (a=0, b=1, col ="blue", lty =3)
# the straight blue line is just a reference line


# COMPUTE AUC FOR NAIVE BAYES CLASSIFIER:
auc <- performance(pred , "auc")@y.values[[1]]
auc  # area under the curve

# auc is used to compare between Naive Bayes method with other methods
# such as linear model, logistic model, DT, etc. 
# the one with larger auc value is better.


# VISUALIZE ON HOW THE THRESHOLD CHANGES WILL CHANGE TPR AND FPR:
# threshold is denoted as delta in the lecture slides of DSA1101,
# however, in R settings, it is named as "alpha.values"

threshold <- round (as.numeric(unlist(perf@alpha.values)) ,4) 
fpr <- round(as.numeric(unlist(perf@x.values)) ,4)
tpr <- round(as.numeric(unlist(perf@y.values)) ,4)

# adjust margins and plot TPR and FPR
par(mar = c(5 ,5 ,2 ,5))
# mar = a numerical vector of the form c(bottom, left, top, right) = c(5,4,4,2)
# http://127.0.0.1:14187/library/graphics/html/par.html

plot(threshold ,tpr , xlab ="Threshold", xlim =c(0 ,1) ,
     ylab = "True positive rate ", type ="l", col = "blue")
par( new ="True")
plot(threshold ,fpr , xlab ="", ylab ="", axes = FALSE, xlim =c(0 ,1) , type ="l", col = "red" )
axis(side =4) # to create an axis at the 4th side
mtext(side =4, line =3, "False positive rate")
text(0.4 ,0.05 , "FPR", col = "red")
text(0.6 ,0.35 , "TPR", col = "blue")

cbind(threshold, tpr, fpr) # for reference






### Examples for manually compute the Naive Bayes

titanic = read.csv("Titanic.csv")
# Response -> Survived(Yes/No)

class.prop = prop.table(table(titanic[,c("Survived", "Class")]), margin = 1)
class.prop

"
P(Class = 1st  | Survived = No)  = 0.08187919
P(Class = 2nd  | Survived = No)  = 0.11208054
P(Class = 3rd  | Survived = No)  = 0.35436242
P(Class = Crew | Survived = No)  = 0.45167785

P(Class = 1st  | Survived = Yes) = 0.28551336
P(Class = 2nd  | Survived = Yes) = 0.16596343
P(Class = 3rd  | Survived = Yes) = 0.25035162
P(Class = Crew | Survived = Yes) = 0.29817159
"

sex.prop = prop.table(table(titanic[,c("Survived", "Sex")]), margin = 1)
sex.prop

"
P(Sex = Female | Survived = No)  = 0.08456376
P(Sex = Male   | Survived = No)  = 0.91543624

P(Sex = Female | Survived = Yes) = 0.48382560
P(Sex = Male   | Survived = Yes) = 0.51617440
"


age.prop = prop.table(table(titanic[,c("Survived", "Age")]), margin = 1)
age.prop

"
P(Age = Adult | Survived = No)  = 0.96510067
P(Age = Child | Survived = No)  = 0.03489933

P(Age = Adult | Survived = Yes) = 0.91983122
P(Age = Child | Survived = Yes) = 0.08016878
"

# A 2nd class female adult is more likely to survive or not survive?


prob_surv <- surv.prop["Yes"] * (class.prop["Yes", "2nd"] * 
                                   sex.prop["Yes", "Female"] * 
                                   age.prop["Yes", "Adult"]) # 0.02385937


prob_no_surv <- surv.prop["No"] * (class.prop["No", "2nd"] * 
                                     sex.prop["No", "Female"] * 
                                     age.prop["No", "Adult"]) # 0.006192319 

prob_surv / prob_no_surv # Ratio: 3.853059 





### DO NOTE THAT:

# P(Y=Yi|X) = P(Y=Yi)*P(X|Y=Yi) / P(X)
# P(X)=P(Y=Yes)*P(X|Y=Yes) + P(Y=No)*P(X|Y=No)

p_yes = prob_surv / (prob_surv + prob_no_surv)
p_no  = prob_no_surv / (prob_surv + prob_no_surv)

#!!!!!!! Naive Bayes assumes:
# Features are conditionally independent given the class Y 
# P(X1,X2,...,Xp|Y)= ∏P(Xj|Y)




