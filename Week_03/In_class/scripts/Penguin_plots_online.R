## Plotting penguin data for MBIO612 ##
## Created by Emily C Rutkowski ##
## 2025 - 09 - 15 ##

install.packages("praise")
install.packages("devtools")
devtools::install_github("jakelawlor/PNWColors") 
install.packages("ggthemes")

## load libraries ##
library(palmerpenguins)
library(tidyverse)
library(PNWColors)
library(ggthemes)
library(here)

## load data ##
# This data is not a csv file. It is part of the downloaded package called penguins ##

view(penguins)
glimpse(penguins)


## data analysis section ##

plot1<-ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm,
                     y = bill_length_mm,
                     group = species,
                     color = species))+

  geom_point()+
  geom_smooth(method = "lm")+
  labs(x = "Bill depth (mm)",
       y = "Bill length (mm)") +
  scale_colour_viridis_d() +
  #scale_x_continuous(breaks = c(14,17,21),
   #                  labels = c("low", "medium", "high"))+
  scale_color_manual(values = pnw_palette("Winter",3)) +
  theme_dark() + # I like bw, dark and classic 
  theme(axis.title = element_text(size = 20,
                                  color = pnw_palette("Anemone"))) # changing the font size 
ggsave(here("output", "penguin.png"),
       width = 7, height = 5) # in inches 

plot1 #call it to view again
                     