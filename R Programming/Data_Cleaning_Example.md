Data Cleaning and Preparation
================
Matthew Carter

### Loading Tidyverse Package

``` r
library(tidyverse)
```

### Reading Raw Data

``` r
data <- read.csv("~/Google Drive/Industry Project 1/Data/calpoly_segmentation_data.csv")
```

### Removing Duplicate Rows

A total of 45,598 duplicate rows were removed. There were 37,284 full
duplicates and 8,314 were partial duplicates where all but the
person\_id was the same.

``` r
# Removing Full Duplicates
data2 <- data[!duplicated(data), ]
# Removing Partial Duplicates (same values for all columns except person_id)
data2 <- data2[!duplicated(data2[, -1]), ]
```

### Filling in Missing Titles for Repeat Leads

Some repeat leads had a title for at least one record (observation)
while other records had missing titles. Thus, we filled in the missing
titles with the corresponding lead’s title. This step was completed
before removing rows with all NA values in the funnel stages in order to
squeeze as much information out of those rows as possible before
removing them.

There were a total of 59,730 titles that were NA or blank. Of those, 135
titles were filled
in.

``` r
# Creating 2 Data Frames: (1) with missing titles, (2) without missing titles
not_na <- data2[!is.na(data2$title) & data2$title != "", ]
na <- data2[is.na(data2$title) | data2$title == "", ]

# Merging rows from "not_na" data frame with "na" data frame that have matching person ID (126 rows)
data_match <- inner_join(not_na, na, by = "person_id")

# Selecting columns with "non_na" title 
data_match <- data_match %>%
  select(person_id, title.x, person_title_segment.x)

# Removing duplicate rows (55 rows not duplicates)
data_match <- data_match[!duplicated(data_match),]

# Merging missing titles for matching person ID in the "na" data frame
na <- left_join(na, data_match, by = "person_id")

# Filling in missing titles for matching person ID in the "na" data frame
na <- na %>%
  mutate(title = case_when(is.na(title) == TRUE & is.na(title.x) == FALSE ~ title.x, TRUE ~ person_title_segment),
         person_title_segment = case_when(is.na(person_title_segment) == TRUE & is.na(person_title_segment.x) == FALSE 
                                          ~ person_title_segment.x, TRUE ~ person_title_segment)) %>%
  select(-title.x, -person_title_segment.x)

# Filling in missing titles for matching person ID in the original data frame
data2 <- rbind(not_na, na)
```

### Removing Rows with NA’s for All Funnel Stages

A total of 24,558 rows were removed during this process.

``` r
data2 <- data2 %>% 
  filter(!(is.na(a_responder) & is.na(b_aql) & is.na(c_tal) & is.na(d_tql) & is.na(e_sal) & is.na(f_sql)))
```

### Creating Grouped GTM Variable with 4 Levels: Prisma, Cortex, Strata, X-GTM

In order allow insights regarding GTM at a broader level, a grouped GTM
variables was
created.

``` r
# Creating New Variable for Grouped GTM Identical to Original GTM Variable
data2$campaign_member_gtm_4 <- data2$campaign_member_gtm
# Assigning Variable Equal to Levels of GTM Variable
gtm_levels <- levels(data2$campaign_member_gtm_4)
# Identifying indices of levels variable in which level name contains "Prisma" to be Prisma group
prisma_indices <- which(str_detect(gtm_levels, "Prisma"))
# Identifying indices of levels variable in which level name contains "Cortex" to be Cortex group
cortex_indices <- which(str_detect(gtm_levels, "Cortex"))
# Identifying indices of levels variable in which level name contains "Network" to be Strata group
strata_indices <- which(str_detect(gtm_levels, "Network"))
# Identifying indices of levels variable in which level name contains "X-GTM or "CXO" to be X-GTM group
X_indices <- which(str_detect(gtm_levels, "X-GTM") | str_detect(gtm_levels, "CXO"))
# Identifying indices of levels variable in which level name is NA to be NA group
NA_indices <- which(gtm_levels == "")
# Indices of GTM levels in order of Prisma, Cortex, Strata, and X-GTM
indices <- c(prisma_indices, cortex_indices, strata_indices, X_indices, NA_indices)
# Re-assigning levels variable to be grouped into Prisma, Cortex, Strata, and X-GTM
levels(data2$campaign_member_gtm_4)[indices] <- c(rep("Prisma", length(prisma_indices)), 
                                                 rep("Cortex", length(cortex_indices)),
                                                 rep("Strata", length(strata_indices)),
                                                 rep("X-GTM", length(X_indices)),
                                                 rep(NA, length(NA_indices)))
```

### Rolling Up Campaign Types

There are some campaign types that have very few observations or clearly
belong to an existing campaign type. Thus, we rolled up the campaign
types into a more meaningful campaign type
variable.

``` r
# Creating New Variable for Grouped Campaign Type Identical to Original Campaign Type Variable
data2$campaign_type2 <- data2$campaign_type
# New Groupings
digital_asset <- c("Digital Asset", "Website", "Marketplace")
event <- c("Event", "Program", "In-person Events", "Executive Event", "Global Campaign")
sales_request <- c("Sales Request", "Contact Me Now", "Referral Program")
# Assigning New Groups to New Campaign Type Variable
data2$campaign_type2[which(data2$campaign_type2 %in% digital_asset)] <- "Digital Asset"
data2$campaign_type2[which(data2$campaign_type2 %in% event)] <- "Event"
data2$campaign_type2[which(data2$campaign_type2 %in% sales_request)] <- "Sales Request"
```

### Fixing Titles with Question Marks

Due to an error during the exporting process by Palo Alto Networks, some
characters for the title variable were converted to questions marks. All
titles that only included question marks were nullified as requested by
Palo Alto Networks. A total of 9,623 titles were nullified during this
process.

``` r
# Assigning replacing all ?'s to blank
data2$title <- gsub("\\?", "", data2$title)

# Assigning NA value to all blank titles
data2$title[which(data2$title == "")] <- NA

# Creating variable with row numbers for later use
data2$row <- 1:nrow(data2)

# Writing New Data to csv
#write.csv(data2, "~/Google Drive/Industry Project 1/Data/data2.csv", row.names = F)
```

### Reading Data that was Cleaned in Python

Due to some limitations in R, all non-ascii and non-alphabetical
characters in the title variable were removed in
Python.

``` r
data3 <- read.csv("~/Google Drive/Industry Project 1/Data/data_python.csv")
data3 <- data3[, -c(1,2)] # removing unwanted columns
```

### Replacing all white space with a single space

``` r
data3$title <- trimws(gsub("\\s+", " ", data3$title ))
```

### Reassigning Other and Generic Title Segments for Titles with Matching Titles in the Remaining 10 Title Segments

We noticed that some titles that currently belong to the OTHER and
GENERIC title segments are identical to titles belonging to the
remaining 10 title segments. Consequently, we reassigned the title
segments of those titles to belong to the more meaningful title segments
rather than OTHER and GENERIC.

``` r
# Initializing new title segment variable
data3$person_title_segment2 <- NA

# Creating vectors with titles (with all white space removed) belonging to original title segments
NETOPS_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "NETOPS")])
IT_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "IT")])
ARCHITECTS_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "ARCHITECTS")])
EXECUTIVE_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "EXECUTIVE")])
SECOPS_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "SECOPS")])
DATACENTER_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "DATACENTER")])
PUBLIC_CLOUD_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "PUBLIC CLOUD")])
RISK_COMPLIANCE_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "RISK AND COMPLIANCE")])
DESKTOP_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "DESKTOP")])
SAAS_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "SAAS SECURITY")])
GENERIC_titles <- gsub("\\s+", "", data3$title[which(data3$person_title_segment == "GENERIC")])

# Creating 2 data frames for Other and Generic title segments, respectively
OTHER <- data3[which(data3$person_title_segment == "OTHER"), c("title", "person_title_segment", "row")]
OTHER$title <- gsub("\\s+", "", OTHER$title)
GENERIC <- data3[which(data3$person_title_segment == "GENERIC"), c("title", "person_title_segment", "row")]
GENERIC$title <- gsub("\\s+", "", GENERIC$title)

# Reassigning OTHER title segments to appropriate title segment
for (i in 1:nrow(OTHER)) {
  if (OTHER$title[i] %in% ARCHITECTS_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "ARCHITECTS"
  } else if (OTHER$title[i] %in% RISK_COMPLIANCE_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "RISK AND COMPLIANCE"
  } else if (OTHER$title[i] %in% DATACENTER_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "DATACENTER"
  } else if (OTHER$title[i] %in% EXECUTIVE_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "EXECUTIVE"
  } else if (OTHER$title[i] %in% SAAS_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "SAAS SECURITY"
  } else if (OTHER$title[i] %in% DESKTOP_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "DESKTOP"
  } else if (OTHER$title[i] %in% PUBLIC_CLOUD_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "PUBLIC CLOUD"
  } else if (OTHER$title[i] %in% NETOPS_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "NETOPS"
  } else if (OTHER$title[i] %in% SECOPS_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "SECOPS"
  } else if (OTHER$title[i] %in% IT_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "IT"
  } else if (OTHER$title[i] %in% GENERIC_titles) {
    data3$person_title_segment2[data3$row == OTHER$row[i]] <- "GENERIC"
  }
}

# Reassigning GENERIC title segments to appropriate title segment
for (i in 1:nrow(GENERIC)) {
  if (GENERIC$title[i] %in% ARCHITECTS_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "ARCHITECTS"
  } else if (GENERIC$title[i] %in% RISK_COMPLIANCE_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "RISK AND COMPLIANCE"
  } else if (GENERIC$title[i] %in% DATACENTER_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "DATACENTER"
  } else if (GENERIC$title[i] %in% EXECUTIVE_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "EXECUTIVE"
  } else if (GENERIC$title[i] %in% SAAS_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "SAAS SECURITY"
  } else if (GENERIC$title[i] %in% DESKTOP_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "DESKTOP"
  } else if (GENERIC$title[i] %in% PUBLIC_CLOUD_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "PUBLIC CLOUD"
  } else if (GENERIC$title[i] %in% NETOPS_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "NETOPS"
  } else if (GENERIC$title[i] %in% SECOPS_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "SECOPS"
  } else if (GENERIC$title[i] %in% IT_titles) {
    data3$person_title_segment2[data3$row == GENERIC$row[i]] <- "IT"
  } 
}

# Filling in remainder of new title segment variable with original title segments
data3$person_title_segment2[which(is.na(data3$person_title_segment2))] <- 
  data3$person_title_segment[which(is.na(data3$person_title_segment2))]
```

### Creating New Indicator Variables

New indicator variables were created in order to consider possibly more
meaningful groupings of title segment and activity. For activity
(campaign sub-type), indicators for research campaigns, third party
campaigns, demo campaigns, partner events, in-person events, and passive
campaigns (i.e. minimal active efforts required). Additionally, an
indicator for title segments who are most likely to manage and/or
interact with the products once purchased (i.e. NETOPS, SECOPS, IT,
ARCHITECTS) was created. Lastly, an indicator for incomplete/poor
performing products was
created.

``` r
# Vectors containing names of campaign sub-types belonging to specific indicator variable
research <- c("Research-Unit42", "Research-3rd Party", "Analyst Report", "White Paper", "eBook", "Info & Insights")
third_party <- c("Content Syndication", "Research-3rd Party")
demo <- c("Demo", "Free Trial", "Ultimate Test Drive - Partner", "Ultimate Test Drive <U+0096> (Virtual)", "Ultimate Test Drive (In Person)")
partner <- c("Partner Event", "Ultimate Test Drive - Partner")
in_person <- c("Seminar", "In-Person", "Partner Event", "Demo", "Ultimate Test Drive (In Person)", "Ultimate Test Drive - Partner", "Cyber Range")
passive <- c("Analyst Report", "White Paper", "eBook", "Datasheet", "Video", "Infographic" , "Tech & Solution Brief", "Web Contact Us Forms" , "Info & Insights")
users <- c("NETOPS", "SECOPS", "IT", "ARCHITECTS")
incomplete_prod <- c("Prisma Twistlock", "Prisma SaaS", "Prisma VM Private", "Prisma VM Public")

# Adding new indicator variables to data
data3$research <- as.factor(as.numeric(data3$campaign_sub_type %in% research))
data3$third_party <- as.factor(as.numeric(data3$campaign_sub_type %in% third_party))
data3$demo <- as.factor(as.numeric(data3$campaign_sub_type %in% demo))
data3$partner <- as.factor(as.numeric(data3$campaign_sub_type %in% partner))
data3$in_person <- as.factor(as.numeric(data3$campaign_sub_type %in% in_person))
data3$users <- as.factor(as.numeric(data3$person_title_segment2 %in% users))
data3$incomplete_prod <- as.factor(as.numeric(data3$campaign_member_gtm %in% incomplete_prod))
```

### Creating Repeat Lead Variables

In order to later analyze the effect of repeat leads in the data, a few
variables were created. First, a lead count variable was created to
represent the number of times a lead appears in the data. Additionally,
a categorical variable was created to bin the lead count. Lastly, a lead
counter variable was created to represent the instance that lead
appeared corresponding to the activity date.

``` r
# Table of leads and the number of times each lead appeared in the data
people_counts <- data.frame(data3 %>%
  group_by(person_id) %>%
  select(person_id) %>%
  summarise(lead_count = length(person_id)) %>%
  arrange(desc(lead_count)))

# Creating lead count variable
data3 <- merge(data3, people_counts, by = "person_id", all.x = T)

# Creating binned categorical variable for lead count
lead_count_cat <- data3 %>%
  mutate(lead_count_cat = case_when(lead_count == 1 ~ "One_Lead",
                                 lead_count == 2 ~ "Two_Lead",
                                 lead_count %in% c(3:5) ~ "Three_Five_Lead",
                                 lead_count %in% c(6:13) ~ "Six_13_Lead",
                                 lead_count > 13 ~ "Volume_Lead"))
data3$lead_count_cat <- lead_count_cat$lead_count_cat

# Creating lead counter variable
data3$number <- 1
data3 <- data.frame(data3 %>%
  arrange(person_id, activity_date) %>%
  group_by(person_id) %>%
  mutate(lead_counter = cumsum(number)))
data3 <- data3[, -which(names(data3) == "number")]
```

### Writing Cleaned Data to csv

``` r
#write.csv(data3, "~/Google Drive/Industry Project 1/Data/data3.csv", row.names = F)
```
