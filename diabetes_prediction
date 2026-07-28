setwd("C:/Users/Lenovo/Desktop/DSA/data")

data = read.csv("diabetes-dataset.csv")
head(data)
dim(data)



# simplify smoking_history
table(data$smoking_history)
data$smoking_history = ifelse(data$smoking_history %in% c("ever","former"),"moderate",
                              ifelse(data$smoking_history == "current","high",
                                     ifelse(data$smoking_history %in% c("never","not current"),"none","no info")))
table(data$smoking_history)

# filter out no info
data1 = data[which(data$smoking_history != "no info"),]
prop.table(table(data1$smoking_history))
dim(data1)



########################### Part 1 ##################################

# summarize/describe the response variable
prop.table(table(data$diabetes))

# brief understanding of each variable
prop.table(table(data$gender)) # gender

# associations
# 1. For categorical variables:
tab1 = table(data$diabetes, data$gender)
tab2 = prop.table(tab1,2)
barplot(tab2, main="Diabetes by Gender")

tab3 = table(data$diabetes, data$hypertension)
tab4 = prop.table(tab3,2)
barplot(tab4, main="Diabetes by Hypertension")

tab5 = table(data$diabetes, data$heart_disease)
tab6 = prop.table(tab5,2)
barplot(tab6, main="Diabetes by heart disease")

tab7 = table(data1$diabetes, data1$smoking_history)
tab8 = prop.table(tab7,2)
barplot(tab8, main="Diabetes by smoking history")

# 2. For numerical variables 
boxplot(data$age ~ data$diabetes, main="Age by Diabetes Status", col = "pink")
mean(data$age[data$diabetes==0]) # 40.1
mean(data$age[data$diabetes==1]) # 60.9

boxplot(data$bmi ~ data$diabetes, main="BMI by Diabetes Status", col = "pink")
mean(data$bmi[data$diabetes==0]) # 26.9
mean(data$bmi[data$diabetes==1]) # 32.0

boxplot(data$HbA1c_level ~ data$diabetes, main="HbA1c Level by Diabetes Status", col = "pink")
mean(data$HbA1c_level[data$diabetes==0]) # 5.4
mean(data$HbA1c_level[data$diabetes==1]) # 6.9

boxplot(data$blood_glucose_level ~ data$diabetes, main="Blood Glucose Level by Diabetes ", col = "pink")
mean(data$blood_glucose_level[data$diabetes==0]) # 132.9
mean(data$blood_glucose_level[data$diabetes==1]) # 194.1



########################### Part 2 #################################


# separate the train set and test set
n = dim(data)[1]
set.seed(304)
test.index = sample(1:n, size = floor(0.2 * n)) 

train.set = data[-test.index,] 
test.set = data[test.index,] 



#GLM (LR)##############



M1<- glm( diabetes ~., data = train.set,family = binomial)
summary(M1)
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
auc # 0.9622

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

acc # 0.93875
fpr # 0.04509675
tpr # 0.7655334
auc # 0.9622




# DT ##################



library("rpart")
library("rpart.plot")

cp_seq <- 10^seq(-6, -1, 1)
acc = numeric(6)
fpr = numeric(6)
tpr = numeric(6)

for (i in 1:6){
fit <- rpart( diabetes~gender + age + hypertension + heart_disease + 
                smoking_history + bmi + HbA1c_level + blood_glucose_level,
                method="class",
                data=train.set,
                control=rpart.control(cp = cp_seq[i]),
                parms=list(split='information')) 
pred2_prob = predict(fit, newdata = test.set, type = "prob")[,2]
pred2 = ifelse(pred2_prob >= 0.2, 1, 0)


confusion_matrix <- table(test.set$diabetes,pred2)
acc[i]=mean(test.set$diabetes == pred2) 
FP <- confusion_matrix[1,2]
TN <- confusion_matrix[1,1]
fpr[i] <- FP / (FP + TN)
TP <- confusion_matrix[2, 2]    
FN <- confusion_matrix[2, 1]    
tpr[i] <- TP / (TP + FN)

}
acc # 0.95630 0.95630 0.96365 0.97220 0.97220 0.97220
fpr # 0.02514486 0.02514486 0.01585219 0.00000000 0.00000000 0.00000000
tpr # 0.7573271 0.7573271 0.7438453 0.6740914 0.6740914 0.6740914

# compare with default threshold
#acc (0.5) 0.96545 0.96545 0.96810 0.97220 0.97220 0.97220
#fpr (0.5) 0.010932546 0.010932546 0.006778179 0.000000000 0.000000000 0.000000000
#tpr (0.5) 0.7121923 0.7121923 0.6987104 0.6740914 0.6740914 0.6740914



# visualize

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



# Find out the best cp

best_cp = cp_seq[3]
fit <- rpart( diabetes~gender + age + hypertension + heart_disease + 
                smoking_history + bmi + HbA1c_level + blood_glucose_level,
              method="class",
              data=train.set,
              control=rpart.control(cp = best_cp),
              parms=list(split='information')) 
rpart.plot(fit, type=4, extra=2, varlen=0, faclen=0, clip.right.labs=FALSE)


library(ROCR)
score <- predict(fit, newdata = test.set, type = "prob")[,2]
pred <- prediction(score , test.set$diabetes)
perf <- performance(pred , "tpr", "fpr")
plot (perf, lwd =2) 
abline (a=0, b=1, col ="blue", lty =3)
auc <- performance(pred , "auc")@y.values[[1]]
auc 


acc # 0.96365
fpr # 0.01585219
tpr # 0.7438453 
auc # 0.9644453





# KNN ###############



library(class)

train.set = data[-test.index,] 
test.set = data[test.index,] 
train.set$gender <- as.integer(factor(train.set$gender, levels = c("Female", "Male","Other")))
train.set$smoking_history<- as.integer(factor(train.set$smoking_history, 
                                      levels = c("high", "moderate", "none", "no info")))
test.set$gender <- as.integer(factor(test.set$gender, levels = c("Female", "Male","Other")))
test.set$smoking_history<- as.integer(factor(test.set$smoking_history, 
                                              levels = c("high","moderate","none","no info")))
head(train.set)
head(test.set)

train.scaled <- scale(train.set[,-9])

train_mean <- attr(train.scaled, "scaled:center")
train_sd   <- attr(train.scaled, "scaled:scale")

test.scaled <- scale(test.set[,-9], center = train_mean, scale = train_sd)

head(train.scaled)
head(test.scaled)


sum(is.na(train.scaled))
sum(is.na(test.scaled))
sum(is.na(train.set[,9])) # check

k_seq = seq(1,401,2)
n = length(k_seq)
acc = numeric(n)
fpr = numeric(n)
tpr = numeric(n)


for (i in 1:n){
  pred3_raw <- knn(train=train.scaled, test=test.scaled,
               cl=train.set[,9], k=k_seq[i], prob=TRUE)
  
  prob_attr <- attr(pred3_raw, "prob")
  prob_pos <- ifelse(pred3_raw == 1, prob_attr, 1 - prob_attr)
  
  pred3 <- ifelse(prob_pos > 0.2, 1, 0)
  
  confusion_matrix <- table(test.set$diabetes, pred3)
  
  acc[i] = mean(test.set$diabetes == pred3)
  
  FP <- confusion_matrix[1,2]
  TN <- confusion_matrix[1,1]
  fpr[i] <- FP / (FP + TN)
  
  TP <- confusion_matrix[2,2]
  FN <- confusion_matrix[2,1]
  tpr[i] <- TP / (TP + FN)
}

acc
fpr
tpr

# Find best k by accuracy
best_idx = 20
best_k = k_seq[20]

pred3_raw <- knn(train=train.scaled, test=test.scaled, cl=train.set[,9], k = best_k, prob=TRUE)
prob_attr <- attr(pred3_raw, "prob")
prob_pos <- ifelse(pred3_raw == 1, prob_attr, 1 - prob_attr)
pred3 <- ifelse(prob_pos > 0.2, 1, 0)

confusion_matrix <- table(test.set$diabetes, pred3)

acc = mean(test.set$diabetes == pred3)

FP <- confusion_matrix[1,2]
TN <- confusion_matrix[1,1]
fpr <- FP / (FP + TN)

TP <- confusion_matrix[2,2]
FN <- confusion_matrix[2,1]
tpr <- TP / (TP + FN)

library(ROCR)
score <- prob_pos <- ifelse(pred3_raw == 1, prob_attr, 1 - prob_attr)
pred <- prediction(score , test.set$diabetes)
perf <- performance(pred , "tpr", "fpr")
plot (perf, lwd =2) 
abline (a=0, b=1, col ="blue", lty =3)
auc <- performance(pred , "auc")@y.values[[1]]
auc 


# 0.2

acc # 0.943
fpr # 0.043
tpr# 0.791
auc # 0.962

#acc (o.5) 0.961
#fpr (o.5) 0.001
#tpr (o.5) 0.560
#auc (0.5) 0.962






