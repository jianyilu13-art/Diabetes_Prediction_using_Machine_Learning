# LOGISTIC CURVE

z = seq ( -10 ,10 ,0.1); # z = linear predictor values (β0 + β1x + ...)
logistic = function (z) {exp(z)/(1+ exp(z))}
# logistic function: converts z → probability (0 to 1)

plot(z, logistic(z), xlab ="x", ylab ="p", lty =1, type ='l')
# plot probability vs z (S-shaped curve in logistic regression)





### Build the model

setwd("C:/Users/Lenovo/Desktop/DSA/data")

data = read.csv("churn.csv")
head(data)

dim(data)

# Logistic Regression: convert response to 0 and 1 !!!!!!
market$y = ifelse(market$Direction == "Up", 1, 0)
data$response = as.factor(data$response)

# Safe action:
levels(data1$Y)
data1$Y <- factor(data$Y, levels = c("0", "1")) # Default: the second one is success

data$x1 = as.factor(data$x1)
data= data[,-1] #Remove ID column


# attach(data)

table(data$response)
prop.table(table(data$response)) # compute the proportion


# LOGISTIC MODEL
M1<- glm( reponse ~., data = data,family = binomial)
summary(M1)
# if we don't specify "family = binomial", then a LINEAR model is formed, not logistic model


M2<- glm( Churned ~ x1 + x2 + x3,
          data = data,family = binomial(link ="logit"))
summary(M2)

M3<- glm( Churned ~x1 + x2,
          data = data,family = binomial(link ="logit"))
summary(M3)

pred = predict(M3, newdata = data.frame(x1 = 50, x2 = 5),type = 'response')
# type = 'response' means we want to get the Pr(Y = 1).
# type = c("link", "response", "terms")
# for glm(), when family = binomial, the default predictions are of log-odds (probabilities on logit scale) 
# and type = "response" gives the predicted probabilities for response Y = 1.
# "link" returns the log-odds prediction (default)

calss_pred = ifelse(pred >= threshold, 1,0)


# ROC CURVE FOR LOGISTIC MODEL

library(ROCR)
prob = predict(M3, type ="response") 
# It uses the training data used to fit M3 So prob = fitted probabilities on the training set

# type = c("link", "response", "terms"). 
# http://127.0.0.1:14187/library/stats/html/predict.glm.html

pred = prediction(prob , data$response ) 
roc = performance(pred , "tpr", "fpr")
auc = performance(pred , measure ="auc")
auc@y.values[[1]]
plot(roc , col = "red", main = paste(" Area under the curve :", round(auc@y.values[[1]] ,4)))



# HOW TPR, FPR CHANGE WHEN THRESHOLD CHANGES:

# extract the alpha(threshold), FPR , and TPR values from roc
alpha <- round (as.numeric(unlist(roc@alpha.values)) ,4)
length(alpha) 
fpr <- round(as.numeric(unlist(roc@x.values)) ,4)
tpr <- round(as.numeric(unlist(roc@y.values)) ,4)
# is not selecting a model. It is just extracting results from an existing ROC object.

# adjust margins and plot TPR and FPR
par(mar = c(5 ,5 ,2 ,5))

plot(alpha ,tpr , xlab ="Threshold", xlim =c(0 ,1) ,
     ylab = "True positive rate ", type ="l", col = "blue")
par( new ="True")
plot(alpha ,fpr , xlab ="", ylab ="", axes =F, xlim =c(0 ,1) , type ="l", col = "red" )
axis( side =4) # to create an axis at the 4th side
mtext(side =4, line =3, "False positive rate")
text(0.18 ,0.18 , "FPR", col = "red")
text(0.58 ,0.58 , "TPR", col = "blue")


cbind(alpha, tpr,fpr)


# there are some metrics that can help to choose a threshold: G-mean; Youden’s J statistic; etc







setwd("C:/Users/Lenovo/Desktop/DSA/data")

DATA = read.csv("DATA.csv")


n = dim(DATA)[1]
set.seed(304)
test.index = sample(1:n, size = floor(0.2 * n)) 

train.set = data[-test.index,] 
test.set = data[test.index,] 


M1<- glm( DATA ~., data = train.set,family = binomial)
summary(M1)

# use filter to get significant predictors
pvals <- summary(M1)$coefficients[,4]
pvals
sig_predictors <- pvals[pvals < 0.05]
sig_predictors


library(ROCR)
score <- predict(M1, newdata = test.set, type = "response")
pred <- prediction(score , test.set$diabetes)
perf <- performance(pred , "tpr", "fpr")
plot (perf, lwd =2) 
abline (a=0, b=1, col ="blue", lty =3)
auc <- performance(pred , "auc")@y.values[[1]]
auc 

threshold <- round (as.numeric(unlist(perf@alpha.values)) ,4) 
fpr <- round(as.numeric(unlist(perf@x.values)) ,4)
tpr <- round(as.numeric(unlist(perf@y.values)) ,4)

par(mar = c(5 ,5 ,2 ,5))

plot(threshold ,tpr , xlab ="Threshold", xlim =c(0 ,1) ,
     ylab = "True positive rate ", type ="l", col = "blue")
par( new ="True")
plot(threshold ,fpr , xlab ="", ylab ="", axes = FALSE, xlim =c(0 ,1) , type ="l", col = "red" )
axis(side =4) # to create an axis at the 4th side
mtext(side =4, line =3, "False positive rate")
text(0.4 ,0.05 , "FPR", col = "red")
text(0.6 ,0.35 , "TPR", col = "blue")

cbind(threshold, tpr, fpr) 



# Best threshold: 0.2
threshold = 0.2


pred1_prob = predict(M1, newdata = test.set,type = 'response')
pred1 = ifelse(pred1_prob >= threshold, 1,0)

confusion_matrix <- table(test.set$diabetes,pred1)
acc=mean(test.set$diabetes == pred1) 
FP <- confusion_matrix[1,2]
TN <- confusion_matrix[1,1]
fpr <- FP / (FP + TN)
TP <- confusion_matrix[2, 2]    
FN <- confusion_matrix[2, 1]    
tpr <- TP / (TP + FN)

acc 
fpr 
tpr 
auc 
