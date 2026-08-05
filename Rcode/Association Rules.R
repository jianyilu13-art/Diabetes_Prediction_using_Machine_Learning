setwd("C:/Users/Lenovo/Desktop/DSA/data")

library(arules)
library(arulesViz)

data(DATA) # dataset you need in the package
?DATA
summary(DATA) # rows->observations(elements/itemsets/transactions)  

inspect(head(DATA)) # the first 6 transactions
inspect(head(DATA, 10)) # the first 10 transactions

DATA@itemInfo[1:10,] # display items' labels

# @data  ->  cols->observations(elements/itemsets/transactions)  rows->items

DATA@data[1:10] # indicates which item labels appear in each transaction
DATA@data[,100:110] # a rows for a categories of items and 11 columns for 11 transactions


# the items for first 5 transactions:
apply(DATA@data[,1:5], 2,
      function(r) paste(DATA@itemInfo[r,"labels"], collapse=", "))

# the items for 100th to 105-th transactions:
apply(DATA@data[,100:105], 2,
      function(r) paste(DATA@itemInfo[r,"labels"], collapse=", "))

# 2 means: apply function column-wise
# r = one transaction (a vector of item indices)
# an anonymous function (no name)  Process: find item name -> combine them





###############  GETTING THE FREQUENT 1-ITEMSETS:

itemsets.1 <- apriori(DATA, parameter=list(minlen=1, maxlen=1,
                                                support=0.02, target="frequent itemsets"))
summary(itemsets.1)

# minlen = 1: frequent itemset has at least 1 item  can change to any other value
# maxlen = 1: frequent itemset has max = 1 item  can change to any other value


# list the most 10 frequent 1-itemsets:
inspect(head(sort(itemsets.1, by = "support"), 10))

# list all the 59 frequent 1-itemsets:
inspect(sort(itemsets.1, by ="support"))


## # IF THE PARAMETER MAXLEN is not specified, then....

itemsets<- apriori( DATA , parameter = list( minlen=1,
                                                  support =0.02 , target ="frequent itemsets"))
summary( itemsets )
inspect(sort( itemsets , by ="support")) 
# this will rank the itemsets by their support, regardless of itemsets with 1 item or 2 items.





###############  GETTING THE RULES instead of  FREQUENT ITEMSETS


rules <- apriori(DATA, parameter=list(support=0.001,
                                           confidence=0.6, target = "rules"))

plot(rules) # scatter plot of all rules that fit the conditions

# Scatter plot with customize-able measures and can add limiting the plot to the top 100 rules with the 
# largest value for the shading measure. 
plot(rules, measure = c("support", "confidence"), shading = "lift", limit = 100)#, col = "darkblue", limit = 100)



# PLOT SOME TOP RULES FOR VISUALZATION:

# the top 3 rules sorted by LIFT:
inspect(head(sort(rules, by="lift"), 3))

# the top 5 rules sorted by LIFT
inspect(head(sort(rules, by="lift"), 5))
highLiftRules <- head(sort(rules, by="lift"), 5)




########. PLOT THE TOP 5 RULES WITH HIGHEST LIFT FOR VISUALIZATION:

plot(highLiftRules, method="graph") # this is simple and a bit difficult to see the links

# more parameters added, plot looks better (easy for seeing the links):
plot(highLiftRules, method = "graph", engine = "igraph",
     edgeCol = "blue", alpha = 1)
# alpha = c(0,1) # nodes with color or not. 1 -> Fully opaque (no transparency at all)
# the size of the node/circle is sorted by the support.
# the darkness of the node's color represents the change in lift

'
plot(highLiftRules, method = "graph", engine = "igraph",
     nodeCol = "red", edgeCol = "blue", alpha = 1)
'
# this will fix the color be "red" for all lift values, 
# only the size of the node is sorted by the support.



# some common choices for 'method':
# matrix, mosaic, doubledecker, graph, paracoord, scatterplot, grouped matrix, two-key plot, matrix3D


# "
# library(arules)
# library(arulesViz)
# 
# # Top 5 rules by lift
# highLiftRules <- head(sort(rules, by="lift"), 5)
# 
# # Set: size = lift, shade = confidence
# plot(highLiftRules, 
#      method = "graph", 
#      engine = "igraph",
#      measure = "lift",       # node size → lift
#      shading = "confidence",# node shade → confidence
#      edgeCol = "blue", 
#      alpha = 1)"
# 

