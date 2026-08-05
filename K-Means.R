
setwd("C:/Users/Lenovo/Desktop/DSA/data")


data=read.csv("data.csv")
head(data)
dim(data)

table(data$response) 

set.seed(1)


plot(x=data$Lab1, y=data$Lab2,
     xlab="Lab1", ylab="Lab2", col="red")

kout <- kmeans(scale(data[ , c("Lab1","Lab2")] ), centers=2 , nstart = 50)# default nstart is too small, can cause bias

# nstarts -> Run K-means 50 times with different random starting points, then keep the best result.
# nstart is optional but it helps to stablize the output since the randomness
# is involved in the K-means algorithm when it starts to choose the initial centroid for each cluster.

# centers = 2 -> we want to separate all the flats into 2 groups/clusters
 

plot(data$Lab1, 
     data$Lab2, 
     col=kout$cluster) # R’s default palette (1, 2, 3, …)


kout$cluster # A vector of integers (from 1:k) indicating the cluster to which each point is allocated.

kout$centers # A matrix of cluster centres.

kout$size # The number of points in each cluster.

kout$withinss # Vector of SS_k, one value per cluster

kout$tot.withinss # Total within-cluster sum of squares = WSS


# PLOT TO SEE HOW WSS CHANGES WHEN K CHANGES

K = 10 # WE'LL TRY WITH k = 1, ...10.

wss <- numeric(K)

for (k in 1:K) { 
  wss[k] <- sum(kmeans(scale(data[,c("Lab1","Lab2")]),centers=k, nstart = 50)$withinss)
  # or 
  wss[k] <- kmeans(scale(data[,c("Lab1","Lab2")]),centers=k, nstart = 50 )$tot.withinss
}

plot(1:K, wss, col = "red", type="b", xlab="Number of Clusters",  ylab="Within Sum of Squares")


# nstart is optional but it helps to stablize the plot since the randomness 
# is involved in the K-means algorithm when it starts to choose the initial centroid for each cluster.






### Use the best k 

scaled_data <- scale(data)

kout = kmeans(scaled_data, 
              centers = 3,
              nstart = 20)

kout$centers

## Note: centroids here are still standardized
# EXTRA: to unstandardize
centers_unscaled = sweep(kout$centers, 
                         MARGIN = 2, 
                         attr(scaled_data, "scaled:scale"), "*")
centers_unscaled = sweep(centers_unscaled, 
                         MARGIN = 2, 
                         attr(scaled_data, "scaled:center"), "+")
centers_unscaled






### Example for more than 2 predictors

set.seed(1)
grade = read.csv("grades_km_input.csv")
head(grade)
dim(grade)


# VISUALIZE DATA SET BY FEATURES:
plot(grade[,2:4])
# generate A(2,3) = 6 plots
# PROPOSE: MIGHT BE 3 OR 4 GROUPS (first thought)


kout <- kmeans(grade[,c("English","Math","Science")],centers=3)


plot(grade$English, grade$Science, col=kout$cluster)
plot(grade$English, grade$Math, col=kout$cluster)
plot(grade$Math, grade$Science, col=kout$cluster)

kout$withinss

# PLOT WSS vs K TO PICK OPTIMAL K:

K = 15 
wss <- numeric(K)

for (k in 1:K) { 
  wss[k] <- sum(kmeans(grade[,c("English","Math","Science")], centers=k, nstart = 50)$withinss)
}


plot(1:K, wss, col = "blue", type="b", xlab="Number of Clusters",  ylab="Within Sum of Squares")

# this plot might change every time we run the for loop.
# hence, adding "nstart" into kmeans() inside for loop
# could help to stablize the plot.

# comments about the plot:
# WSS is greatly reduced when $k$ increases from 1 to 2. 
# Another substantial reduction in WSS occurs at $k = 3$.

# However, the improvement in WSS is fairly linear for $k > 3$.
# Therefore, the $k$-means analysis will be conducted for $k = 3$.

# The process of identifying the appropriate value of k is
# referred to as finding the ``elbow'' of the WSS curve


### with k= 4


kout <- kmeans(grade[,c("English","Math","Science")],centers=4)

plot(grade$English, grade$Science, col=kout$cluster)
plot(grade$English, grade$Math, col=kout$cluster)
plot(grade$Math, grade$Science, col=kout$cluster)

kout$withinss

# NOTE: IT IS USUALLY RECOMMENDED TO STANDARDIZE THE NUMERIC FEATURES BEFORE APPLYING THE ALGORITHM
# THIS IS BECAUSE THE ALGORITHM USES THE EUCLIDEAN DISTANCE BETWEEN POINTS







### Extra stuff with no reason

install.packages("GGally")
library(ggplot2)
library(GGally) # for pairs plots

# Transparent points (alpha = 0.2 means 20% opacity)
ggpairs(grade[,c("English","Math","Science")],
        lower = list(continuous = wrap("points", alpha = 0.2, size=1)))

