### Introduction to ggplot2 homework assignment using the palmerpenguin 
### dataset for MBIO612 ###
### Created by Emily C Rutkowski ##
### 2025 - 09 - 15 ###

### Load libraries ###
library(palmerpenguins)
library(tidyverse)
library(PNWColors)
library(ggthemes)
library(here)

### Look at data to determine which variables I want to plot ###
### This data is not a csv file. It is part of the 
### downloaded package called penguins ##

view(penguins)
glimpse(penguins)

## data analysis section ##

ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, #plotting data to axes
                     y = species,
                     fill = species, # filling violins by species for easier id
                     color = species)) + # assigning each species a color for easy id 
  
  # Plotting #
  geom_jitter(alpha = 1) + # adding jitter for raw data visualization 
  geom_violin(trim = FALSE, # trim to see smooth distribution 
              alpha = 0.6) + # Make slightly transparent 
  
  # Adding labels #  
  labs( title = "Flipper length by species",
        subtitle = "From the Palmer Penguin R data package",
        x = "Flipper length (mm)", # Making the labels presentation ready 
        y = "Species") + 
  scale_fill_viridis_d() + # adding for color blindness 
  
  #Changin the theme and font of the plot # 
  scale_color_manual(values = pnw_palette("Anemone",3)) + # adding PNW color palette because I like it lol 
  theme_bw() + # changing the theme
  theme(plot.title = element_text(size = 18, face = "bold"),# changing the font size of the title and axes
        axis.title = element_text(size = 15,
                                  color = pnw_palette("Anemone"))) + 
  # Tidying appearance and readability #  
  coord_flip() + #flip axes to make it easier to read
  
  # Adding another variable for more information # 
  facet_wrap(vars(sex), ncol = 1) #faceting to add another variable, by sex.

# Saving as a png file # 
ggsave(here("Week_03", "Homework", "output", "Week_03_hw_ggplot.png"), #creating file path 
       width = 7, height = 5) # in inches 

