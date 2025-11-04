## Week 10b Online Lecture: Asking for help in R lecture
## Created by: Emily Rutkowski
## November 2 2025

## Load libraries
library(tidyverse)
library(here)
library(reprex) # reproducible example
library(datapasta) #copy and paste 
library(styler) # copy and paste in style 

# Making a reproducble example to ask for help
  # By running code with {reprex} you can create a reproducible example to post to Stack Overflow, Slack, GitHub, or email. 

mpg %>%
  ggplot(aes(x = displ, y = hwy)) %>%
  geom_point(aes(colour = class))
# Error in `geom_point()`:
# ! `mapping` must be created by `aes()`.
# ✖ You've supplied a <ggplot2::ggplot> object.
# ℹ Did you use `%>%` or `|>` instead of `+`?

# Highlight code in question. Go to Tools > Addins > Render Reprex > paste to the program you want. "append session info" 

#Using real data

lat	long	star_no
33.548	-117.805	10
35.534	-121.083	1
39.503	-123.743	25
32.863	-117.24	22
33.46	-117.671	8
33.548	-117.805	3
33.603	-117.879	15
34.39	-119.511	23

# useless
# datapasta allows us to copy and paste our data in reproducible ways
# Copy data. Go to Tools > Addins > datapasta(as a tribble) > Execute 
df<-tibble::tribble( # can give a name now 
    ~lat,    ~long, ~star_no,
  33.548, -117.805,      10L,
  35.534, -121.083,       1L,
  39.503, -123.743,      25L,
  32.863,  -117.24,      22L,
   33.46, -117.671,       8L,
  33.548, -117.805,       3L,
  33.603, -117.879,      15L,
   34.39, -119.511,      23L
  )
df
