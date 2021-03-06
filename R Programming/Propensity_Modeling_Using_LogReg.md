Logistic Regression
================
Matthew Carter

### Loading Packages

``` r
library(tidyverse)
library(caret)
library(pROC)
library(gains)
```

### Reading Cleaned Data

``` r
data5 <- read.csv("~/Google Drive/Industry Project 1/Data/data5.csv")
```

### Subsetting Down to Only Important Variables

The data subset includes the top 25 variables found as a result from the
random forest. Theses variables resulted in the largest decrease in the
gini coefficient when they were removed.

``` r
# Vector of important variable names
important_vars <- c("Event", "Seminar", "new_prod", "X.GTM", "demo", "users", 
                    "in_person", "ACADEMIC", "NETOPS", "BLANK_Title", "IT", 
                    "Digital.Asset", "lead_count1Two_Lead", "ARCHITECTS",
                    "Strata", "OTHER", "GENERIC", "lead_count1One_Lead", 
                    "lead_count1Three_Five_Lead", "Other", "Prisma", "EXECUTIVE",
                    "Cortex", "DATACENTER", "lead_count1Six_13_Lead")
# Subset of data
data <- data5[,c("g_won", important_vars)]

# Converting all variables to factors
data[, -1] <- data.frame(lapply(data[, -1], factor))
```

### Logistic Regression Using Training and Validation Sets

In order to confirm the logistic regression model is accurate, a
logistic regression model was run using a training data set and then
evaluated using a validation data set. The results showed the validation
set was performing well with an impressive decile chart.

``` r
# Data Partitioning
set.seed(1)
train.index <- createDataPartition(as.factor(data$g_won), p = 0.6, list = FALSE)
train.df <- data[train.index,]
valid.df <- data[-train.index,]

# Logistic Regression Model on Training Data
mylogit <- glm(as.factor(g_won) ~., data = train.df, family = "binomial")
#summary(mylogit)

# Predicted Values for Validation Data
valid.df$pred <- predict(mylogit, newdata = valid.df, type = "response")

# ROC curve
roc <- roc(as.factor(valid.df$g_won), valid.df$pred)
plot.roc(roc, xlim = c(1, 0))

# Area Under the Curve
auc(roc)


# Decile Table
## Ordering data by predicted values (highest to lowest)
valid.df <- data.frame(valid.df %>% arrange(desc(pred)))

## Binning predicted values into 10 quantiles
bins <- quantile(valid.df$pred, probs = seq(0, 1, by = 0.1))
valid.df$bin <- cut(valid.df$pred, breaks = bins, labels = as.character(1:10), include.lowest =  T, right = F)

## Calculating lift for each decile
total_won <-  sum(valid.df$g_won)
df <- data.frame(valid.df %>%
                   group_by(bin) %>%
                   summarise(lift = (sum(g_won)/total_won)/0.1))
df$bin <- c("100", "90", "80", "70", "60", "50", "40", "30", "20", "10")

## Resulting Decile Table
df
```

### Logistic Regression

After confirming the previous model performed well on the validation
data, a logistic regression model was run on the full data set.

``` r
# Logistic Regression Model
mylogit <- glm(as.factor(g_won) ~., data = data, family = "binomial")
#summary(mylogit)

# Predicted Values
data$pred <- predict(mylogit, newdata = data, type = "response")

# ROC curve
roc <- roc(as.factor(data$g_won), data$pred)
plot.roc(roc, xlim = c(1, 0))

# Area Under the Curve
auc(roc)

# Decile Table
## Ordering data by predicted values (highest to lowest)
data <- data.frame(data %>% arrange(desc(pred)))

## Binning predicted values into 10 quantiles
bins <- quantile(data$pred, probs = seq(0, 1, by = 0.1))
data$bin <- cut(data$pred, breaks = bins, labels = as.character(1:10), include.lowest =  T, right = F)

## Calculating lift and conversion rate for each decile
total_won <-  sum(data$g_won)
df <- data.frame(data %>%
  group_by(bin) %>%
  summarise(lift = (sum(g_won)/total_won)/0.1, conv_rate = sum(g_won)/total_won))
df$bin <- c("100", "90", "80", "70", "60", "50", "40", "30", "20", "10")

## Calculating cumulative conversion rate
df$conv_perc <- cumsum(df$conv_rate[10:1])[10:1]

df
```

### Describing the Top Decile

``` r
summary(data[which(data$bin == 10), ])
```
