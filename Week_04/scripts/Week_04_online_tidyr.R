## Today we are going to practice tidyr w/ biochemistry data from Hawaii ##
## How to: Separate & unite columns, Pivot data between long & wide formats, export csv w/ summary statistics
## Created by Emily C Rutkowski##
## 2025 - 09 - 20 ##

### Load libraries ###
library (tidyverse)
library(here) 

## Load data ###

Chemdata<- read_csv(here("Week_04", "data", "chemicaldata_maunalua.csv")) #load in data & name it
view(Chemdata) # view the data 

## Data wrangling/analysis ##

Chemdata_clean<-Chemdata %>% # Rename filtered dataset
  filter(complete.cases(.)) %>% # filters out everything that is not a complete row/another way to remove NAs
  separate(col = Tide_time, # choose column to be separated 
           into = c("Tide", "Time"), # separate into 2 columns & name them
           sep = "_", # separate by _ , this is whatever is in the dataset already
           remove = FALSE) %>% # keep original tide_time column 
  unite(col = "Site_Zone", # name of the NEW column
        c(Site,Zone), # the columns to unite
        sep = ".", # this time lets put a . in the middle
        remove = FALSE) # keep the original otherwise it automatically removes 
head(Chemdata_clean)
view(Chemdata_clean)
#Pivot between Wide & Long data #
Chemdata_long<- Chemdata_clean %>% #rename data set
  pivot_longer(cols = Temp_in:percent_sgd,# the columns you want to pivot. This says select the temp to percent SGD columns
               names_to = "Variables", # the names of the new columns with all the column names 
               values_to = "Values") # names of the new column with all the values
view(Chemdata_long)
## Lets calculate the mean and variance for all variable at each site #
Chemdata_long %>% # Select dataset
  group_by(Variables, Site) %>% # group by everything we want 
  summarise(Param_means = mean(Values, na.rm = TRUE), # calculate mean, give name
            Param_vars = var(Values, na.rm = TRUE)) # calculate variance, give name 
## Calculate mean, variance, & standard deviation for all variables by site, zone, and tide ##
Chemdata_long %>%
  group_by(Variables, Site, Zone, Tide) %>%
  summarise(Param_mean = mean(Values, na.rm = TRUE),
            Param_var = var(Values, na.rm = TRUE),
            Param_std = sd(Values, na.rm = TRUE))
view(Chemdata_long)            
## Facet wrap ##
## Create boxplots of eery parameter by site, fix the axes ##
## scales = "free" releases both the x & y axes, uses min and max within each variable ##

Chemdata_long %>%
  ggplot(aes(x = Site, y = Values)) +
  geom_boxplot()+
  facet_wrap(~Variables, scales = "free") # free is x and y, scatterplot free_x keeps y same changes x 

## Lets change long data into wide data ##
Chemdata_wide<-Chemdata_long %>% #name new dataset
  pivot_wider(names_from = Variables,# column w/ the names for the new column
              values_from = Values) # column with the values
view(Chemdata_wide) # view new dataset - do in console from now on lol

## Lets calculate some summary statistics and export csv file ## 

ChemData_clean<-Chemdata %>%
  drop_na() %>% #filters out everything that is not a complete row
  separate(col = Tide_time, # choose the tide time col
           into = c("Tide","Time"), # separate it into two columns Tide and time
           sep = "_", # separate by _
           remove = FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd, # the cols you want to pivot. This says select the temp to percent SGD cols  
               names_to = "Variables", # the names of the new cols with all the column names 
               values_to = "Values") %>% # names of the new column with all the values 
  group_by(Variables, Site, Time) %>% 
  summarise(mean_vals = mean(Values, na.rm = TRUE)) %>%
  pivot_wider(names_from = Variables, 
              values_from = mean_vals) %>% # notice it is now mean_vals as the col name
write_csv(here("Week_04","output","summary.csv"))  # export as a csv 

