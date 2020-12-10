library(tidyverse)
library(gt)
library(kableExtra)
library(DT)
library(flextable)
library(gtsummary)

filetype <- "pdf"

nba_data <- read.csv("../Data/nba_teams_19_20.csv") %>%
  select(c("Team", "Age", "W","L","SOS","ORtg","DRtg","NRtg"))

# Ugly "base" table
nba_data

# Example: gt
gt(nba_data, rowname_col = "Team") %>%
  tab_header(title="NBA Teams Data", subtitle="2019-2020") %>%
  tab_spanner(label="Ratings", columns=c("ORtg","DRtg","NRtg")) %>%
  tab_row_group(group="Postive NRtg", rows=NRtg>0, others = "Negative NRtg") %>%
  data_color(columns = "NRtg",
             colors = scales::col_numeric(palette = c("blue", "white", "red"),
                                          domain=c(-10,10))) %>%
tab_style(style = list(
  cell_fill(color="red"),
  cell_text(color="white")),
locations = cells_body(rows=NRtg>0)) %>%
tab_style(style = list(
  cell_fill(color="blue"),
  cell_text(color="white")
),
locations = cells_body(
  rows=NRtg<0
)) %>%
gtsave(filename=paste0("test.", filetype)) 

# Example: flextable
# Works really well with Word documents! (generally, packages don't work great with Word)
flextable(nba_data) %>%
  theme_vanilla() %>%
  #print(preview="docx")
  save_as_docx(path="test.docx")

# Example: gtsummary
# Create summary stats tables!
nba_data_for_tbl <- nba_data %>%
  mutate(playoffs=ifelse(grepl("\\*",Team), "Yes", "No"))  %>% 
  filter(Team!="League Average") %>% 
  select(-Team)

tbl_summary(nba_data_for_tbl, by=playoffs) %>%
  add_n() %>%
  add_p() %>%
  modify_header(label = "Variable") %>%
  bold_labels()