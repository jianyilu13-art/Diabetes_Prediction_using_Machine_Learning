# Basic R grammar

### C Functions
# creating a vector of numbers:
number<-c(2,4,6,8,10); number 

# creating a vector of strings/characters:
string<-c("weight", "height", "gender"); string 

# creating a Boolean vector (T/F):
logic<- c(T, T, F, F, T); logic


### FUNCTION numeric()

number.2<-numeric(3); number.2

### APPENDING TWO VECTORS
c(number, number.2)
append(number, number.2)


### FUNCTION rep()

# rep(a,b): replicate the item a by b times where a could be a number or a vectora
number.3<-rep(2,3); number.3
number.3<-rep(c(1,2),3); number.3
rep(string,2)


### FUNCTION seq()

seq(from=2, to=10, by=2)
seq(2,10,2)
seq(from=2, to=10, length = 5)
seq(10) # a sequence from 1 up to 10, distance by 1


### FUNCTION matrix()

v <- c(1:6); v

m <- matrix(v, nrow=2, ncol=3); m

#to fill the matrix by rows:
m <- matrix(v, nrow=2, ncol=3, byrow=T); m



### FUNCTION rbind()
a <- c(1,2,3,4)
b <- c(5,6,7,8)

ab_row <- rbind(a,b); ab_row

### FUNCTION cbind()

ab_col = cbind(a,b); ab_col



ab_col.try <- cbind(ab_row, c(9,10)); ab_col.try




### LIST IN R

list.1 <- list(10.5, 20, TRUE, "Daisy"); list.1

x = c(2,4,6,8) # length 4
y = c(T, F, T) # length 3

list.2 = list(A = x, B = y); list.2
# assign names to list members

list.2[1] # reference by index

list.2$A # reference by name

list.1[1] # this is NOT numeric

list.1[1]*2

list.1[[1]]*2



###### DATAFRAME IN R


## MANUALLY CREATE A DATA FRAME

height = c(1.6, 1.8, 1.7) # height of 3 people in meter
weight = c(46, 75, 68) # weight of them in kg

HW = data.frame(height, weight)
HW





## IMPORTING A FILE IN TO R AS A DATAFRAME

# setwd("C:/Data")

# setwd("~/Documents/Data")

data1<-read.csv("crab.txt", sep = "", header = FALSE) # this will include the header as first data row
data1[1:8,] #first 8 rows

names(data1) # names of columns 


data1<-read.csv("crab.txt",sep = "", header = TRUE)
data1[1:8,] #first 8 rows. The output is below.

varnames <- c("Subject", "Gender", "CA1", "CA2", "HW")
data2<-read.table("C:/Data/ex_1.txt", header = FALSE,
                  col.names = varnames)

data2

data3<-read.csv("~/Documents/Data/ex_1_comma.txt",sep = ",", header = FALSE)

setwd("~/Documents/Data")
data3<-read.table("ex_1_name.txt", header = TRUE)
data3


attach(data3) # it helps R to copy each column in "data3" into R's memory
CA1 

data3[,1] # first column

data3[,2:4] # all columns from 2 up to 4

data3[1:2,] # row 1 to row 2

data3[3,3] # value at 3rd row & 3rd column

data3[3,4] # value at 3rd row & 4th column

# all the rows (observations) whose gender = M:
data3[data3$Gender == "M",]

#all the rows (observations) whose gender = M and CA2>85
data3[data3$Gender == "M" & data3$CA2 > 85,]




#############  WHILE LOOP

x = 1
while(x<=3) {print("x is less than 4")
  x = x+1}


# Find the sum of first 10 integers:
x<-0; S<-0
while(x<=10) {S<- S+ x
x<-x+1}

S


#############  FOR LOOP

# Example: find the sum of first 10 integers
S<-0
for(i in 1:10){S <-S+i}
S

# Find the mean of vector x
x = c(2, 4, 3, 8, 10)
l = length(x)
S = 0
for (i in 1:l){S = S + x[i]}
ave = S/l; ave

#Find the sum of all even numbers from 1 up to 100.
x = c(1:100) 
S = 0
for (i in 1:length(x)){
  if(x[i]%%2 ==0){S = S + x[i]} else {S = S}
}
print(S)



#############  CONDITIONS WITH if()... else if()... else()

x = c(1:10); # a vector of numbers from 1 to 10
# we want to divide this vector into 3 subsets: 
# a set of all small numbers from 1 to 3
# a set of all medium numbers, from 4 to 7
# a set of large numbers from 8 to 10

S = numeric(0)
M = numeric(0)
L = numeric(0)
for (i in 1:length(x)){
  if (x[i] <=3){S = append(S, x[i])} else if (x[i]< 8)
  {M = append(M, x[i])} else {L = append(L, x[i])}
}
print(S)

print(M)

print(L)


### FUNCTION ifelse()

x = c(1:8);x
x = ifelse(x%%2 == 0, "even", "odd")
x




############  REPEAT LOOP # for self learning, not tested.

# EXAMPLE: print the first five integers
i <-1
repeat {
  print (i)
  if(i ==5) { break }
  i <- i+1
}

# Example: obtain the sum of first 5 integers
S = 0

i <-1
repeat {
  S <-S+i;
  if(i ==5) { break }
  i <- i+1
}
S







########### USER-DEFINED FUNCTION IN R


## STEP 1

find.sum = function( x ) { 
  s = sum(x)
  return(s)
}


y = c(1, 2, 10, 4, 6)

find.sum(y)



sum(vector)




find.sum(x = 10) # PARAMETER IS A NUMBER

find.sum(x = 1:10) # PARAMETER IS A VECTOR

find.sum(x = matrix(1:6, 2,3)) # PARAMETER IS A MATRIX

find.sum() # error # PARAMETER IS NOT GIVEN




# STEP 2: function with default value for parameter
find.sum = function(x = 1) { 
  s = sum(x)
  return(s)
}

find.sum(x = 10)

find.sum() # if parameter is not given, then the default value of it is used.



# STEP 3: function with many parameters
find.sum = function(x = 1, y) { 
  s = sum(x)
  
  return(s*y )
  
}

find.sum( x = 1:100, y = 2)

find.sum(y = 5)



# STEP 4: OUTPUT OF A FUNCTION IS A VECTOR, OR A DATAFRAME, OR A LIST.
# self exploring



#Function for finding odds ratio in general for a matrix x of 2x2:

OR<-function(x){
  if(any(x==0)) {x<-x+0.5}
  odds.ratio<-x[1,1]*x[2,2]/(x[2,1]*x[1,2])
  
  return(odds.ratio) }


table = matrix (1:4, 2,2)
OR(table) # apply function OR to the object "table".


# Can you form a function that help to find the number of even elements in a vector?
# the if condition is to avoid the case when the matrix x has value 0, called as "correction".



## table index 
# Step 1: Make raw data (to create a REAL 2-row table)
# We have 2 groups (Row1, Row2) and 3 categories (ColA, ColB, ColC)
set.seed(123)  # for same numbers
row_data <- c(rep("Row1", 7), rep("Row2", 18))  # 2 rows
col_data <- c(rep("ColA",4), rep("ColB",2), rep("ColC",1),  # Row1: 4,2,1
              rep("ColA",5), rep("ColB",6), rep("ColC",7))  # Row2:5,6,7

# Step 2: CREATE TABLE WITH table( ) <- THIS IS WHAT YOU WANT!
tbl <- table(row_data, col_data)
tbl

# col_data
# row_data ColA ColB ColC
# Row1    4    2    1
# Row2    5    6    7

# Keep columns where FIRST ROW < 3
tbl[, tbl[1, ] < 3]



data <- read.csv("file_needed.csv", header=TRUE)
dim(data)
head(data)

# drop 6 UNNECESSARY columns for the TRANNING DATA SET:
drops <- c("unwanted variables")






data <- data[,!(names(data) %in% drops )]

# ✔ Recommended
banktrain[, !(names(banktrain) %in% drops)]

# ✔ Equivalent
banktrain[, -which(names(banktrain) %in% drops)]

# ❌ Wrong (keeps instead of drops)
banktrain[, which(names(banktrain) %in% drops)]



banktrain <- banktrain[banktrain$job != "student", ]

banktrain <- banktrain[!(banktrain$job %in% c("student", "retired")), ]

banktrain <- banktrain[banktrain$age >= 18, ]

banktrain <- banktrain[!(banktrain$job == "student" & banktrain$age < 20), ]

banktrain <- banktrain[!(banktrain$job == "student" | banktrain$age < 20), ]




df <- read.table("file.txt", header = TRUE)




x = c(10, 20, 30, 40, 50)

x[1]        # first element → 10
x[2:4]      # 2nd to 4th → 20 30 40
x[c(1,3,5)] # specific positions → 10 30 50


x[-1]       # remove first → 20 30 40 50
x[-c(2,4)]  # remove 2nd & 4th → 10 30 50


x[x > 25]      # 30 40 50
x[x %% 2 == 0] # even numbers


x = c(a=10, b=20, c=30)

x["a"]     # 10
x[c("a","c")] # 10 30



m = matrix(1:9, nrow=3)

m[1,2]     # row 1, col 2
m[ ,2]     # entire column 2
m[1, ]     # entire row 1
m[1:2, 2:3]



m[,2]              # becomes vector
m[,2, drop=FALSE] # stays matrix


df[1, ]       # first row
df[, "age"]   # column "age"
df$age        # shortcut
df[1:3, c("age","name")]




df[df$age > 20, ]
df[df$gender == "M" & df$age > 20, ]


which(x > 25)   # returns indices
x[which(x > 25)]



x[is.na(x)]       # NA values
x[!is.na(x)]      # remove NA


x[seq(1,5,2)]     # 1,3,5
x[seq_along(x)]   # 1 to length(x)
x[seq_len(3)]     # 1,2,3




