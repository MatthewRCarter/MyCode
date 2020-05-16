Shopping Campaign Cannibilization
================
Matt Carter
January 15, 2020

``` r
library(tidyverse)
```

    ## Warning: package 'tidyverse' was built under R version 3.6.1

    ## -- Attaching packages ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.2.1     v purrr   0.3.2
    ## v tibble  2.1.1     v dplyr   0.8.3
    ## v tidyr   0.8.3     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.4.0

    ## Warning: package 'ggplot2' was built under R version 3.6.2

    ## Warning: package 'dplyr' was built under R version 3.6.2

    ## -- Conflicts -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
data <- readxl::read_xlsx("C:/Users/Matthew/Documents/Pet_Doors/scc.xlsx")

relevant <- c("Shopping - Brand, Installation", "MMT - Shopping - General, Brand, Location")

data <- data %>%
  filter(campaign %in% relevant) %>%
  select(-campaigt_type) %>%
  mutate(week = week(day),
         month = month(day),
         year = year(day))
```

\#analyzing devices by campaign

``` r
shop1 <- data %>%
  filter(campaign == "Shopping - Brand, Installation") %>%
  group_by(device, day) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
```

    ## Warning: funs() is soft deprecated as of dplyr 0.8.0
    ## Please use a list of either functions or lambdas: 
    ## 
    ##   # Simple named list: 
    ##   list(mean = mean, median = median)
    ## 
    ##   # Auto named with `tibble::lst()`: 
    ##   tibble::lst(mean, median)
    ## 
    ##   # Using lambdas
    ##   list(~ mean(., trim = .2), ~ median(., na.rm = TRUE))
    ## This warning is displayed once per session.

``` r
ggplot(shop1, aes(x = day, y = clicks, color = device)) + geom_point()  + geom_smooth() + ggtitle("Shopping - Brand, Installation - Clicks")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
shop2 <- data %>%
  filter(campaign == "MMT - Shopping - General, Brand, Location") %>%
  group_by(device, day) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(shop2, aes(x = day, y = clicks, color = device)) + geom_point()  + geom_smooth()  + ggtitle("MMT - Shopping - General, Brand, Location - Clicks")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

``` r
all_shop <- data %>%
  group_by(device, day) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(all_shop, aes(x = day, y = clicks, color = device)) + geom_point()  + geom_smooth()  + ggtitle("Shopping Campaigns - Clicks")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-3-3.png)<!-- -->

\#analyzing campaigns by device (daily)

``` r
desktop <- data %>%
  filter(device == "Desktop") %>%
  group_by(campaign, day) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(desktop, aes(x = day, y = clicks, color = campaign)) + geom_point() + geom_smooth() + ggtitle("Desktop Clicks by Campaign")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
mobile <- data %>%
  filter(device == "Mobile") %>%
  group_by(campaign, day) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(mobile, aes(x = day, y = clicks, color = campaign)) + geom_point()  + geom_smooth() + ggtitle("Mobile Clicks by Campaign")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

``` r
tablet <- data %>%
  filter(device == "Tablet") %>%
  group_by(campaign, day) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(tablet, aes(x = day, y = clicks, color = campaign)) + geom_point() + geom_smooth() + ggtitle("Tablet Clicks by Campaign")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->
\#analyzing campaigns by device (weekly)

``` r
desktop1 <- data %>%
  filter(device == "Desktop") %>%
  group_by(campaign, week) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(desktop1, aes(x = week, y = clicks, color = campaign)) + geom_point() + geom_smooth() + ggtitle("Desktop Clicks by Campaign")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
mobile1 <- data %>%
  filter(device == "Mobile") %>%
  group_by(campaign, week) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(mobile1, aes(x = week, y = clicks, color = campaign)) + geom_point()  + geom_smooth() + ggtitle("Mobile Clicks by Campaign")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

``` r
tablet1 <- data %>%
  filter(device == "Tablet") %>%
  group_by(campaign, week) %>%
  summarise_at(vars(impressions, clicks, conversions, cost, conv_value), funs(sum))
ggplot(tablet1, aes(x = week, y = clicks, color = campaign)) + geom_point() + geom_smooth() + ggtitle("Tablet Clicks by Campaign")
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](Shopping-Campaign-Cannibilization_files/figure-gfm/unnamed-chunk-5-3.png)<!-- -->

``` r
click_spread <- readxl::read_xlsx("C:/Users/Matthew/Documents/Pet_Doors/shopping_click_spread.xlsx")

click_spread <- click_spread %>%
  mutate(hour_bin = case_when(HoD %in% c(23,0, 1, 2, 3) ~ "Early",
                              HoD %in% c(4, 5, 6, 7,15, 16, 17, 18, 19, 20, 21, 22) ~ "Late",
                              HoD %in% c(8, 9, 10, 11, 12, 13, 14) ~ "Midday"),
         day_bin = case_when(DoW %in% c("Monday", "Tuesday", "Wednesday", "Thursday") ~ 'Weekday',
                             DoW == "Friday" ~ "Friday",
                             DoW %in% c("Saturday", "Sunday") ~ "Weekend"))

click_spread <- click_spread %>%
  group_by(hour_bin, day_bin, device) %>%
  summarize_at(vars(impressions, clicks, conversions, conv_value, cost), funs(sum)) %>%
  mutate(cpc = cost / clicks,
         click_value = conv_value / clicks,
         ACoS = cost / conv_value) %>%
  arrange(desc(click_value))
```
