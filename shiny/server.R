library(shiny)
library(shinydashboard)
library(DT)

server <- function(input, output) {
	
	df <- read_csv("../data/data_1_200000.csv")
	
	output$repos_1_200000 <- renderDT({
		simplified_df <- df %>% select("name", "owner", "stars", "forks", "watchers")
		simplified_df
	})
}