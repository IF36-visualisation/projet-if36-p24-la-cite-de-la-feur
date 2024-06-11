library(tidyverse)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(DT)

server <- function(input, output) {
	
	df <- read_csv("../data/data_1_200000_noDuplicates.csv")
	
	nbrRepository <- dim(df)[1]
	nbrAttributes <- dim(df)[2]
	
	df_filtered <- df[df$languageCount > 0 , ]
	
	# Convertir CreateAt au format de date et extraire l'année
	df_filtered <- df_filtered %>%
	  mutate(year = lubridate::year(as.Date(createdAt)))
	
	
	language_distribution <- df_filtered %>%
	  group_by(primaryLanguage) %>%
	  summarise(count = n()) %>%
	  arrange(desc(count))
	
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
		repoNameList <- df$nameWithOwner
		pattern <- input$presentData_rechercheRepoName
		matchingList <- grep(pattern, repoNameList, value = TRUE)
		paste(
			paste(matchingList[1:min(50,length(matchingList))], collapse = "\n"),
			"..."
		)
	})
	
	# output$presentData_rechercheRepo_input <- renderPrint({
	# 	repoNameList <- df$name
	# 	pattern <- pattern <- paste(".*",input$presentData_rechercheRepoName, sep="")
	# 	matchingList <- grep(pattern, repoNameList, value = TRUE)
	# 	writeLines(
	# 		paste(matchingList[1:min(100,length(matchingList))],collapse = "\n")
	# 	)
	# })
	
	
	# Nom du dépôt recherché
	output$presentData_rechercheRepo_nom <- renderInfoBox({
		infoBox(
			"Dépôt ayant le plus d'étoiles",
			df[
				df$name == input$presentData_rechercheRepoName | df$nameWithOwner == input$presentData_rechercheRepoName,
				"name"
			],
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
	
	###########################################################################
	# Page n°3 : Répartition des langues
	###########################################################################~
	output$etudeLangues_languesPlotDistribution <- renderPlot({
	  
	  
	  ggplot(language_distribution[language_distribution$count >= input$etudeLangues_sliderSelection1[1] & language_distribution$count <= input$etudeLangues_sliderSelection1[2],], aes(x = reorder(primaryLanguage, -count), y = count)) +
	    geom_bar(stat = "identity") +
	    
	    labs(title = "Distribution de la popularité du langage de programmation GitHub",
	         x = "Langage de programmation",
	         y = "Fréquence") +
	    custom_theme
	})
	
	output$etudeLangues_languesPlotTendance <- renderPlot({
	  # Regroupés par année et langage de programmation, comptez le nombre d'entrepôts dans chaque langue par an
	  language_count <- df_filtered[df_filtered$year <= input$etudeLangues_sliderSelection2[2] & df_filtered$year >= input$etudeLangues_sliderSelection2[1],] %>%
	    group_by(year, primaryLanguage) %>%
	    summarise(count = n()) %>%
	    ungroup()
	  
	  # Calculer le nombre cumulé de chaque langue par an
	  language_count <- language_count %>%
	    group_by(primaryLanguage) %>%
	    mutate(cumulative_count = cumsum(count)) %>%
	    ungroup()
	  
	  # Filtrer les langues choisi
	  selected_languages <- language_distribution[language_distribution$count >= input$etudeLangues_sliderSelection1[1] & language_distribution$count <= input$etudeLangues_sliderSelection1[2],]%>%
	    pull(primaryLanguage)
	  
	  # Dessiner un graphique linéaire
	  ggplot(language_count %>% filter(primaryLanguage %in% selected_languages), aes(x = year, y = cumulative_count, color = primaryLanguage)) +
	    geom_line() +
	    geom_text(data = language_count %>% filter(primaryLanguage %in% selected_languages) %>% group_by(primaryLanguage) %>% filter(year == max(year)), aes(label = primaryLanguage), vjust = -0.5, nudge_y = 1000, check_overlap = TRUE) +
	    labs(x = "Year", y = "Nombre cumulé",title = paste(
	      "Nombre cumulé annuel des langues entre ",
	      input$etudeLangues_sliderSelection2[1], " et ",
	      input$etudeLangues_sliderSelection2[2]) )
	      
	})
	
}
