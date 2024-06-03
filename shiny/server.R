library(tidyverse)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(DT)

server <- function(input, output) {
	
	df <- read_csv("../data/data_1_200000_noDuplicates.csv")
	
	nbrRepository <- dim(df)[1]
	nbrAttributes <- dim(df)[2]
	
	custom_theme <- theme(
		panel.background = element_rect(fill = "#D9E8F1",
										colour = "#6D9EC1",
										size = 1, linetype = "solid")
	)
	
	###########################################################################
	# Page n°1 : présentation des données
	###########################################################################~
	
	# Afficher le nombre de dépôt
	output$presentData_nbrRepos <- renderInfoBox({
		infoBox(
			"Nombre de dépôts",
			nbrRepository,
			icon = icon("list"),
			color = 'purple',
			fill = TRUE
		)
	})
	
	# Date de création du premier dépôt
	output$presentData_oldestRepo <- renderInfoBox({
		infoBox(
			"Plus vieux dépôt créé le :",
			min(df$createdAt),
			icon = icon("clock"),
			color = 'purple',
			fill = TRUE
		)
	})
	
	# Nom du dépôt le plus populaire
	output$presentData_mostStaredRepoName <- renderInfoBox({
		infoBox(
			"Dépôt ayant le plus d'étoiles",
			df[1,"name"],
			icon = icon("star"),
			color = 'purple',
			fill = TRUE
		)
	})
	
	# Dataframe dynamique de toutes les données
	output$repos_1_200000 <- renderDT({
		simplified_df <- df %>% select("name", "owner", "stars", "forks", "watchers")
		simplified_df
	})
	
	output$presentData_rechercheRepo_input <- renderText({
		repoNameList <- df$name
		pattern <- pattern <- paste(".*",input$presentData_rechercheRepoName, sep="")
		matchingList <- grep(pattern, repoNameList, value = TRUE)
		paste(
			paste(matchingList[1:min(100,length(matchingList))],collapse = " "),
			"..."
		)
	})
	
	# Nom du dépôt recherché
	output$presentData_rechercheRepo_nom <- renderInfoBox({
		infoBox(
			"Dépôt ayant le plus d'étoiles",
			df[df$name == input$rechercheRepoName,"name"],
			icon = icon("house"),
			color = 'purple',
			fill = TRUE
		)
	})
	
	###########################################################################
	# Page n°2 : Répartition des étoiles
	###########################################################################~
	
	output$repartitionStars_starsPlotDistribution1 <- renderPlot({
		print(input$repartitionStars_sliderSelection1[1])
		print(input$repartitionStars_sliderSelection1[2])
		ggplot(
			data = df[df$stars >= input$repartitionStars_sliderSelection1[1] & 
					  	df$stars <= input$repartitionStars_sliderSelection1[2],]
		) +
			# Ajoute la géométrie histogramme
			geom_histogram(aes(x = stars)) +
			labs(
				x = "Nombre d'étoiles",
				y = "Nombre de dépôts",
				title = paste(
					"Répartition du nombre d'étoilespour les dépôts avec entre ",
					input$repartitionStars_sliderSelection1[1], " et ",
					input$repartitionStars_sliderSelection1[2])
			) +
			custom_theme
	})
	
	output$repartitionStars_starsPlotDistribution2 <- renderPlot({
		print(input$repartitionStars_sliderSelection2[1])
		print(input$repartitionStars_sliderSelection2[2])
		ggplot(
			data = df[df$stars >= input$repartitionStars_sliderSelection2[1] & 
					  	df$stars <= input$repartitionStars_sliderSelection2[2],]
		) +
			# Ajoute la géométrie histogramme
			geom_histogram(aes(x = stars)) +
			labs(
				x = "Nombre d'étoiles",
				y = "Nombre de dépôts",
				title = paste(
					"Répartition du nombre d'étoilespour les dépôts avec entre ",
					input$repartitionStars_sliderSelection2[1], " et ",
					input$repartitionStars_sliderSelection2[2])
			) +
			custom_theme
	})

}
