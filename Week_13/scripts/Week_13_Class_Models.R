## Week 13 - Intro to Modeling 

install.packages('modelsummary') # to show model output
install.packages('tidymodels') # for tidy models
install.packages('broom') # for clean model output
install.packages('flextable') # to look at model results in a nice table
install.packages('peformance') # to check model assumptions
install.packages('see') # needs to be installed, but does not need to be loaded in the library, required for performance

library(tidyverse)
library(here)
library(palmerpenguins)
library(broom)
library(performance) 
library(modelsummary)
library(tidymodels)

# Anatomy of a basic linear model 

# To run a simple linear model you use the following formula:
mod<-lm(y~x, data = df)
#lm = linear model, y = dependent variable, x = independent variable(s), df = dataframe.
#You read this as y is a function of x

#Multiple regression
mod<-lm(y~x1 + x2, data = df)

#Interaction term
mod<-lm(y~x1*x2, data = df) the * will compute x1+x2+x1:x2

# Model the penguin dataset
# Linear model of Bill depth ~ Bill length by species
Peng_mod<-lm(bill_length_mm ~ bill_depth_mm*species, data = penguins)
check_model(Peng_mod) # check assumptions of an lm model


# View Results: base R

# ANOVA Table
anova(Peng_mod)

#Coefficients (effect size) with error
summary(Peng_mod)

##View results with broom
# Tidy coefficients
coeffs<-tidy(Peng_mod) # just put tidy() around it
coeffs

#glance extracts R-squared, AICs, etc of the model
# tidy r2, etc
results<-glance(Peng_mod) 
results

#augment add residuals and predicted values to your original data and requires that you put both the model and data
# tidy residuals, etc
resid_fitted<-augment(Peng_mod)
resid_fitted

# Model Summary 

# Export summary tables to word, markdown, or tex document. You can also modify the tables to make them pub quality.
# New model
Peng_mod_noX<-lm(bill_length_mm ~ bill_depth_mm, data = penguins)
#Make a list of models and name them
models<-list("Model with interaction" = Peng_mod,
             "Model with no interaction" = Peng_mod_noX)
#Save the results as a .docx
modelsummary(models, output = here("Week_13","output","table.docx")) # need package "pandoc" for this 

# Model Plot
# Canned coefficient modelplots
#library(wesanderson)
modelplot(models) +
  labs(x = 'Coefficients', 
       y = 'Term names') +
  scale_color_manual(values = wes_palette('Darjeeling1'))


#Let's say you want to plot and compare lots of different models at the same time and view the results. 
models<- penguins %>%
  ungroup()%>% # the penguin data are grouped so we need to ungroup them
  nest(.by = species) %>% # nest all the data by species
  mutate(fit = map(data, ~lm(bill_length_mm~body_mass_g, data = .))) #map a model to each of the groups in the list
models
models$fit # shows you each of the 3 models

# view the results 
#First, let's mutate the models list so that we have a tidy coefficient dataframe (using tidy()) and a tidy model results dataframe (using glance())
results<-models %>%
  mutate(coeffs = map(fit, tidy), # look at the coefficients
         modelresults = map(fit, glance))%>%  # R2 and others
  select(species, coeffs, modelresults) %>% # only keep the results
  unnest() # put it back in a dataframe and specify which columns to unnest
results
view(results) # view the results


## Tidy Models 
lm_mod<-linear_reg() %>%
  set_engine("lm") %>%
  fit(bill_length_mm ~ bill_depth_mm*species, data = penguins) %>%
  tidy() %>%
  ggplot()+
  geom_point(aes(x = term, y = estimate))+
  geom_errorbar(aes(x = term, ymin = estimate-std.error,
                    ymax = estimate+std.error), width = 0.1 )+
  coord_flip()
lm_mod