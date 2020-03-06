library(plotly)
library(tidyr)
library(magrittr)
library(tidyverse)

#built this chloropleth from this tutorial: https://plot.ly/r/choropleth-maps/
# give state boundaries a white border


ui <- fluidPage(
  titlePanel("2017 Educational Spending  - Amount in $Million"),
  mainPanel(plotlyOutput("plot"), width = 20),
            fluidRow("States that decreased in SAT participation between 2017 and 2018: Florida, DC, Arizona, Nevada"),
            fluidRow("States that increased in ACT participation between 2017 and 2018: Nebraska, Ohio, Iowa, New Mexico, Arizona, Oregon, and Maryland"),
            fluidRow(uiOutput("url1"))
            )

    
    
server <- function(input, output, session) {    
df2<- read.csv("data/final_chloropleth.csv")

#data sources
budget_url <- a("State Budgets,", href="https://www.census.gov/programs-surveys/school-finances.html")  
sat_url <-a ("SAT,", href="https://blog.collegevine.com/here-are-the-average-sat-scores-by-state")
act_url <- a("ACT.", href="https://blog.prepscholar.com/act-scores-by-state-averages-highs-and-lows")

output$url1 <- renderUI({
  tagList("Data Sources:", budget_url, sat_url, act_url)
})
  

output$plot <- renderPlotly({

l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

plot_geo(df2, locationmode = 'USA-states') %>%
  add_trace(
    z = ~Spending, text=~hover,  locations = ~Code,
    color = ~Spending, colors = 'Greens'
  ) %>%
  colorbar(title = "2017 State Educational Spending") %>%
  layout(
    geo = g
  )

})

}

shinyApp(ui, server)
