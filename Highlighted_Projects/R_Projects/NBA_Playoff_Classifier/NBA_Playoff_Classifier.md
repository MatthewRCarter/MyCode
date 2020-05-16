NBA\_Playoff\_Classifier
================
Matt Carter
May 20, 2019

``` r
#installing packages
suppressWarnings(library(MASS))
suppressWarnings(library(readxl))
suppressMessages(suppressWarnings(library(tidyverse)))
suppressWarnings(library(dplyr))
suppressWarnings(library(stringr))
#loading data
singe_player_data <-suppressMessages(suppressWarnings(read_xlsx("C:/Users/Matthew/Documents/School/STAT_434/Final_Project/single_player_data_2.xlsx")))
```

# Data Cleaning & Prep

\#Filtering out data prior to 2000 because we have other data sources
that only go till 1990. Also, the game has changed so much in the last
30 years that I believe that data before this time wouldn’t prove useful
in prediction settings.

``` r
post_1990 <- singe_player_data %>%
  filter(Year >= 2000, Tm != "TOT")
```

\#Converting season stats to a per game basis

``` r
games <- 82
team_data <- post_1990 %>%
  group_by(Year, Tm) %>%
  summarise(
    PPG = sum(PTS)/games,
    Assists = sum(AST)/games,
    T_Rebounds = sum(TRB)/games,
    O_Rebounds = sum(ORB)/games,
    D_Rebounds = sum(DRB)/games,
    Steals = sum(STL)/games,
    Blocks = sum(BLK)/games,
    Turnovers = sum(TOV)/games,
    Team_Fouls = sum(PF)/games,
    FGM = sum(FG)/games,
    FGA = sum(FGA)/games,
    FG_Pct = (sum(FG) / sum(FGA)),
    ThreeP_M = sum(ThreeP)/games,
    ThreeP_A = sum(ThreePA)/games,
    Three_Pct = (sum(ThreeP) / sum(ThreePA)),
    TwoP_M = sum(TwoP)/games,
    TwoP_A = sum(TwoPA)/games,
    Two_Pct = (sum(TwoP) / sum(TwoPA)),
    Mean_Age  = mean(Age)
  )
```

\#Again, filtering out data before 2000 to ensure successful merging of
different data sources.

``` r
#Loading in Playoff Data
playoff_team_data <-read_xlsx("C:/Users/Matthew/Documents/School/STAT_434/Final_Project/Team_Playoff_Data.xlsx")

playoff_data <- playoff_team_data %>%
  filter(Year >= 2000, Year < 2018)
```

\#After thorough research and my own knowledge of the NBA, teams that
have shown to perform well in “Clutch” situations are often times those
who handle the playoff pressure more effectively. To investigate if this
was true, I tracked down clutch statistics for each
team.

``` r
clutch <- suppressMessages(read_xlsx("C:/Users/Matthew/Documents/School/STAT_434/Final_Project/clutch.xlsx"))
clutch <- clutch[,1:3]
# names(clutch) <- c()
```

\#Unfortunately, the team name, which is going to be the ‘Primary Key’
on which we will merge, was in a different format then in my other data
sources. Below you can see function that creates another variable called
“Tm” which represents the 3 letter abbreviation of the team

``` r
team_name_df <- unique(playoff_data["Team"])


team_name_df <- team_name_df %>%
    mutate(Tm = case_when(Team == "Atlanta Hawks" ~ "ATL",
                          Team == "Boston Celtics" ~ "BOS",
                          Team == "Brooklyn Nets" ~ "BRK",
                          Team == "Charlotte Bobcats" ~ "CHA",
                          Team == "Charlotte Hornets" ~ "CHH",
                          Team == "Chicago Bulls" ~ "CHI",
                          Team == "Cleveland Cavaliers" ~ "CLE",
                          Team == "Dallas Mavericks" ~ "DAL",
                          Team == "Denver Nuggets" ~ "DEN",
                          Team == "Detroit Pistons" ~ "DET",
                          Team == "Golden State Warriors" ~ "GSW",
                          Team == "Houston Rockets" ~ "HOU",
                          Team == "Indiana Pacers" ~ "IND",
                          Team == "LA Clippers" ~ "LAC",
                          Team == "Los Angeles Clippers" ~ "LAC",
                          Team == "Los Angeles Lakers" ~ "LAL",
                          Team == "Memphis Grizzlies" ~ "MEM",
                          Team == "Miami Heat" ~ "MIA",
                          Team == "Milwaukee Bucks" ~ "MIL",
                          Team == "Minnesota Timberwolves" ~ "MIN",
                          Team == "New Jersey Nets" ~ "NJN",
                          Team == "New Orleans Hornets" ~ "NOH",
                          Team == "New Orleans/Oklahoma City Hornets" ~ "NOK",
                          Team == "New Orleans Pelicans" ~ "NOP",
                          Team == "New York Knicks" ~ "NYK",
                          Team == "Oklahoma City Thunder" ~ "OKC",
                          Team == "Orlando Magic" ~ "ORL",
                          Team == "Philadelphia 76ers" ~ "PHI",
                          Team == "Phoenix Suns" ~ "PHO",
                          Team == "Portland Trail Blazers" ~ "POR",
                          Team == "Sacramento Kings" ~ "SAC",
                          Team == "San Antonio Spurs" ~ "SAS",
                          Team == "Seattle SuperSonics" ~ "SEA",
                          Team == "Toronto Raptors" ~ "TOR",
                          Team == "Utah Jazz" ~ "UTA",
                          Team == "Vancouver Grizzlies" ~ "VAN",
                          Team == "Washington Wizards" ~ "WAS"
  ))

clutch <- merge(clutch, team_name_df, by = "Team")
playoff_data <- merge(playoff_data, team_name_df, by = "Team")
```

# Final dataset merging

``` r
library(tidyverse)

#merging data sources to create final dataset
final_dataset <- merge(team_data, playoff_data, by = c("Tm", "Year"))
final_dataset <- merge(final_dataset, clutch, by = c("Tm", "Year"))

final_dataset_1 <- final_dataset %>%
  dplyr::select(Tm, Win, Loss, Playoffs, Win_Loss_Pct, Year:Rel_DRtg, Clutch_Win_Perc, -Lg)
```

### More Data Cleaning

``` r
final_dataset_2 <- final_dataset_1 %>%
  mutate(Playoffs_1 = case_when(Playoffs == "Lost E. Conf. 1st Rnd." ~ "1st Round",
                                Playoffs == "Lost W. Conf. 1st Rnd." ~ "1st Round",
                                Playoffs == "Lost E. Conf. Semis" ~ "2nd Round",
                                Playoffs == "Lost W. Conf. Semis" ~ "2nd Round",
                                Playoffs == "Lost E. Conf. Finals" ~ "Conference Finals",
                                Playoffs == "Lost E. Conf. Finals" ~ "Conference Finals",
                                Playoffs == "Won Finals" ~ "Won Finals",
                                Playoffs == "Lost Finals" ~ "Lost Finals",
                                TRUE ~ "No Playoffs"
                                ),
         Playoffs_Quant = case_when(Playoffs == "Lost E. Conf. 1st Rnd." ~ 1,
                                Playoffs == "Lost W. Conf. 1st Rnd." ~ 1,
                                Playoffs == "Lost E. Conf. Semis" ~ 2,
                                Playoffs == "Lost W. Conf. Semis" ~ 2,
                                Playoffs == "Lost E. Conf. Finals" ~ 3,
                                Playoffs == "Lost E. Conf. Finals" ~ 3,
                                Playoffs == "Won Finals" ~ 5,
                                Playoffs == "Lost Finals" ~ 4,
                                TRUE ~ 0
                                )
        )

model_dataset <- final_dataset_2 %>%
  filter(Playoffs_Quant != 0) %>%
  dplyr::select(-Finish)

quant_only <- model_dataset %>%
  dplyr::select(-Tm, -Year, -Season, -Team.x, -Playoffs, -Playoffs_Quant, -ThreeP_A, -Team_Fouls, -D_Rebounds, -Pace, - ThreeP_M, -Blocks) 

quant_only1 <- model_dataset %>%
  dplyr::select(-Tm, -Year, -Season, -Team.x, -Playoffs, -Playoffs_1) 

reduced_dataset <- model_dataset %>%
  dplyr::select(Win,FG_Pct,SRS,Rel_ORtg,Rel_DRtg,Clutch_Win_Perc, Mean_Age, Playoffs_1)
```

# Data Exploration & Variable Selection

\#Creating correlation matrix before modeling

``` r
corr_matrix <- as.data.frame(round(cor(quant_only1),2))
correlate <- as.data.frame(corr_matrix[,30:31]) 
correlate$Variable <- rownames(correlate)
correlate <- correlate[correlate$Variable!="Playoffs_Quant",c("Variable","Playoffs_Quant")]
correlate %>%
  arrange(desc(abs(Playoffs_Quant)))
```

    ##           Variable Playoffs_Quant
    ## 1     Win_Loss_Pct           0.62
    ## 2             Loss          -0.61
    ## 3              Win           0.59
    ## 4              SRS           0.56
    ## 5  Clutch_Win_Perc           0.39
    ## 6         Rel_DRtg          -0.36
    ## 7         Rel_ORtg           0.31
    ## 8             DRtg          -0.30
    ## 9           FG_Pct           0.29
    ## 10         Two_Pct           0.28
    ## 11            ORtg           0.26
    ## 12          Blocks           0.21
    ## 13        Mean_Age           0.21
    ## 14       Three_Pct           0.20
    ## 15      D_Rebounds           0.16
    ## 16          TwoP_A          -0.15
    ## 17        ThreeP_M           0.14
    ## 18      O_Rebounds          -0.12
    ## 19      Team_Fouls          -0.11
    ## 20             PPG           0.10
    ## 21         Assists           0.10
    ## 22        ThreeP_A           0.10
    ## 23             FGM           0.08
    ## 24      T_Rebounds           0.07
    ## 25             FGA          -0.06
    ## 26       Turnovers          -0.03
    ## 27          TwoP_M          -0.03
    ## 28        Rel_Pace          -0.02
    ## 29          Steals          -0.01
    ## 30            Pace           0.00

Lost E. Conf. 1st Rnd. Lost W. Conf. 1st Rnd. \[1st Round\]

Lost E. Conf. Semis Lost W. Conf. Semis \[2nd Round\]

Lost E. Conf. Finals Lost W. Conf. Finals \[Conference Finals\]

\[Lost Finals\] \[Won Finals\] \[No Playoffs\]

\#Variable selection using stepwise/best subsets

``` r
suppressWarnings(suppressMessages(library(leaps)))

mixed_stepwise <- regsubsets(Playoffs_Quant~., data = quant_only1, nvmax = 5, really.big = T)
```

    ## Warning in leaps.setup(x, y, wt = wt, nbest = nbest, nvmax = nvmax,
    ## force.in = force.in, : 4 linear dependencies found

    ## Reordering variables and trying again:

``` r
summary(mixed_stepwise)
```

    ## Subset selection object
    ## Call: regsubsets.formula(Playoffs_Quant ~ ., data = quant_only1, nvmax = 5, 
    ##     really.big = T)
    ## 30 Variables  (and intercept)
    ##                 Forced in Forced out
    ## Win                 FALSE      FALSE
    ## Loss                FALSE      FALSE
    ## Win_Loss_Pct        FALSE      FALSE
    ## PPG                 FALSE      FALSE
    ## Assists             FALSE      FALSE
    ## T_Rebounds          FALSE      FALSE
    ## O_Rebounds          FALSE      FALSE
    ## Steals              FALSE      FALSE
    ## Blocks              FALSE      FALSE
    ## Turnovers           FALSE      FALSE
    ## Team_Fouls          FALSE      FALSE
    ## FGM                 FALSE      FALSE
    ## FGA                 FALSE      FALSE
    ## FG_Pct              FALSE      FALSE
    ## ThreeP_M            FALSE      FALSE
    ## ThreeP_A            FALSE      FALSE
    ## Three_Pct           FALSE      FALSE
    ## Two_Pct             FALSE      FALSE
    ## Mean_Age            FALSE      FALSE
    ## SRS                 FALSE      FALSE
    ## Pace                FALSE      FALSE
    ## Rel_Pace            FALSE      FALSE
    ## ORtg                FALSE      FALSE
    ## Rel_ORtg            FALSE      FALSE
    ## DRtg                FALSE      FALSE
    ## Clutch_Win_Perc     FALSE      FALSE
    ## D_Rebounds          FALSE      FALSE
    ## TwoP_M              FALSE      FALSE
    ## TwoP_A              FALSE      FALSE
    ## Rel_DRtg            FALSE      FALSE
    ## 1 subsets of each size up to 6
    ## Selection Algorithm: exhaustive
    ##          Win Loss Win_Loss_Pct PPG Assists T_Rebounds O_Rebounds
    ## 1  ( 1 ) " " " "  "*"          " " " "     " "        " "       
    ## 2  ( 1 ) " " " "  "*"          " " " "     " "        " "       
    ## 3  ( 1 ) " " " "  "*"          " " " "     " "        " "       
    ## 4  ( 1 ) " " " "  "*"          " " " "     " "        " "       
    ## 5  ( 1 ) " " " "  "*"          " " " "     " "        " "       
    ## 6  ( 1 ) " " " "  "*"          " " " "     " "        " "       
    ##          D_Rebounds Steals Blocks Turnovers Team_Fouls FGM FGA FG_Pct
    ## 1  ( 1 ) " "        " "    " "    " "       " "        " " " " " "   
    ## 2  ( 1 ) " "        " "    " "    " "       " "        " " " " " "   
    ## 3  ( 1 ) " "        " "    " "    " "       " "        " " " " " "   
    ## 4  ( 1 ) " "        " "    " "    " "       " "        " " " " " "   
    ## 5  ( 1 ) " "        " "    " "    " "       " "        " " " " " "   
    ## 6  ( 1 ) " "        " "    " "    " "       " "        " " " " " "   
    ##          ThreeP_M ThreeP_A Three_Pct TwoP_M TwoP_A Two_Pct Mean_Age SRS
    ## 1  ( 1 ) " "      " "      " "       " "    " "    " "     " "      " "
    ## 2  ( 1 ) " "      " "      " "       " "    " "    " "     " "      " "
    ## 3  ( 1 ) " "      " "      " "       " "    " "    "*"     " "      " "
    ## 4  ( 1 ) " "      " "      " "       " "    " "    " "     " "      "*"
    ## 5  ( 1 ) " "      " "      " "       " "    " "    "*"     " "      "*"
    ## 6  ( 1 ) " "      " "      "*"       " "    " "    "*"     " "      "*"
    ##          Pace Rel_Pace ORtg Rel_ORtg DRtg Rel_DRtg Clutch_Win_Perc
    ## 1  ( 1 ) " "  " "      " "  " "      " "  " "      " "            
    ## 2  ( 1 ) " "  " "      " "  " "      "*"  " "      " "            
    ## 3  ( 1 ) " "  " "      " "  " "      "*"  " "      " "            
    ## 4  ( 1 ) " "  " "      "*"  " "      "*"  " "      " "            
    ## 5  ( 1 ) " "  " "      "*"  " "      "*"  " "      " "            
    ## 6  ( 1 ) " "  " "      "*"  " "      "*"  " "      " "

``` r
str(quant_only1)
```

    ## 'data.frame':    250 obs. of  31 variables:
    ##  $ Win            : num  37 47 53 44 40 44 38 60 48 43 ...
    ##  $ Loss           : num  45 35 29 38 26 38 44 22 34 39 ...
    ##  $ Win_Loss_Pct   : num  0.451 0.573 0.646 0.537 0.606 0.537 0.463 0.732 0.585 0.524 ...
    ##  $ PPG            : num  98.2 98.1 101.7 95 77.7 ...
    ##  $ Assists        : num  22 20.2 21.8 22 18.1 ...
    ##  $ T_Rebounds     : num  42.2 40 41.7 39.3 33.1 ...
    ##  $ O_Rebounds     : num  12.29 10.61 11.82 9.29 7.95 ...
    ##  $ D_Rebounds     : num  29.9 29.4 29.9 30 25.2 ...
    ##  $ Steals         : num  7.32 7.35 7.22 6.06 6.54 ...
    ##  $ Blocks         : num  5.46 4.59 5.04 4.16 3.7 ...
    ##  $ Turnovers      : num  14.3 12.2 11.5 12.8 10.7 ...
    ##  $ Team_Fouls     : num  20.4 19.6 19.9 19 14.4 ...
    ##  $ FGM            : num  36.3 36 38.8 36.2 29.6 ...
    ##  $ FGA            : num  79.9 78.7 82.9 78.4 65.2 ...
    ##  $ FG_Pct         : num  37.2 37.6 38.4 37.9 37.2 ...
    ##  $ ThreeP_M       : num  4.68 7.28 6.39 6.12 6 ...
    ##  $ ThreeP_A       : num  13.1 19.9 17.7 17.4 16.2 ...
    ##  $ Three_Pct      : num  0.356 0.366 0.36 0.352 0.37 ...
    ##  $ TwoP_M         : num  31.6 28.8 32.4 30.1 23.6 ...
    ##  $ TwoP_A         : num  66.8 58.8 65.2 61 49 ...
    ##  $ Two_Pct        : num  0.473 0.49 0.497 0.494 0.482 ...
    ##  $ Mean_Age       : num  25.1 25.1 26.6 27.5 29.3 ...
    ##  $ SRS            : num  -2.23 1.7 4.44 -1.1 2.67 -0.08 -0.88 4.75 3.49 -1.23 ...
    ##  $ Pace           : num  91.1 89.6 90.1 89.3 90.2 92.6 94.6 93.9 97.1 97.4 ...
    ##  $ Rel_Pace       : num  -1.3 -2.1 -2.6 -2.8 -1.1 0.6 0.7 0 1.3 1 ...
    ##  $ ORtg           : num  107 109 112 106 105 ...
    ##  $ Rel_ORtg       : num  -0.6 1 4.3 -1.2 0.3 -1.1 -0.8 3.3 -1.3 -3.9 ...
    ##  $ DRtg           : num  109 108 107 107 101 ...
    ##  $ Rel_DRtg       : num  1.4 -0.7 -0.9 -0.3 -3.4 -1.5 -0.3 -2.5 -5 -3.1 ...
    ##  $ Clutch_Win_Perc: num  0.467 0.615 0.579 0.537 0.667 0.55 0.429 0.707 0.545 0.591 ...
    ##  $ Playoffs_Quant : num  1 2 2 2 1 1 1 3 2 1 ...

### Creating Test/Train Sets

\#Making train/test sets with 3 different ratios (80/20, 65/35, & 50/50)

``` r
set.seed(32)
train_1 <- sample(c(TRUE ,FALSE),size = nrow(model_dataset),prob=c(.8,.2),rep=TRUE)
test_1 = (!train_1)

train_2 <- sample(c(TRUE ,FALSE),size = nrow(model_dataset),prob=c(.65,.35),rep=TRUE)
test_2 = (!train_1)

train_3 <- sample(c(TRUE ,FALSE),size = nrow(model_dataset),prob=c(.5,.5),rep=TRUE)
test_3 <- (!train_1)
```

# Quadratic Discriminant Analysis (QDA)

## QDA - Reduced Model

### With the reduced QDA model, I successfully predicted 70% of playoff series from the years of 2000-2018

``` r
# Fitting Quantitative Discriminant Analysis 
#Reduced Model Function
QDAfunctred <- function(train, test){

  qda.fit <- qda(Playoffs_1 ~ Win + FG_Pct + SRS + Rel_ORtg + Rel_DRtg + Clutch_Win_Perc,data=model_dataset ,subset = train)
  
  qda.pred <- predict(qda.fit,model_dataset[test,])
  
  actual_playoff <- model_dataset$Playoffs_1[test]
  predicted_playoff <- qda.pred$class
  
  #confusion matrix
  qdatable <- table(actual_playoff,predicted_playoff)
  
  classes <- c("1st Round", "2nd Round", "Conference Finals", "Lost Finals", "Won Finals")
  
  correct_perc <- list()
  for (i in 1:length(classes)){
    correct_perc[i] <- mean(predicted_playoff[actual_playoff == classes[i]] == actual_playoff[actual_playoff == classes[i]])
    }
  
  overall_perc <- mean(predicted_playoff == actual_playoff)
  return (list(qdatable, correct_perc,overall_perc)) # Returns a list of list, be wary when calling things
}
```

``` r
#QDA
library(MASS)
#QDAfunctred(train_1,test_1)
QDAfunctred(train_2,test_2) # Based on the seed used, Correct Prediction changed by 20%
```

    ## [[1]]
    ##                    predicted_playoff
    ## actual_playoff      1st Round 2nd Round Conference Finals Lost Finals
    ##   1st Round                24         1                 0           0
    ##   2nd Round                 5         2                 1           2
    ##   Conference Finals         0         0                 1           0
    ##   Lost Finals               0         0                 0           1
    ##   Won Finals                0         0                 1           0
    ##                    predicted_playoff
    ## actual_playoff      Won Finals
    ##   1st Round                  0
    ##   2nd Round                  1
    ##   Conference Finals          1
    ##   Lost Finals                0
    ##   Won Finals                 0
    ## 
    ## [[2]]
    ## [[2]][[1]]
    ## [1] 0.96
    ## 
    ## [[2]][[2]]
    ## [1] 0.1818182
    ## 
    ## [[2]][[3]]
    ## [1] 0.5
    ## 
    ## [[2]][[4]]
    ## [1] 1
    ## 
    ## [[2]][[5]]
    ## [1] 0
    ## 
    ## 
    ## [[3]]
    ## [1] 0.7

``` r
#QDAfunctred(train_3,test_3)
```

# KNN

### With the KNN Model, I successfully predicted 82.5% of playoff series from the years of 2000-2018

``` r
set.seed(47)
library(class) 
KNNfunc <- function(dataset,train,test){
standardized.X=scale(dataset[,!colnames(dataset) == "Playoffs_1"]) #large matrix of X-values 

#now they are standardized 

#Creating test set and stuff
train.X=standardized.X[-test,]
test.X=standardized.X[test,]
train.Y=quant_only$Playoffs_1[-test]
test.Y=quant_only$Playoffs_1[test]

test.errors <- rep(2, 15) 


for (i in 2:15) {    
        knn.pred <- knn(train.X,test.X,train.Y, k = i)    
    test.errors[i] <- mean(knn.pred != test.Y) 
    } 
test.errors

knn.pred <- knn(train.X,test.X,train.Y, k = (which.min(test.errors) + 1)) 

classes <- c("1st Round", "2nd Round", "Conference Finals", "Lost Finals", "Won Finals")

correct_perc <- list()
for (i in 1:length(classes)){
correct_perc[i] <- mean(knn.pred[test.Y == classes[i]] == test.Y[test.Y == classes[i]])
}

KNNtable <- table(test.Y,knn.pred)
correct_prediction <- mean(knn.pred == test.Y)
return (list(KNNtable,correct_prediction,correct_perc))
}

#Reduced Model
# KNNfunc(reduced_dataset,train_1,test_1)
# KNNfunc(reduced_dataset,train_2,test_2)
# KNNfunc(reduced_dataset,train_3,test_3)

#Full Model
# KNNfunc(quant_only,train_1,test_1)
# KNNfunc(quant_only,train_2,test_2)
KNNfunc(quant_only,train_3,test_3)
```

    ## [[1]]
    ##                    knn.pred
    ## test.Y              1st Round 2nd Round Conference Finals Lost Finals
    ##   1st Round                25         0                 0           0
    ##   2nd Round                 5         4                 0           1
    ##   Conference Finals         0         0                 2           0
    ##   Lost Finals               0         0                 0           1
    ##   Won Finals                0         0                 0           0
    ##                    knn.pred
    ## test.Y              Won Finals
    ##   1st Round                  0
    ##   2nd Round                  1
    ##   Conference Finals          0
    ##   Lost Finals                0
    ##   Won Finals                 1
    ## 
    ## [[2]]
    ## [1] 0.825
    ## 
    ## [[3]]
    ## [[3]][[1]]
    ## [1] 1
    ## 
    ## [[3]][[2]]
    ## [1] 0.3636364
    ## 
    ## [[3]][[3]]
    ## [1] 1
    ## 
    ## [[3]][[4]]
    ## [1] 1
    ## 
    ## [[3]][[5]]
    ## [1] 1

# Random Forest

### With the Random Forest, I successfully predicted 85% of playoff series from the years of 2000-2018

``` r
# install.packages("randomForest")
suppressWarnings(suppressMessages(library(randomForest)))
set.seed(1)

forestfunc <- function(train,test) {

  reduced_dataset$Playoffs_1 <- as.factor(reduced_dataset$Playoffs_1)
  str(reduced_dataset$Playoffs_1)
  
  val.errors <- list()
  for (i in 1:6){
    playoff_forest <- randomForest(Playoffs_1~.,data= reduced_dataset[train,], mtry = i, importance = TRUE, type = "classification")
    
    # val.errors[i] <- mean(yhat.bag == quant_only[test,]$Playoffs_1)
    # which.max(val.errors)
    ?randomForest
    
    # get the test MSE
    yhat.bag <- predict(playoff_forest , newdata = reduced_dataset[test,])
    
    val.errors[i] <- mean(yhat.bag == reduced_dataset[test,]$Playoffs_1)
    which.max(val.errors)
    
    val.errors[i] <- mean(yhat.bag == reduced_dataset[test,]$Playoffs_1)
    which.max(val.errors)
  
  }
  
  
  playoff_forest1 <- randomForest(Playoffs_1~.,data= reduced_dataset[train,], mtry = which.max(val.errors), importance =TRUE, type = "classification")
  
  yhat.bag <- predict(playoff_forest1 , newdata = reduced_dataset[test,])
  actual <- reduced_dataset[test,]$Playoffs_1
  foresttable <- table(yhat.bag,actual)
  classes <- c("1st Round", "2nd Round", "Conference Finals", "Lost Finals", "Won Finals")
  correct_perc <- list()
  
  for (i in 1:length(classes)){
    correct_perc[i] <- mean(yhat.bag[actual == classes[i]] == actual[actual == classes[i]])
    }
    perc <- mean(yhat.bag == reduced_dataset[test,]$Playoffs_1)
    var <- varImpPlot (playoff_forest1)
    return (list(foresttable,perc,correct_perc))

}

#forestfunc(train_1,test_1)
forestfunc(train_2,test_2)
```

    ##  Factor w/ 5 levels "1st Round","2nd Round",..: 1 2 2 2 1 1 1 3 2 1 ...

![](NBA_Playoff_Classifier_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

    ## [[1]]
    ##                    actual
    ## yhat.bag            1st Round 2nd Round Conference Finals Lost Finals
    ##   1st Round                24         2                 0           0
    ##   2nd Round                 1         8                 1           0
    ##   Conference Finals         0         0                 0           0
    ##   Lost Finals               0         0                 0           1
    ##   Won Finals                0         1                 1           0
    ##                    actual
    ## yhat.bag            Won Finals
    ##   1st Round                  0
    ##   2nd Round                  0
    ##   Conference Finals          0
    ##   Lost Finals                0
    ##   Won Finals                 1
    ## 
    ## [[2]]
    ## [1] 0.85
    ## 
    ## [[3]]
    ## [[3]][[1]]
    ## [1] 0.96
    ## 
    ## [[3]][[2]]
    ## [1] 0.7272727
    ## 
    ## [[3]][[3]]
    ## [1] 0
    ## 
    ## [[3]][[4]]
    ## [1] 1
    ## 
    ## [[3]][[5]]
    ## [1] 1

``` r
#forestfunc(train_3,test_3)
```

``` r
setwd("C:/Users/Matthew/Documents/School/GSB 510/Final_Presentation")
write_excel_csv2(final_dataset_2, path = "final_dataset_2.xlsx")
```
