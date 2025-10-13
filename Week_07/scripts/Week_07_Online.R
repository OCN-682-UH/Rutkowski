## Week 07 MBIO 612 Learning how to map in R
## Created by Emily C Rutkowski
## October, 9, 2025

## Load libraries
library(tidyverse)
library(ggmap)
library(ggspatial)
library(here)

## Load in data 

ChemData<- read_csv(here("Week_07", "data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)
view(ChemData)

## Get base maps from ggmap
Oahu<-get_map("Oahu")
ggmap(Oahu)

## Make a data frame of lon and lat coordinates

WP<-data.frame(lon = -157.7621, lat = 21.27427) #coordinates for Wailupe, put it at the center

## Get base layer
Map1<-get_map(WP)

# plot it
ggmap(Map1)

# Zoom in on a location
# 3 is super zoomed out, 20 is super zzomed in

Map1<-get_map(WP,zoom = 17)
ggmap(Map1)

# Change the map type

Map1<-get_map(WP, zoom = 17, maptype = "satellite")
ggmap(Map1)

# Make a beautiful map
Map1<-get_map(WP, zoom = 16, maptype = "stamen_watercolor", source = "stadia")
ggmap(Map1)

# You can use the ggmap base layer in any ggplot
Map1<-get_map(WP,zoom = 17, maptype = "satellite")
ggmap(Map1)+
  geom_point(data = ChemData,
             aes(x = Long, y = Lat, color = Salinity),
             size = 4) +
  scale_color_viridis_c()

# Add a scale bar
Map1<-get_map(WP,zoom = 17, maptype = "satellite")
ggmap(Map1)+
  geom_point(data = ChemData,
             aes(x = Long, y = Lat, color = Salinity),
             size = 4) +
  scale_color_viridis_c() +
  annotation_scale( bar_cols = c("yellow", "white"),
                   location = "bl")+ # put the bar on the bottom left and make the colors yellow and white
  annotation_north_arrow(location = "tl")+ # add a north arrow
  coord_sf(crs = 4326) # for the scale bar to work it needs to be in this coordinate system - this is a typical coordinate reference system for a GPS (WGS84)
# ? annotation_scale and annotation_north_arrow to learn more 

# Dont know the exact lat and long?
# Use geo_code to get exact locations that you can then use in the maps

geocode("the white house")
geocode("University of Hawaii at Manoa")
