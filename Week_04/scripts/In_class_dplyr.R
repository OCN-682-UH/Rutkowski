## Today we are going to plot penguin data- learning dyplyr ##
## Created by Emily C Rutkowski##
## 2025 - 09 - 16 ##

## Load libraries ##
library(palmerpenguins)
library(tidyverse)
library(here)

## Look at teh data ##
view(penguins)

## Filter data ##

filter(.data = penguins, 
       sex == "female") ## Do not always need the . before data, need quotes because its a charcter
## == is one variable, x%in% y is within, pulling out more than 1- a group 
filter(.data = penguins,
       year == "2008") # dont need quotes because its an integer, but should use anyways if youre searching
filter(.data = penguins,
       body_mass_g > 5000)
filter(.data = penguins,# , year %in% c(2008,2009)
       year == 2008 | 2009)
filter(.data = penguins,
       island != "Dream")
filter(penguins, species %in% c("Adelie", "Gentoo"))

## Mutating ##
data2<-mutate(.data = penguins,
              body_mass_g/1000,
              bill_length_depth = bill_length_mm/bill_depth_mm) ## adding a new column 
view(data2)
## Mutate multiple columns at once based on a criterion##

data2<- mutate(.data = penguins,
               after_2008 = ifelse(year>2008, "After 2008", "Before 2008"))
view(data2)

## add flipper length and body mass together
data2<- mutate(penguins,
               length_body_mass = flipper_length_mm + body_mass_g)
view(data2)

#new column of big and small penguins if greater than 4000
data2<-mutate(penguins,
              big_small = ifelse(body_mass_g > 4000, "big", "small"))
view(data2)

## The pipe = %>% means "and then" 

## only female penguisn and add a new column that calculates the log body mass
penguins %>%
  filter(sex == "female") %>%
  mutate(log_mass = log(body_mass_g)) %>%
  select(Species = species, island, sex, log_mass)

##Summarize##
penguins %>%
  summarise(mean_flipper = mean(flipper_length_mm, na.rm=TRUE),
            min_flipper = min(flipper_length_mm, na.rm=TRUE)) ## This is how to get rid of NAs
##Group by##
penguins %>%
  group_by(island, sex) %>%
  summarise(mean_bill_length = mean(bill_length_mm, na.rm=TRUE),
            max_bill_length = max(bill_length_mm, na.rm=TRUE))
##Remove NAs
penguins %>%
  drop_na(sex)
##Pipe into ggplot##
penguins %>%
  drop_na(sex) %>%
  ggplot(aes( x = sex, y = flipper_length_mm)) +
  geom_boxplot()
