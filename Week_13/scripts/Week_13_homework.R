### Homework: Iterative Coding - Tide Pool Data ###
### Goal: Calculate mean and SD of Temp.C and Intensity.lux for each tide pool ###
### Using BOTH a for loop AND map() functions ###

# Load libraries 
library(tidyverse)
library(here)

# Load in data files 
# Using loops to read in multiple .csv files
#list files in a directory
# point to the location on the computer of the folder
hwpath<- here("Week_13", "data", "homework")

# list all the files in that path with a specific pattern     
files<- dir(path = hwpath,
            pattern = ".csv",
            full.names = TRUE)
files # I can see all 4 csv files 

# for loop #

# pre-allocate space: create an empty tibble with one row per file 
# calculate the mean and sd of temp and light 
hw_data<- tibble(filename = rep(NA, length(files)), # column for file names 
                 mean_temp = rep(NA, length(files)), # column for mean tmp
                 sd_temp = rep(NA, length(files)), # column for sd of temp
                 mean_light = rep(NA, length(files)), # column for mean light intensity
                 sd_light = rep(NA, length(files))) # column for sd light intensity 
# check it - should be empty with NAs 
hw_data

# loop through each file 
for (i in 1:length(files)) { # i will be 1, then 2, then 3, then 4 --- 1:4
  raw_data <- read_csv(files[i]) # read in csv - files[i] grabs the i-th file path from my files vector
  hw_data$filename[i] <- basename(files[i]) # add in the filename for each row
  hw_data$mean_temp[i] <- mean(raw_data$Temp.C, na.rm = TRUE ) # calculate and add in mean temp for row i
  hw_data$sd_temp[i] <- sd(raw_data$Temp.C, na.rm = TRUE)
  hw_data$mean_light[i] <- mean(raw_data$Intensity.lux, na.rm = TRUE)
  hw_data$sd_light[i]<- sd(raw_data$Intensity.lux, na.rm = TRUE)
  
}
hw_data 

# map() function 
# Read in all files, combine them, and calculate mean & sd 
map_data<- files %>%
  set_names() %>% # set's the id of each list to the file name
  map_df(read_csv, .id = "filename") %>% # map everything to a dataframe and put the id in a column called filename
  group_by(filename) %>% # group to calc stats for each file separatly 
  summarise(mean_temp = mean(Temp.C, na.rm = TRUE),
            sd_temp = sd(Temp.C, na.rm = TRUE),
            mean_light = mean(Intensity.lux, na.rm = TRUE),
            sd_light = sd(Intensity.lux, na.rm = TRUE)) 
map_data # view 

# the for loop dataset and map fucntion data set match 

# i like map()function better...i do not beep boop enough for the for loops XD 