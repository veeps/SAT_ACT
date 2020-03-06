library(plotly)
library(tidyr)
library(magrittr)
library(tidyverse)

final<- read.csv("data/final.csv")
states<- read.csv("data/states.csv") #csv from here http://worldpopulationreview.com/states/state-abbreviations/
colnames(final)[1] <- "State"
budget <- read.csv("data/states_budget_gov.csv") #data from here https://www.census.gov/programs-surveys/school-finances.html

final$State <- str_to_title(final$State) #made this upper case again because I think it reads better on a map
final2 <- left_join(final,states) #merge to get state abbreviations code

budget$Spending<- round((budget$Spending/1000000), 2) #divide by million to display number in millions by 2 decimals


final3 <- left_join(final2,budget)


df2 <- final3 %>% 
  filter(State != "District Of Columbia") #remove DC because we don't have DC to plot as a state


df2$hover <- with(df2, paste(State, '<br>', "SAT 2017:", sat_participation_2017, '<br>', 
                             "SAT 2018:", sat_participation_2018, "<br>",
                             "ACT 2017:", act_participation_2017, '<br>', 
                             "ACT 2018:", act_participation_2018))

#write_csv(df2, "../../data/final_chloropleth.csv") #write final df to csv so I can read it in on shiny app
