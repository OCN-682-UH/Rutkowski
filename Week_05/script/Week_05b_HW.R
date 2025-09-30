## Week 5b Homework Assignment
## Created by Emily c Rutkowski
## 09-29-2025

## Read in both the conductivity and depth data.
# Convert date columns appropriately
# Round the conductivity data to the nearest 10 seconds so that it matches with the depth data
# Join the two dataframes together (in a way where there will be no NAs... i.e. join in a way where only exact matches between the two dataframes are kept)
# take averages of date, depth, temperature, and salinity by minute
# Make any plot using the averaged data
# Do the entire thing using mostly pipes (i.e. you should not have a bunch of different dataframes). Keep it clean.
#Don't forget to comment!
# Save the output, data, and scripts appropriately

## Load libraries ##
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggthemes)
library(PNWColors)
library(here)
library(praise)

## Read in data ##
Cond_data<- read_csv(here("Week_05", "data", "CondData.csv")) # load in and give name
Depth_data<- read_csv(here("Week_05", "data", "DepthData.csv")) # load in and give name

view(Cond_data) # date is in character format
view(Depth_data) # date is in dttm format 

## Convert date columns
Cond_data<- Cond_data %>%
  drop_na() %>% # remove any rows w/ NAs to avoid error message?
  mutate(date = mdy_hms(date)) %>% # convert format to dttm 
  mutate(date = round_date(date, "10 seconds")) # round to nearest 10 sec
# NOTE: I was getting this warning message: There was 1 warning in `mutate()`.
#       ℹ In argument: `date = mdy_hms(date)`.
#       Caused by warning:
#       ! All formats failed to parse. No formats found. 
# I am kind of confused about this because I originally mutated & converted the dttm, viewed it and it looked correct. 
# I was only getting this error after I tried rounding to nearest 10 seconds, so I tried to drop NAs first and it worked. Why? :(

Cond_Depth_data<- inner_join(Cond_data, Depth_data, by = "date") %>% #join datasets by exact matches with date & give new name 
  mutate(minute = round_date(date, "minute")) %>% # round to nearest minute to get avg
  group_by(minute) %>% # by minute
  summarise(avg_date = mean(date, na.rm = TRUE), # calculate avg date
            avg_depth = mean(Depth, na.rm = TRUE), # calculate avg depth
            avg_temp = mean(Temperature, na.rm = TRUE), # calculate avg temp
            avg_sal = mean(Salinity, na.rm = TRUE))  # calculate avg salinity 

  write_csv(here("Week_05","output", "Avg_CondDepth_Data_Homework"))

## Plot data ##

Cond_Depth_data %>%
  pivot_longer(cols = avg_depth:avg_sal, # pivot longer to plot multiple variables
               names_to = "Parameters", # add new column name of variables
               values_to = "Avg_Values") %>% # add new column name of values
  ## Plot the data ##
ggplot(aes(x = minute, y = Avg_Values, color = Parameters)) +
  geom_point(alpha = 0.5) + # add points & change transparency of points
  facet_wrap(~Parameters, scales = "free_y", ncol = 1, # give each its own y-axis scale 
             labeller = as_labeller(c # changing facet labels 
               (avg_depth = "Depth (m)",
               avg_temp  = "Temperature (°C)",
               avg_sal   = "Salinity (ppt)")))+
             
  labs( title = "Short-term Variability in Depth,\n Temperature, and Salinity", # add titles 
        subtitle = "Sensor data from the near-shore,\n recorded at one-minute intervals",
        x = "Minutes", # Making the axes labels presentation ready 
        y = "Average") + 
   
  
  #Changin the theme and font of the plot # 
  scale_color_manual(values = pnw_palette("Bay",3), # adding PNW color palette 
                     labels = c(avg_depth = "Depth", # EDiting legend labels 
                                avg_sal = "Salinity",
                                avg_temp = "Temperature")) +  
  theme_bw() + # changing the theme
  theme(plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),# changing the font size and centering the title and axes
        axis.title = element_text(size = 15),
        plot.subtitle = element_text(hjust = 0.5, size  = 10),
        legend.background = element_rect(colour = "black", # border color
                                         linewidth = 0.2,  # border thickness
                                         fill = "white"))  # color inside the box

          
## Save the plot ## 
ggsave(here("Week_05", "output", "Week05 HW plot.png"),
       width = 7, height = 5) # in inches)                                   


  
