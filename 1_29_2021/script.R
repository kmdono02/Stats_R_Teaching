# Load packages
library(tidyverse)
library(readr)
library(broom)
library(flextable)
library(ggpubr)

# Load data
full_data <- read_csv("../Data/Cross-sec_full.csv", na = c(".", "", " "))

# Rename variables to remove spaces and commas from names
names(full_data) <- gsub(pattern=" |,", replacement="_", names(full_data))

# Visualize data first for relationships of interest
ggplot(data=full_data, aes(x=V12_mullen_composite_standard_score, y=V12_aosi_total_score_1_18))+
  geom_point()+
  labs(x="Mullen Composite Standard Score", 
       y="AOSI Total Score", 
       title="Scatterplot of Mullen Composite Standard Score \nand AOSI Total Score at Month 12")+
  theme_classic()

# Calc correlation
cor(x=full_data$V12_mullen_composite_standard_score, y=full_data$V12_aosi_total_score_1_18)

# Missing values cause error by default
cor(x=full_data$V12_mullen_composite_standard_score, y=full_data$V12_aosi_total_score_1_18, 
    use="pairwise.complete")

# Test corr/compute 95% CI
cor.test(x=full_data$V12_mullen_composite_standard_score, y=full_data$V12_aosi_total_score_1_18)

# Model AOSI TS at 12 months as a linear fn of Mullen composite at 12 months and age at 12 month visit
lm(V12_aosi_total_score_1_18~V12_mullen_composite_standard_score+V12_mullen_Candidate_Age, data=full_data)

full_data %>%
  filter(is.na(V12_aosi_total_score_1_18)==0&is.na(V12_mullen_composite_standard_score)==0)

# Save results to access later if needed; use sumary fn to get usual results table
lm_fit <- lm(V12_aosi_total_score_1_18~V12_mullen_composite_standard_score+
               V12_mullen_Candidate_Age, data=full_data)
summary(lm_fit)

# Results from R in ugly format.  Easy way to reformat: tidy() from broom package
lm_fit_results_table <- tidy(lm_fit)

# Then use flextable to create output in format for Word for a manuscript
lm_fit_results_table <- lm_fit_results_table %>%
  mutate(p.value=ifelse(p.value<0.005, "<0.005", 
                        as.character(round(p.value, 3))),
         term=fct_recode(factor(term),
                         "Intercept"="(Intercept)",
                         "12 Month MSEL Composite SS"="V12_mullen_composite_standard_score",
                         "12 Month Visit Age"="V12_mullen_Candidate_Age"),
         model="MSEL Composite")

flextable(data=lm_fit_results_table) %>%
  set_header_labels(term="Variable",
                    "estimate"="Estimate",
                    "std.error"="Std. Error",
                    "statistic"="T Statistic",
                    "p.value"="P-value") %>%
  autofit()

# Let's look at all the output from the model in detail
lm_fit
summary(lm_fit)

# Let's look at another model and compare the results in one table
lm_fit_2 <-
  lm(V12_aosi_total_score_1_18~V12_mullen_cognitive_t_score_sum+V12_mullen_Candidate_Age, data=full_data)

lm_fit_results_table_2 <- tidy(lm_fit_2) %>%
  mutate(p.value=ifelse(p.value<0.005, "<0.005", 
                        as.character(round(p.value, 3))),
         term=fct_recode(factor(term),
                         "Intercept"="(Intercept)",
                         "12 Month MSEL Cognitive T-Score"="V12_mullen_cognitive_t_score_sum",
                         "12 Month Visit Age"="V12_mullen_Candidate_Age"),
         model="MSEL Cognitive")

lm_table_all <- rbind(lm_fit_results_table %>% select(model, everything()), 
                      lm_fit_results_table_2 %>% select(model, everything()))

# Use the fn colformat_double() to round to 2 places
# Use merge_v to remove duplicate model labels
# Use valign to vertically align the cells
# What happens if you remove merge_v, valign, fix_border_issues?
# Why were the p values also rounded to 2 places

flextable(data=lm_table_all) %>%
  colformat_double(digits=2) %>%
  set_header_labels("model"="Model",
                    "term"="Variable",
                    "estimate"="Estimate",
                    "std.error"="Std. Error",
                    "statistic"="T Statistic",
                    "p.value"="P-value") %>%
  merge_v(j=1) %>%
  valign(valign = "top") %>%
  autofit() %>%
  fix_border_issues()

# Let's do some diagnostics
# 1. Linear Fit
ggplot(data=full_data, aes(x=V12_mullen_composite_standard_score, y=V12_aosi_total_score_1_18))+
  geom_point()+
  geom_smooth(method="loess", se=FALSE)+
  labs(x="Mullen Composite Standard Score", 
       y="AOSI Total Score", 
       title="Scatterplot of Mullen Composite Standard Score \nand AOSI Total Score at Month 12")

# 2. Homoskedasticity
fit_data <- data.frame(lm_fit$residuals, lm_fit$fitted.values)

ggplot(data=fit_data, aes(y=lm_fit.residuals, x=lm_fit.fitted.values))+
  geom_point()+
  labs(x="Fitted Value", 
       y="Residual", 
       title="Scatterplot of residual by fitted value for AOSI regression model.")

# 3. Normality of residuals
qqnorm(y=fit_data$lm_fit.residuals)
qqline(y=fit_data$lm_fit.residuals, datax = FALSE)

# Noticable deviation, but large sample size?
dim(full_data)
# Doesn't reflect data actually used to FIT model (include missing values)
# Let's extract that data directly instead and look size
View(model.frame(lm_fit))
dim(model.frame(lm_fit))
