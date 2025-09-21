### Week 4a Data Wrangling: dplyr Homework assignment using the Palmer Penguin dataset ###
### Created by: Emily C Rutkowski 
### 2025 - 09 - 19
#################

### Load in libraries ###
library(tidyverse)
library(palmerpenguins)
library(ggplot2)
library(ggthemes)
library(PNWColors)
library(here)
library(praise) ##  ** necessary hehe :D

## Read the data ##
view(penguins) # I like view to see the whole picture 

## Data analysis ##

#Write a script that:
  
  # 1.calculates the mean and variance of body mass:
  # by species, island, and sex without any NAs

  # 2. filters out (i.e. excludes) male penguins, then calculates the log body mass, then selects only the columns for:
  # species, island, sex, and log body mass, 
  # then use these data to make any plot. Make sure the plot has clean and clear labels and follows best practices. 
  # Save the plot in the correct output folder.

  # Include both part 1 and part 2 in your script and push it to github in the appropriate folders.

# Part 1.) Calculate mean and variance of body mass

penguins %>% # or use |> "and then" 
  drop_na(body_mass_g, species, island, sex) %>% # removing NAs for these columns
  group_by(species, island, sex) %>% # grouping variables together to summarize 
  summarise(mean_body_mass = mean(body_mass_g, na.rm = TRUE), #calculating mean body mass, excluding any NAs
            variance_body_mass = var(body_mass_g, na.rm = TRUE)) #calculating the variance, excluding any NAs

view(penguins) # just making sure I didnt mess anything up 
praise() # Yay! 


# Part 2.) Filter out male penguins, calculate log body mass, then select only species, island, sex, and log body mass. 

female_log<-penguins %>% # assinging new data set 
  drop_na(body_mass_g, species, island, sex) %>%
  filter(sex != "male") %>% # Making sex not male, could also: sex == "female"
  mutate(log_body_mass_kg = log(body_mass_g/ 1000)) %>% # create a new column with log body mass converted to kg
  select(species, island, sex, log_body_mass_kg) # selects columns only for species, island, sex, and the new log body mass in kg

view(female_log) # check out the new dataset 
praise() # I did it! 

## Plot the data 

ggplot(female_log,
       mapping = aes( x = species, y = log_body_mass_kg, # plotting species by body mass kg 
                      group = species,
                      fill = species)) + # filling the box plot by species color 
  geom_boxplot(outlier.color = "red") + # Makes the outliers visible in red 
  geom_jitter(alpha = 0.4) + # adding jitter for raw data visualization on top of boxplot
  
## Adding labels ##

labs( title = "Female Penguin Body Mass", # Creating title 
      subtitle = "by species and island", # Creating subtitle 
      fill = "Species", # Changes legend title 
      x = "Species", # Editing x axis title 
      y = "Log Body Mass (kg)") + # Editing y axis title 
  scale_fill_viridis_d() + # Making color blind friendly 

#Changin the theme and font of the plot # 

scale_fill_manual( values = pnw_palette("Cascades", 3)) + # Adding fill color to Pacific NW Palette- Cascades 
  theme_igray() + # changing theme to gray border and white graph 
  theme(legend.background = element_rect(color = "black",   # Adding legend border & border color
                                     fill = "white",   # background color
                                     linewidth = 0.5), # border thickness 
        plot.title = element_text(size = 16, face = "bold"), # changing the font size of the title and axes
        axis.title = element_text(size = 13)) 

## Save as PNG to Github 
ggsave(here("Week_04", "output", "Week_04_Homework_01.png"))
        



