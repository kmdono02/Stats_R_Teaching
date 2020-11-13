### Tidyverse
# A MUCH better way of wrangling data
install.packages("tidyverse")
# Make sure the tidyverse package is installed
library(tidyverse)
# Load tidyverse
# tidyverse is actually a collection of a bunch of separate packages (see console)

data <- read.csv(file="../Data/AOSI_small.csv", na.strings = ".")
names(data) # quick way of viewing all variables in data frame
View(data)

## Select
#  select() function used to remove variables and/or order them
select(data, Identifiers, GROUP)
# First argument is dataset, next arguments are variables you want to keep
# in order you want them to appear (left to right)
select(data, -Identifiers, -GROUP)
# Can also specify variable you want to remove using - prefix
select(data, GROUP, everything())
# Can use everything() to fill in all other data variables in order they orginally appeared
# useful when reordering the variables 

## Arrange
# arrange() function used to order rows (observations) based on variables
arrange(data, V06.aosi.Candidate_Age)
# Sorting by ascending age.  Note dataset is again 1st argument followed by variables

arrange(data, GROUP, V06.aosi.Candidate_Age)
# Can also do nested sorting using multiple variables (first by diagnosis, then age)

arrange(data, GROUP, desc(V06.aosi.Candidate_Age))
# Can also specify descending order for specific variable(s) using desc() function

## Mutate
# mutate() function used to create new variables
mutate(data, 
       v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE))
# creating Z score for 6 month AOSI total score.  Not use of mean() to compute mean, sd() to compute standard deviation,
# and na.rm=TRUE to remove missing values prior to calc of mean, sd.  What happens if I omit na.rm=TRUE?

mutate(data, 
       v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
       v12_aosi_zscore = (V12.aosi.total_score_1_18-mean(V12.aosi.total_score_1_18, na.rm=TRUE))/sd(V12.aosi.total_score_1_18, na.rm=TRUE))
# Can create multiple variables, just separate by comma
mutate(data, 
       v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
       v06_aosi_round = round(v06_aosi_zscore, digits = 3))
# Can also create variables based on other created variables in same mutate call.
# Here I round my Z-scores to 3 places after creating them

## Filter
# filter() function used to remove rows of data based on variables
filter(data, GROUP=="HR_ASD")
# Keep only rows with GROUP="HR_ASD".  Use of == tests if "is equal to".  Remember "=" saves values to an object like <-
filter(data, GROUP=="HR_ASD"&V06.aosi.total_score_1_18>10)
# Keep only rows with GROUP="HR_ASD" & AOSI at 6 months > 10.  Use of & means BOTH need to be true to be in data
filter(data, GROUP=="HR_ASD"|V06.aosi.total_score_1_18<10)
# Use of | means "OR", only one (or more) needs to be true to be kept
filter(data, GROUP!="HR_ASD")
# Use of != denotes "NOT equal to", only those NOT equal to "HR_ASD" kept

## Pipe: %>%
# Notice all of these functions have the dataset as the first argument
# Suppose we have multiple data processing steps we want to do
data_1 <- mutate(data, 
       v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
       v12_aosi_zscore = (V12.aosi.total_score_1_18-mean(V12.aosi.total_score_1_18, na.rm=TRUE))/sd(V12.aosi.total_score_1_18, na.rm=TRUE))

filter(data_1, GROUP=="HR_ASD")
# Very cumbersome, need to save each intermediate step as a new R object
# Instead, let's use the pipe operator, denoted by %>%

mutate(data, v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
                 v12_aosi_zscore = (V12.aosi.total_score_1_18-mean(V12.aosi.total_score_1_18, na.rm=TRUE))/sd(V12.aosi.total_score_1_18, na.rm=TRUE)) %>%
  filter(GROUP=="HR_ASD")
# This results in the same output, and in fact carries out the same processes.
# How does this work?

# %>% simply takes everything from the left of the symbol, and pastes it into the first
# argument for the function call on the right.  That is, the above is the same as
filter(mutate(data, v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
              v12_aosi_zscore = (V12.aosi.total_score_1_18-mean(V12.aosi.total_score_1_18, na.rm=TRUE))/sd(V12.aosi.total_score_1_18, na.rm=TRUE)), GROUP=="HR_ASD")
# But MUCH CLEANER!
# We also include it in the beginning
data %>% 
  mutate(v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
                v12_aosi_zscore = (V12.aosi.total_score_1_18-mean(V12.aosi.total_score_1_18, na.rm=TRUE))/sd(V12.aosi.total_score_1_18, na.rm=TRUE)) %>%
  filter(GROUP=="HR_ASD")

# and then save as a new dataset
data_v2 <-
  data %>% 
  mutate(v06_aosi_zscore = (V06.aosi.total_score_1_18-mean(V06.aosi.total_score_1_18, na.rm=TRUE))/sd(V06.aosi.total_score_1_18, na.rm=TRUE),
         v12_aosi_zscore = (V12.aosi.total_score_1_18-mean(V12.aosi.total_score_1_18, na.rm=TRUE))/sd(V12.aosi.total_score_1_18, na.rm=TRUE)) %>%
  filter(GROUP=="HR_ASD")


