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
                         "12 Month Visit Age"="V12_mullen_Candidate_Age"))

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
