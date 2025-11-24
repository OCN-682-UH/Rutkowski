## Week 13 in class- Iterative coding and intro to models
# Nov 18 2025

library(tidyverse)
library(here)

## for loops 
# 2 major parts 1. indexing statement 2. command 

## simple for loop
print(paste("This year is", 2000))
#put it in a for loop
years<-c(2015:2021)
for (i in years){ # set up the for loop where i is the index
  print(paste("The year is", i)) # loop over i
} # must highlight all code for it to run it all-wont work 1 line at a time 
# a for loop does one thing at a time 

# Let's say you want to save a new vector with all the years. To do this we need to pre-allocate space and tell R where it is going to be saved. Create an empty dataframe called year_data with columns for year and year_name .

#Pre-allocate space for the for loop
# empty matrix that is as long as the years vector
year_data<-tibble(year =  rep(NA, length(years)),  # column name for year
                  year_name = rep(NA, length(years))) # column name for the year name
year_data

# Add the for loop
for (i in 1:length(years)){ # set up the for loop where i is the index
  year_data$year_name[i]<-paste("The year is", years[i]) # loop over i
  year_data$year[i]<-years[i] # loop over year
}
year_data

# Using loops to read in multiple .csv files
testdata<-read_csv(here("Week_13", "data", "cond_data","011521_CT316_1pcal.csv"))
glimpse(testdata)

#list files in a directory
# point to the location on the computer of the folder
CondPath<-here("Week_13", "data", "cond_data")
# list all the files in that path with a specific pattern
# In this case we are looking for everything that has a .csv in the filename
# you can use regex to be more specific if you are looking for certain patterns in filenames
files <- dir(path = CondPath,pattern = ".csv")
files

# pre-allocate space for the loop
# Let's calculate the mean temperature and salinity from each file and save it
# pre-allocate space
# make an empty dataframe that has one row for each file and 3 columns
cond_data<-tibble(filename =  rep(NA, length(files)),  # column name for year
                  mean_temp = rep(NA, length(files)), # column name for the mean temperature
                  mean_sal = rep(NA, length(files)), # column name for the mean salinity
) # column name for the year name
cond_data

# write basic code to calculate a mean and build out
raw_data<-read_csv(paste0(CondPath,"/",files[1])) # test by reading in the first file and see if it works
head(raw_data) # paste0 means paste with no spaces 

mean_temp<-mean(raw_data$Temperature, na.rm = TRUE) # calculate a mean
mean_temp # this is testing to see if the code works 

# Turn it into a for loop
for (i in 1:length(files)){ # loop over 1:3 the number of files
  raw_data<-read_csv(paste0(CondPath,"/",files[i]))
  #glimpse(raw_data)
  cond_data$filename[i]<-files[i] # add in the filename for each row 
  cond_data$mean_temp[i]<-mean(raw_data$Temperature, na.rm =TRUE) # add in means for the files 
  cond_data$mean_sal[i]<-mean(raw_data$Salinity, na.rm =TRUE)
}
cond_data

# {purrr} - look at cheatsheet 

# Simple Example

#There 3 ways to do the same thing in a map() function

#Use a canned function that already exists

#Let's calculate the mean from a set of random numbers and do it 10 times

#Create a vector from 1:10
1:10 # a vector from 1 to 10 (we are going to do this 10 times)

#for each time 1:10 make a vector of 15 random numbers based on a normal distribution
1:10 %>% # a vector from 1 to 10 (we are going to do this 10 times) %>% # the vector to iterate over
  map(rnorm, n = 15) %>% # calculate 15 random numbers based on a normal distribution in a list
  map_dbl(mean) # calculate the mean. It is now a vector which is type "double"

# Make your own function - same thing different notation 
1:10 %>% # list 1:10
  map(function(x) rnorm(15, x)) %>% # make your own function
  map_dbl(mean)
#Use a formula when you want to change the arguments within the function
1:10 %>%
  map(~ rnorm(15, .x)) %>% # changes the arguments inside the function- for multiple arguments in a function
  map_dbl(mean)


#Bring in files using purrr instead of a for loop
files <- dir(path = CondPath,pattern = ".csv", full.names = TRUE)
#save the entire path name
files

# read in the files 
data<-files %>%
  set_names()%>% # set's the id of each list to the file name
  map_df(read_csv,.id = "filename")  %>% # map everything to a dataframe and put the id in a column called filename
  group_by(filename) %>%
  summarise(mean_temp = mean(Temperature, na.rm = TRUE),
            mean_sal = mean(Salinity,na.rm = TRUE))
data # every column needs to be identical for this to work 


