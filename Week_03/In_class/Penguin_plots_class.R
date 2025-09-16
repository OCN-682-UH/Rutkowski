## Week 03 in class work ##

install.packages("palmerpenguins")
 
## load libraries ##
library(palmerpenguins)
library(tidyverse)
glimpse(penguins)

## Lets plot bill depth & length ##

ggplot(data=penguins,
       mapping=aes(x=bill_depth_mm,
                   y=bill_length_mm,
                   color=species)) + 
  geom_point()+
  labs(title = "Bill depth and length",
       subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
       x = "Bill depth (mm)", y = "Bill length (mm)",
       color = "Species",
       caption = "Source: Palmer Sation LTER / palmerpenguins package") +
  scale_colour_viridis_d()
