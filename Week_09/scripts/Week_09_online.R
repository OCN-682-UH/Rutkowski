## Week 09- Working with factors 
## Created by Emily C Rutkowski
## 10-24-2205

## Load libraries
library(tidyverse)
library(here)

## Load data
tuesdata <- tidytuesdayR::tt_load(2021, week = 7)
income_mean<-tuesdata$income_mean
income_mean <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_mean.csv')

# What is a factor?
#A factor is a specialized version of a character. It is how we truly store categorical data. The values that a factor takes are called levels. These levels allow you to order your data in specific ways. The default levels are always alphabetical. So, we need to learn how to use factors appropriately and reorder them to be specific to our analyses.

#Importantly, once you convert a character into a factor, R is actually storing them as integers (i.e., 1,2,3,4...). If you are not careful this can lead to a lot of headache... but, this is how you can put your characters in a specific order.

#To make something a factor you put the vector in the function factor()
fruits<- factor(c("Apple", "Grape", "Banana")) # level of order it will plot/summarize is alphabetical (apple banana grape)
fruits

# Factor booby traps
#Let's say you had a typo in a column of what was suppose to be numbers. R will read everything in as characters. If they are characters and you try to covert it to a number, the rows with real characters will covert to NAs

test<-c("A", "1", "2")
as.numeric(test)
#Warning message:
#NAs introduced by coercion
#[1] NA  1  2

#Let's test as a factor
test<-factor(test) # covert to factor
as.numeric(test)
#[1] 3 1 2 
# Now its giving NA a numeric number 
# Factors store verything as intergers in the background - important for categorical data 

# Reading in the data safely
# These types of factor booby-traps are why there was a big push to remove the automatic import of strings as factors. If you read in your data as read.csv() then all your strings will be automatically read in as factors, if you use read_csv() strings will be read as characters.
# read.csv -> all strings will become factors
# read_csv -> strings will become characters 

# forcats package is a family of functions for cat data 
# All the main fucntions start with fct_

glimpse(starwars)

# Lets looks at info by diff species in the starwars films 
# How many individuals of each species are present across all starwars films? 

starwars %>%
  filter(!is.na(species)) %>% # remove the NAs from species 
  count(species, sort = TRUE)

# There are 38 unique species but most are really rare.
# Lets lump all the species together that have less than 3 individuals.
# fct_lump converts the data into a factor and lumps it together 
star_counts<-starwars %>%
  filter(!is.na(species)) %>% # filter out NAs
  mutate(species = fct_lump(species, n = 3)) %>% # mutate species column and make anything less than 3 into other  
  count(species)
star_counts

# Reordering factors

star_counts %>%
  ggplot(aes(x = fct_reorder(species,n), y = n))+ # species = what to reorder,& what to reorder by(n) 
  geom_col() +# # reorder the factor of species by n
# Now the plot ges from lowest to highest count of species 
  labs(x = "Species")

# Reordering line plots

# Now we want to make a lin plot and reorder the legend to match the order 
# of the lines. We will use the income_mean dataset to show this. 

glimpse(income_mean)

# Make a plot of the total income by year and quantile across all dollar types
total_income<-income_mean %>%
  group_by(year, income_quintile)%>%
  summarise(income_dollars_sum = sum(income_dollars))%>% # sum across all dollar types
  mutate(income_quintile = factor(income_quintile)) # make it a factor

# Basic line plot
total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, color = income_quintile))+
  geom_line()
# But legend is in alphabetical order not order of income 

# Reorder the line plot by using fct_reorder2-reorder the data by 2 variables 
total_income%>%
  ggplot(aes(x = year, y = income_dollars_sum, 
             color = fct_reorder2(income_quintile,year,income_dollars_sum)))+
  geom_line()+
  labs(color = "income quantile")

# Reorder levels directly in a vector because I said so
# We have a vector and want to put it in a specific order that we say. 
# Not because its the largest or smallest value.

x1<- factor(c("Jan", "Mar", "Apr", "Dec"))
x1
#[1] Jan Mar Apr Dec
#Levels: Apr Dec Jan Mar

# This order is not what we want. We can set specific order of the levels.
x1<-factor(c("Jan", "Mar", "Apr", "Dec"), levels = c("Jan", "Mar", "Apr", "Dec"))
x1

# Subset data with factors

#Instead of grouping our species that have <3 counts into "other" we just filter them out.
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor
  filter(n>3) # only keep species that have more than 3
starwars_clean
# check the levels of the factor 
levels(starwars_clean$species)
# we still have all 38 levels

#Subset data with factors

# use fct_drop or droplevels() to remove any extra levels not included in the dataframe
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor
  filter(n>3) %>% # only keep species that have more than 3
droplevels() # drop extra levels - ALWAYS USE 
starwars_clean
levels(starwars_clean$species)

# Recode levels
# If you want to rename (or recode) a level
starwars_clean<-starwars %>% 
  filter(!is.na(species)) %>% # remove the NAs
  count(species, sort = TRUE) %>%
  mutate(species = factor(species)) %>% # make species a factor
  filter(n>3) %>% # only keep species that have more than 3
  droplevels() %>% # drop extra levels - ALWAYS USE
  mutate(species = fct_recode(species, "Humanoid" = "Human")) # changes name 
starwars_clean
