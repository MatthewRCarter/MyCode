Centroid\_Cluster\_Undersampling
================
Matthew Carter

## Read/Prep In Data

``` r
library(randomForest)
library(tidyverse)

x <- read.csv("C:/Users/Matthew/Documents/School/Industry Project/data6.csv")

lead_count <- x %>%
   mutate(lead_count1 = case_when(lead_count == 1 ~ "One_Lead",
                                 lead_count == 2 ~ "Two_Lead",
                                 lead_count %in% c(3:5) ~ "Three_Five_Lead",
                                 lead_count %in% c(6:13) ~ "Six_13_Lead",
                                 lead_count > 13 ~ "VOlume_Lead"))
type <- as.data.frame(model.matrix(~ 0 + lead_count1, data = lead_count))

data <- cbind(x, type)
write.csv(data, "C:/Users/Matthew/Documents/School/Industry Project/data7.csv", row.names = T)
```

## Creating dataset for undersampling

``` r
data <- data[c(16, 20:34, 36:55, 57:79, 82:96)]
```

## Splitting into conversions and non-conversion dataframe

``` r
one_data <- data %>%
  filter(g_won == 1)

zero_data <- data %>%
  filter(g_won == 0)
```

## Clustering non-conversion data into 710 clusters for a 1:1 conversion:non-conversion ratio

``` r
zero_data1 <- zero_data[,2:74]
km.out1 <- kmeans(zero_data1, centers = 710, nstart = 20)

cluster_centroids1 <- data.frame(km.out1$centers)
cluster_centroids1$g_won <- 0
```

## Merging conversion data and clustered daat to complete centroid cluster undersampling

``` r
balanced_cc1 <- rbind(one_data, cluster_centroids1)
```

\#\#Train:test split

``` r
set.seed(1)
train_index1 <- sample(1:nrow(balanced_cc1), size = .7 * floor(nrow(balanced_cc1)))
train1 <- balanced_cc[train_index1,]
test1 <- balanced_cc[-train_index1,]
```

## Cross validating mtry for random forest

``` r
set.seed(1)

error_rates1 <- matrix(nrow = 21, ncol = 1)

for (i in 5:35) {
   rf <- randomForest(as.factor(g_won) ~. , data = train1, mtry = i, ntree = 100, importance = TRUE)
 
   CM <- rf$confusion
   n <- nrow(train)
   misclass <- CM[1,2] + CM[2,1]
   error_rates1[i] <- misclass / n
 }
 
plot(error_rates1)
```

## Using optimal mtry

``` r
set.seed(1)
rf1 <- randomForest(as.factor(g_won) ~ ., data = train1, mtry = 24, ntree = 500, importance = TRUE)
rf1

varImpPlot(rf1)

var_imp <- data.frame(rf1$importance)
setwd("C:/Users/Matthew/Documents/School/Industry Project/var_imp")
write.csv(var_imp, "var_imp_centroid_1_1.csv", row.names = T)
```

## Checking prediction accuracy

### The Random Forest was able to correctly classify 83% of conversions correctly

``` r
set.seed(1)

rf_pred1 <- predict(rf1, test1[,-1])

CM1 <- table(test1$g_won, rf_pred1)
true_negative_rate1 <- (CM1[1,1] / (CM1[1,2] + CM1[1,1]))
true_positive_rate1 <- (CM1[2,2] / (CM1[2,1] + CM1[2,2]))

CM1
paste("-------------")
paste0("Our true positive rate is ", round(true_positive_rate1*100, 2), "%")
paste0("Our true negative rate is ", round(true_negative_rate1*100, 2), "%")
paste0("Our accuracy rate is ", round(((CM1[1,1] + CM1[2,2]) / (CM1[2,1] + CM1[1,1] + CM1[1,2] + CM1[2,2]))*100, 2), "%")
```
