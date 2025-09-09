### This is not my first script, but it is my first 
### script on learning how to import data. 
### Created by Emily C Rutkowski
### Created on: 1776-07-04
#######################################

### Load libraries #########
library(tidyverse)
library(here)

### Read in my data ######

weightdata<-read_csv(here("Week_02","data","weightdata.csv"))

### Data Analysis to check it read in correctly #####
head(weightdata)  #shows first 6 lines
tail(weightdata)  #shows last 6 lines
view(weightdata)  #opens new window, shows full data set
