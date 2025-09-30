## Week 5b Lecture- Data Wrangling: lubridate dates and times 
## Mbio 612 Data Fundamentals in R
## Created by: Emily C Rutkowski
## Sept 28, 2025

## Load libraries ##
library(tidyverse)
library(here)
library(lubridate) # package to deal with dates and times 
library(ggplot2)
library(ggthemes)
library(PNWColors)
library(here)
library(praise)

##############################

now() #what time is it now?
now(tzone = "EST") # what time is it on the east coast
now(tzone = "GMT") # what time in GMT
today() #gives date 
today(tzone = "GMT") #gives date in x time zone 
am(now()) # is it morning? Will give TRUE or FALSE
leap_year(now()) # is it a leap year? Will give TRUE or FALSE

## date specifications#
# Dates must be a character! So must be in parenthases
# convert to ISO dates
ymd("2021-02-24")
mdy("02/24/2021")
mdy("February 24 2021")
dmy("24/02/2021")

## Dates and times ##
## Its going to assume military time unless AM/PM is used 
ymd_hms("2021-02-24 10:22:20 PM")
mdy_hms("02/24/2021 22:22:20")
mdy_hm("February 24 2021 10:22 PM")
mdy_hm("2021-02-24 10:22:20") # Failed 

## Extracting specific date or time elements from datetimes 
# Lets make a vector of dates 

# Make a character string 
datetimes<-c("02/24/2021 22:22:20", # Must all be in same format to work 
             "02/25/2021 11:21:10",
             "02/26/2021 8:01:52")
# Convert to datetimes 
datetimes <- mdy_hms(datetimes)
month(datetimes) # extracts the months from the character string/vector: gives 2 2 2
month(datetimes, label = TRUE) # gives label in name of month, now a factor
month(datetimes, label = TRUE, abbr = FALSE) #spells out month
day(datetimes) # extract day, useful if you want to get an avg by day 
wday(datetimes, label = TRUE) # extract day of the week 
hour(datetimes) # extract hours
minute(datetimes) # extract minutes 
second(datetimes) # extract seconds 

## if you want to change the date/time
datetimes + hours(4) # this adds 4 hours 
datetimes + days(2) # this adds 2 days 
# Can also do the same with munites(), seconds(), months(), years(). 

## Rounding dates 

round_date(datetimes, "minute") # round to nearest minute
round_date(datetimes, "5 mins") # round to nearest 5 minute 

## Load data for Challenge ##

CondData<-read_csv(here("Week_05", "data", "CondData.csv"))
view(CondData)

Cond_datetime<- CondData %>% # give dataset name
  mutate(datetime = mdy_hms(date)) # change date column to datetime format & give new column name 
view(Cond_datetime) # view dataset with new column 

