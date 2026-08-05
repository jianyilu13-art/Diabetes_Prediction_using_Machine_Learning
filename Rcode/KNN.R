setwd("C:/Users/Lenovo/Desktop/DSA/data")

DATA = read.csv("DATA.csv")





### Summary the DATA
head(DATA)
dim(DATA)
nrow(DATA)

n = dim(DATA)[1]





### Preprocess the data

# select sample randomly 
set.seed(1)
index.train = sample(1:n, size = floor(0.8 * n)) 


train.data = data[index.train, ]
test.data  = data[-index.train , ] 

train.x = train.data[  ,c("Lag1","Lag2","Lag3","Lag4","Lag5")] 
test.x = test.data[  ,c("Lag1","Lag2","Lag3","Lag4","Lag5")] 

train.y = train.data[ ,c("Response")] 
test.y = test.data[ ,c("Response")]

train.x$Lag1 <- as.integer(factor(train.x$Lag1, levels = c("A", "B","C"))) 
test.x$Lag1 <- as.integer(factor(test.x$Lag1, levels = c("A", "B","C")))   
# Safely convert Lag1 to integer for TRAIN and TEST (fixed levels: A=1, B=2, C=3)

head(train.x)
head(test.x)

# standarlized
train.scaled <- scale(train.x)

train_mean <- attr(train.scaled, "scaled:center")
train_sd   <- attr(train.scaled, "scaled:scale")

test.scaled <- scale(test.x, center = train_mean, scale = train_sd)

head(train.scaled)
head(test.scaled)

# check
sum(is.na(train.scaled))
sum(is.na(test.scaled))
sum(is.na(train.set[,9]))

k_seq = seq(1,floor(sqrt(n)),2) # or ceiling( sqrt(n) )
# in k-NN, k is the main knob that controls the bias–variance trade-off
n_seq = length(k_seq)
acc = numeric(n)
fpr = numeric(n)
tpr = numeric(n)





### Build the model

# 1. If need to change threshold
threshold = 0.2

for (i in 1:n){
  pred_raw <- knn(train=train.scaled, test=test.scaled,
                   cl=train.y, k=k_seq[i], prob=TRUE)
  
  prob_attr <- attr(pred_raw, "prob")
  prob_pos <- ifelse(pred_raw == 1, prob_attr, 1 - prob_attr)
  
  pred <- ifelse(prob_pos > threshold, 1, 0)
  
  confusion_matrix <- table(test.y, pred) # pred is col
  
  acc[i] = mean(test.y == pred)
  
  FP <- confusion_matrix[1,2] # change according to order
  TN <- confusion_matrix[1,1]
  fpr[i] <- FP / (FP + TN)
  
  TP <- confusion_matrix[2,2]
  FN <- confusion_matrix[2,1]
  tpr[i] <- TP / (TP + FN)
}

acc
fpr
tpr



# 2. If no need to change threshold

for (i in 1:n){
  pred <- knn(train=train.scaled, test=test.scaled,
                  cl=train.y, k=k_seq[i]) # default threshold =0.5
  
  confusion_matrix <- table(test.y, pred) # pred is col
  
  acc[i] = mean(test.y == pred)
  # or sum(diag(confusion_matrix))/sum(confusion_matrix)
  
  FP <- confusion_matrix[1,2] # change according to order
  TN <- confusion_matrix[1,1]
  fpr[i] <- FP / (FP + TN)
  
  TP <- confusion_matrix[2,2]
  FN <- confusion_matrix[2,1]
  tpr[i] <- TP / (TP + FN)
}

acc
fpr
tpr





### N-folds algorithm

X=DATA[,c("Lag1","Lag2","Lag3","Lag4","Lag5")] # columns of explanatories/features
Y=DATA[,c("Response")] 

dim(DATA) # rows, cols
dim(DATA)[1] # rows

n_folds=5

set.seed(1) # This fixes the randomness
folds <- sample(rep(1:n_folds, length.out = dim(DATA)[1] ))  
# length.out = X means: keep repeating the sequence until you get exactly X elements

folds
table(folds)
# Use 10-fold cross-validation or Evaluate using cross-validation accuracy



# 1. Just 1 k value

acc=numeric(n_folds)
for (j in 1:n_folds) {
  test.index <- which(folds == j) # get the index of the points that will be in the test set
  pred <- knn(train=X[ -test.index, ], test=X[test.index, ], cl=Y[-test.index ], k=1) # KNN with k = 1, 5, 7, etc
  
  acc[j]=mean(Y[test.index] == pred) 
  # or acc[j] = sum(diag(confusion.matrix))/sum(confusion.matrix), where confusion.matrix=table(Y[test.index],pred)
  
}




# 2. Try different k values

k_values <- c(1, 3, 5, 7, 9, 11)

acc_matrix <- matrix(NA, nrow = length(k_values), ncol = n_folds)
rownames(acc_matrix) <- paste0("k_", k_values) # Label rows with k


for (k_idx in 1:length(k_values)) {
  
  current_k <- k_values[k_idx]
  for (j in 1:n_folds) {
    
    test.index <- which(folds == j)
    pred <- knn(
      train = X[-test.index, ], 
      test  = X[test.index, ], 
      cl    = Y[-test.index], 
      k     = current_k  
    )
    acc_matrix[k_idx, j] <- mean(Y[test.index] == pred)
  }
}


avg_acc <- rowMeans(acc_matrix)
cbind(k_values, avg_acc)







### Plot if needed

# k values used
k.values <- seq(3,11,2)

# Plot accuracy vs k
plot(k.values, accuracy,
     type = "b",          # both points and lines
     col = "blue",
     pch = 19,            # solid circle for points
     xlab = "k (number of neighbors)",
     ylab = "Accuracy",
     main = "KNN Accuracy vs k",
     ylim = c(0,1))       # ensure y-axis is 0-1 for accuracy



### Extra supplementary stuff

# change the alignment of table
confusion.matrix <- table(
  factor(test.y, levels = c("X","Y")),
  factor(pred, levels = c("A","B"))
)





### ROC and after k is defined

best_idx = 20
best_k = k_seq[20]

pred_raw <- knn(train=train.scaled, test=test.scaled, cl=train.y, k = best_k, prob=TRUE)
prob_attr <- attr(pred_raw, "prob")
prob_pos <- ifelse(pred_raw == 1, prob_attr, 1 - prob_attr)
pred <- ifelse(prob_pos > 0.2, 1, 0)

confusion_matrix <- table(test.set$diabetes, pred)

acc = mean(test.set$diabetes == pred)

FP <- confusion_matrix[1,2]
TN <- confusion_matrix[1,1]
fpr <- FP / (FP + TN)

TP <- confusion_matrix[2,2]
FN <- confusion_matrix[2,1]
tpr <- TP / (TP + FN)



library(ROCR)
score <- prob_pos <- ifelse(pred_raw == 1, prob_attr, 1 - prob_attr)
pred <- prediction(score , test.set$diabetes)
perf <- performance(pred , "tpr", "fpr")
plot (perf, lwd =2) 
abline (a=0, b=1, col ="blue", lty =3)
auc <- performance(pred , "auc")@y.values[[1]]
auc 





