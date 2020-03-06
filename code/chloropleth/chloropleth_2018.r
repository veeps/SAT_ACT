library(plotly)
library(tidyr)
library(magrittr)
library(tidyverse)

#built this chloropleth from this tutorial: https://plot.ly/r/choropleth-maps/
# give state boundaries a white border


final<- read.csv("../../data/final.csv")
states<- read.csv("../../data/states.csv") #csv from here http://worldpopulationreview.com/states/state-abbreviations/
colnames(final)[1] <- "State"


final$State <- str_to_title(final$State) #made this upper case again because I think it reads better on a map
final2 <- left_join(final,states) #merge to get state abbreviations code

df2 <- final2 %>% 
  filter(State != "District Of Columbia") #remove DC


df2$hover <- with(df2, paste(State, '<br>', "Participation:", sat_participation_2018, '<br>', "Avg Math Score:", sat_math_2018, "<br>",
                             "Avg Verbal Score:", sat_verbal_2018, '<br>', "Avg Total:", sat_total_2018))


l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

p <- plot_geo(df2, locationmode = 'USA-states') %>%
  add_trace(
    z = ~sat_participation_2018, text=~hover,  locations = ~Code,
    color = ~sat_participation_2018, colors = 'Purples'
  ) %>%
  colorbar(title = "SAT Participation 2018") %>%
  layout(
    title = 'SAT Participation Rates in 2018<br>(Hover for scores)',
    geo = g
  )

p

