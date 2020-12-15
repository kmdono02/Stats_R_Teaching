library(tidyverse)

# Load data
data <- read_csv(file="../Data/Cross-sec_full.csv", na = c(".","","NA"))

# 1) Pasting together variables
# Ex. Combining Risk and Diagnosis variables (creating GROUP variable)
data$GROUP

# We will use the following functions : paste0, grepl, gsub, ifelse
# Let's go through them to see what they do with simply toy examples
# 1) paste0
paste0("x", "y", "z")
paste("x", "y", "z", sep="")
a <- "x"
b <- "y"
c <- "z"
paste0(a, b, c)

# 2) gsub
gsub("Pos", "ASD", "HR_Pos")
gsub("V", "", "V24")

# 3) if...else and ifelse()
condition <- "GO"
condition <- "STOP"

if(condition=="GO"){
  print("PASS")
}else{
  print("FAIL")
}

ifelse(condition=="GO", "PASS", "FAIL")

# Now let's start the pasting process
data_v1 <-
  data %>%
  mutate(SSM_ASD_v24_edit = gsub("_ASD", "", SSM_ASD_v24))

ftable(data_v1$SSM_ASD_v24, data_v1$SSM_ASD_v24_edit)

# Works, though doesn't look great
data_v1 <-
  data %>%
  mutate(SSM_ASD_v24_edit = gsub("_ASD", "", SSM_ASD_v24),
         GROUP_v0 = paste0(`V24 demographics,Risk`, "_", SSM_ASD_v24_edit))

ftable(data_v1$GROUP, data_v1$GROUP_v0)
ftable(data_v1$`V24 demographics,Risk`)

# Let's try to get the two group variables to match
data_v1 <-
  data %>%
  mutate(GROUP_v0 = ifelse(grepl("YES", SSM_ASD_v24), 
                           paste0(`V24 demographics,Risk`,"_","ASD"),
                           ifelse(grepl("NO", SSM_ASD_v24), 
                                  paste0(`V24 demographics,Risk`,"_","neg"), NA)))
ftable(data_v1$GROUP, data_v1$GROUP_v0)

# Great! Let's just remove the 36
data_v1 <-
  data %>%
  mutate(GROUP_v0 = gsub("_36_","_" , ifelse(grepl("YES", SSM_ASD_v24), 
                           paste0(`V24 demographics,Risk`,"_","ASD"),
                           ifelse(grepl("NO", SSM_ASD_v24), 
                                  paste0(`V24 demographics,Risk`,"_","neg"), NA))))
ftable(data_v1$GROUP, data_v1$GROUP_v0)

# 2) Change reference level
# Let's look at group differences in 24 month MSEL composite using ANOVA/linear regression
lm(formula = `V24 mullen,composite_standard_score`~GROUP, 
   data = data)
# Can see reference level is HR_ASD.  Want to change to LR negative

factor(data$GROUP)

data_v1 <-
  data %>%
  mutate(GROUP=relevel(factor(GROUP), ref="LR_neg"))

data_v1$GROUP
lm(formula = `V24 mullen,composite_standard_score`~GROUP, 
   data = data_v1)
# Can see reference level is LR_neg

# 3) Summarize variables by group
data_v1 <-
  data %>%
  group_by(GROUP) %>%
  summarise(mean_mullen_composite = mean(`V24 mullen,composite_standard_score`, na.rm=TRUE),
            sd_mullen_composite = sd(`V24 mullen,composite_standard_score`, na.rm=TRUE),
            sample_size = n())
data_v1

# 4) Pivot from wide to long and long to wide
# Make sure visit in the same spot for each variable
vars_to_convert <- names(data)[grepl("V06|V12|V24|V36", names(data))]
vars_to_convert <- vars_to_convert[vars_to_convert!="V24 demographics,Risk"]

# Convert to long
data_long <-
  data %>%
  gather(variable, var_value, vars_to_convert) %>%
  separate(variable,c("Visit","Variable"),sep=3) %>% 
  mutate(Variable=gsub("," ,"_", Variable)) %>%
  spread(key=Variable, value=var_value)

# See annoying space in variable names, can easily fix
data_long <-
  data %>%
  gather(variable, var_value, vars_to_convert) %>%
  separate(variable,c("Visit","Variable"),sep=3) %>% 
  mutate(Variable=gsub("," ,"_" ,Variable),
         Variable=gsub(" ","",Variable)) %>%
  spread(key=Variable, value=var_value)

# Can also use pivot_longer instead of gather (see online if interested)

# Convert back to wide
data_wide <-
  data_long %>%
  group_by(Identifiers) %>%
  gather(names(data_long)[!(names(data_long)%in%c("Identifiers", "SSM_ASD_v24",
                                                  "V24 demographics,Risk", "GROUP",
                                                  "Study_Site", "Gender", "Visit"))], 
         key=variable, value=number) %>%
  unite(combi, variable, Visit) %>%
  spread(combi, number)  

# 5) Create Z scores
# Suppose we want to create Z scores for Mullen composite at each time point using LR Neg
# First, compute time-specific means and SDs Mullen composite for LR Negative as comparison population
LR_mullen_stats <-
  data_long %>%
  filter(GROUP=="LR_neg") %>%
  group_by(Visit) %>%
  summarise(mean_mullen_composite = mean(mullen_composite_standard_score, na.rm=TRUE),
            sd_mullen_composite = sd(mullen_composite_standard_score, na.rm=TRUE))

# Now let's add these to the dataset.  We need to merge them in
data_with_LRmeans <-
  inner_join(data_long, LR_mullen_stats, by="Visit")
View(data_with_LRmeans)

data_with_zscore <-
  data_with_LRmeans %>%
  mutate(mullen_composite_zscore = 
           (mullen_composite_standard_score-mean_mullen_composite)/sd_mullen_composite)

# Let's look at boxplots of these z scores
ggplot(data=data_with_zscore,
       mapping=aes(x=Visit, y=mullen_composite_zscore, fill=GROUP))+
  geom_boxplot()

# 6) IBIS real analysis examples
# a) Convert visiting to a numeric variable for trjaectory analysis or regression
data_long$Visit

# Need to remove V and remove quotes " " to make numeric
data_long <-
  data_long %>%
  mutate(visit_num = gsub("V", "", Visit))

data_long$visit_num
# NOT yet numeric, can see quotes.  Use as.numeric() to force into numeric and remove quotes

data_long <-
  data_long %>%
  mutate(visit_num = as.numeric(gsub("V", "", Visit)))

data_long$visit_num
# Why did we have to remove the V first before converting to numeric with as.numeric()?

# b) requests?
