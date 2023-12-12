library(tidyverse)
library(janitor)
library(tidycensus)
library(dplyr)
library(tidyr)

census_api_key("25c677b1498d20b320f9bc1286a61df0c483a59f", install = TRUE)

# 2020 Decennial Census Variables
decennial_2020_vars <- load_variables(
  year = 2020, 
  "pl", 
  cache = TRUE
)

# INCOME DATA
nyc_income <- get_acs(
  geography = "block group", 
  year = 2020,
  variables = c("B19013_001"), 
  state = "New York", 
  county = c("Bronx", "Kings", "New York", "Queens", "Richmond")
  )


# Extract relevant variables
nyc_income <- nyc_income %>% 
  select(GEOID, estimate) 

# Rename columns for clarity
names(nyc_income) <- c("GEOID", "median_income")


#POPULATION DATA

nyc_race <- get_decennial(
  geography = "block group", 
  variables = c("P1_001N", "P1_003N"), #total population, white population
  state = "New York", 
  county = c("Bronx", "Kings", "New York", "Queens", "Richmond")
)

# Extract relevant variables
nyc_race <- nyc_race %>% 
  select(GEOID, variable, value) 

#nyc_race <- nyc_race %>% 
#  select(GEOID, NAME, variable, estimate) 

# Pivot the data from long to wide format
nyc_race_wide <- nyc_race %>%
  pivot_wider(names_from = variable, values_from = value) 

# Rename columns for clarity
names(nyc_race_wide) <- c("GEOID", "total_population", "white_population")

# Calculate non-white population
nyc_race_wide$non_white_percent <- 
  ((nyc_race_wide$total_population - nyc_race_wide$white_population) / nyc_race_wide$total_population) * 100

# Remove NA values
#nyc_race_clean <- nyc_race_wide %>%
#  filter(!is.nan(non_white_percent))


write.csv(nyc_race_wide, "non_white_by_bg.csv")
#write.csv(nyc_race_wide, "non_white_by_bg_clean.csv")


#POPULATION DATA

nyc_pop <- get_decennial(
  geography = "block ", 
  variables = c("P1_001N"), #total population
  state = "New York", 
  county = c("Bronx", "Kings", "New York", "Queens", "Richmond")
)

# Extract relevant variables
nyc_pop <- nyc_pop %>% 
  select(GEOID, value) 


# Rename columns for clarity
names(nyc_pop) <- c("GEOID", "total_population")


write.csv(nyc_pop, "pop_by_block.csv")
#write.csv(nyc_race_wide, "non_white_by_bg_clean.csv")
