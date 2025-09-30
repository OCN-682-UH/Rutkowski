## Today we are going to practice joins with data from Becker & Silbiger 

install.packages("cowsay")

#### Load Libraries ######
library(tidyverse)
library(here)

##### Load data ######
# Environmental data from each site
EnviroData<-read_csv(here("Week_05","data", "site.characteristics.data.csv"))

#Thermal performance data
TPCData<-read_csv(here("Week_05","data","Topt_data.csv"))

EnviroData_wide <- EnviroData %>% 
  pivot_wider(names_from = parameter.measured,
              values_from = values) %>%
  arrange(site.letter) 


FullData_left <- left_join(TPCData, EnviroData_wide) %>%
  relocate(where(is.numeric), .after = where(is.character)) %>% # relocate all the numeric data after the character data 
  pivot_longer(cols = E:substrate.cover,
               names_to = "param",
               values_to = "Values") %>%
  group_by(site.letter, param) %>%
  summarize(mean_vals = mean(Values, na.rm = TRUE),
            var_vals = var(Values, na.rm = TRUE))
## Many different ways to join
# Make 1 tibble

T1 <- tibble(Site.ID = c("A", "B", "C", "D"), 
             Temperature = c(14.1, 16.7, 15.3, 12.8))
# make another tibble
T2 <-tibble(Site.ID = c("A", "B", "D", "E"), 
            pH = c(7.3, 7.8, 8.1, 7.9))

left_join(T1,T2)
right_join(T1,T2)
left_join(T1,T2) ==
  right_join(T2,T1) 
inner_join(T1,T2) # only keeps things they both have
full_join(T1,T2) # keep everyhting but beware of NAs
semi_join(T1,T2)
semi_join(T2,T1) #same site ID, but pH, because it is the column that is in T2
anti_join(T1,T2) #figure out where the missing data is, which one did it come from
anti_join(T2,T1) %>% # same 


