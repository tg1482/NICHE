library(pacman)
p_load(tidyverse, ggplot2, pander, knitr, scales, readxl, kableExtra, rmarkdown, knitcitations, imputeTS, lubridate)
######################

######################
# Loading Survey Data and Correct Knowledge Questions
giap <- read_excel("Summer 2018/summer2018AllData.xlsx")
######################

######################
# Changing Variable Names and Structure
giap <- giap %>% 
  rename("Hospital.Name" = "facility") %>% 
  rename("Unit.Name" = "primaryNursingUnit") %>% 
  mutate(Hospital.Name=as.factor(Hospital.Name))

# Creating a list of Unique Hospital Names
Hospital.Names <- unique(giap$Hospital.Name) %>% na.omit()

# Creating date objects
giap <- giap %>% 
  mutate(startDate = mdy_hms(startDate),
         finishDate = mdy_hms(finishDate))
######################

######################
# Creating a trim function, incase necessary. Trims the white space at the beginning and the end of a word
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
######################

######################
# Fucntion to Change NA to 0
na_to_zero <- function(val){
  zero <- ifelse(is.na(val), 0, val)
  return(zero)
}
######################

######################
# Not in Function
'%!in%' <- function(x,y)!('%in%'(x,y))
######################

hospital_name <- "Duke Regional Hospital"

giap <- giap %>% 
  filter(Hospital.Name == hospital_name) %>% 
  select(-Hospital.Name) %>%  
  mutate(Unit.Name = as.factor(Unit.Name))

unit.names <- unique(giap$Unit.Name)[!is.na(unique(giap$`Unit.Name`))]


cohort <- "Summer 2018"

result_path <- paste0("Summer 2018/Unit Level/Results/", hospital_name)

if(!dir.exists(result_path)){
  dir.create(result_path)
}

for(name in unit.names){
  name_ <- gsub('/', ' ', name)
  render("Summer 2018/Unit Level/Unit Level Report.Rmd", 
         output_file = paste0(result_path, "/", name_, ".html"))
}



