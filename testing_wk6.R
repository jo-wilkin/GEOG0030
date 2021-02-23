# Libraries used in this script:
library(tidyverse)
library(here)
library(magrittr)
library(janitor)
library(sf)
library(tmap)


london_wards <- read_sf('data/raw/boundaries/2011/London_Ward.shp')

greenspace <- read_csv('data/raw/public-open-space-nature-ward_access-to-nature.csv')

greenspace_cn <- clean_names(greenspace)

greenspace_access <- select(greenspace_cn, ward, percent_homes_with_good_access_to_nature)

imd <- read_csv('data/raw/imd_london_2019.csv') %>% clean_names()

imd_rank <- select(imd, ward_code, imd_average_score)

imd <- read_csv('data/raw/imd_london_2019.csv') %>% clean_names()

# delete white space row, delete COL

house_price <- read_csv('data/raw/house_price.csv') %>% clean_names()

house_price_2017 <- select (house_price, new_code, year_ending_dec_2017)

child_obesity <- read_csv('data/raw/indicators-Ward.data.csv') %>% clean_names()



# Clean our obesity dataset

# First remove the first row for England

child_obesity <- filter(child_obesity, area_name != "England") %>% filter(time_period == "2017/18 - 19/20")

child_obesity_s <- select(child_obesity, area_code, value)

# Join all of our datasets to our shapefile for analysis

london_wards_data <- london_wards %>% left_join(child_obesity_s, by = c("GSS_CODE" = "area_code")) %>% left_join(imd_rank, by = c("GSS_CODE" = "ward_code")) %>% left_join(greenspace_access, by = c("GSS_CODE" = "ward")) %>% left_join(house_price_2017, by = c("GSS_CODE" = "new_code"))
