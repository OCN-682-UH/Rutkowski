### Week 4b Data Wrangling: tidyr homework assignment using the Chem dataset 
### from Hawaii for MBIO612 ###
### Created by Emily C Rutkowski ##
### 2025 - 09 - 15 ###
############################

## Homework Assignment: 
## Using the chemistry data:

# Create a new clean script
# Remove all the NAs
# Separate the Tide_time column into appropriate columns for analysis
# Filter out a subset of data (your choice)
# use either pivot_longer or pivot_wider at least once
# Calculate some summary statistics (can be anything) and export the csv file into the output folder
# Make any kind of plot (it cannot be a boxplot) and export it into the output folder
# Make sure you comment your code and your data, outputs, and script are in the appropriate folders


### Load in libraries ###
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(PNWColors)
library(here)
library(praise)

## Load data ###

Chemdata<- read_csv(here("Week_04", "data", "chemicaldata_maunalua.csv")) #load in data & name it
view(Chemdata) # view the data 

## Data wrangling/analysis ##

Chemdata_cleaned<-Chemdata %>% # Rename filtered dataset
  filter(complete.cases(.)) %>% # filters out everything that is not a complete row/another way to remove NAs
  separate(col = Tide_time, # choose column to be separated 
           into = c("Tide", "Time"), # separate into 2 columns & name them
           sep = "_", # separate by _ , this is whatever is in the dataset already
           remove = FALSE) %>% # keep original tide_time column 
filter(Zone %in% c("Transition", "Ambient")) %>% # filter for only the zones: transition & ambient
  pivot_longer(cols = Phosphate:NN, # pivot longer to put nutrient variables and values into columns
               names_to = "Nutrients",
               values_to = "Values") %>%
  group_by(Waypoint, Zone, Season, Nutrients, Temp_in) %>% # grouping by columns I want to look at
  summarise(Nutrient_mean = mean(Values, na.rm = TRUE), # calculate mean nutrients
            Nutrient_min = min(Values, na.rm = TRUE), # calculate minimum nutrients values
            Nutrient_max = max(Values, na.rm = TRUE)) %>% # caluclate max nutrient values 

write_csv(here("Week_04","output","summary_Homework.csv"))  # export as a csv 

## Plot the data 
# Decided to not use new data set because everything I made with it was weird and ugly **sigh 
Chemdata %>% # use original dataset 
  drop_na(Temp_in, pH) %>%          # remove NAs from columns 
  ggplot(Chemdata, 
         mapping = aes(x = Temp_in, # plot temperature and ph 
                       y = pH)) +
  stat_density_2d(aes(fill = after_stat(density)),  #Found inspo from r-graph-gallery, thought it looked really cool, creates 2d density estimate of points # ..density.. also works? But after_stat is new way
                                                    # maps the calculated density values to the tile fill color
    geom = "tile", # square “pixels” instead of contour lines
    contour = FALSE, # just show filled tiles not countour lines 
    n = 200,                                # grid resolution, higher = smoother, slower
    h = c(1.0, 1.0)) +                      # bandwidth smoothing for x & y directions. Larger = smoother, smaller = more detailed
    # All of that is for the colored background 
  geom_point(color = "white", size = 1, alpha = 0.6) + # This adds raw data points on top
  scale_y_continuous(limits = c(7.5, 8.5)) + # changing the y axis so points are more visible
  scale_fill_gradientn(colours = pnw_palette("Shuksan", 100),   # need continuous not discrete, gradient of 100 colors w/ pnw palette
    name = "Density")+ # name the legend 
  labs(
    title = "2D Density Map of pH vs Temperature\n by Season in Maunalua Bay", # Add a title, \n puts title in 2 lines 
    x = "Temperature (°C)", # name x & y axes 
    y = "pH"
  ) +
  facet_wrap(~ Season) + # facet wrap to add another variable- Season 
  theme_bw() + # black and white background theme 
  theme(legend.background = element_rect(color = "black",   # Adding legend border & border color
                                         fill = "white",   # background color
                                         linewidth = 0.2), # border thickness 
        plot.title = element_text(hjust = 0.5, size = 15, face = "bold"), # changing the font size of the title and axes
        axis.title = element_text(size = 13)) 


## Questions ##
# I got this Warning message:
# Removed 800 rows containing missing values or values outside the scale range (`geom_tile()`)
# Is there a way to keep these values while still keeping my scale_y range the same? Or does it not even matter? 800 just seems like a lot...
