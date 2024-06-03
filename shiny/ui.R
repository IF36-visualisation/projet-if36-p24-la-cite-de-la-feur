# Les packages sont déjà chargé dans le fichier server
# 
# 
# 

library(shiny)
library(shinydashboard)
library(DT)

ui <- dashboardPage(
	
	# change la couleur du dashbord
	skin = 'purple',
	
	# Header
	dashboardHeader(
		title = "La cité de la Feur"
	),
	
	# Navigation
	dashboardSidebar(
		# Onglet présentation des données
		menuItem(
			"Présentation des données",
			tabName = "presentData",
			icon = icon("dashboard")
		),
		
		# Onglet Répartition des stars
		menuItem(
			"Attribution des étoiles",
			tabName = "repartitionStars",
			icon = icon("th")
		)
	),
	
	# body
	dashboardBody(
		tabItems(
			
			# Onglet Présentation des données
			# Première page destinée à un récapitulatif des éléments importants
			# sur le jeu de données.
			# Les infos utiles :
			# - nombre de repo
			# - dates couvertes
			tabItem(
				tabName = "presentData",
				
				# Header de l'onglet
				tags$header(
					h1("Présentation des données : 3 Million Github Repositories"),
					p(em(
							"Données par Peter Elmers (", a("https://pelmers.com/blog/"),
							") publiées sur Kaagle (",
							a("https://www.kaggle.com/datasets/pelmers/
							  github-repository-metadata-with-5-stars/data"),
							")."
						)),
					p(em("Créateurs du Dashbord : Baptiste Toussaint, "))
				),
				
				# Body de l'onglet
				tags$body(
					fluidRow(
						infoBoxOutput("presentData_nbrRepos"),
						infoBoxOutput("presentData_oldestRepo"),
						infoBoxOutput("presentData_mostStaredRepoName")
					),
					tabsetPanel(
						tabPanel('Liste', DTOutput('repos_1_200000')),
						tabPanel(
							'Recherche',
							fluidRow(
								box(
									textInput("presentData_rechercheRepoName", "Nom du dépot:"),
									textOutput("presentData_rechercheRepo_input")
								),
								box(
									infoBoxOutput("presentData_rechercheRepo_nom")
								)
							)
						)
					)
				)
			),
			
			# Onglet Répartition des stars
			tabItem(
				tabName = "repartitionStars",
				h1("Graphiques montrant la répartition des étoiles sur les dépôts"),
				fluidRow(
					box(
						h2("Toutes les données"),
						plotOutput("repartitionStars_starsPlotDistribution1"),
						sliderInput("repartitionStars_sliderSelection1",
									"Nombre d'étoiles :",
									min = 0,
									max = 400000,
									value = c(17476,400000))
					),
					box(
						h2("Seulement entre 0 et 10000 étoiles"),
						plotOutput("repartitionStars_starsPlotDistribution2"),
						sliderInput("repartitionStars_sliderSelection2",
									"Nombre d'étoiles :",
									min = 0,
									max = 10000,
									value = c(0,10000))
					)
				),
				h2("Explications"),
				p("On remarque que le nombre d'étoile sur les dépôts suit une distribution
				  simmilaire quelque soit l'interval observé.",
				  "La majorité des dépôts on peut d'étoiles et la queue de distribution
				  s'affine rapidement, avec peu de dépôts ayant beaucoup d'étoiles.",
				  "Quel que soit la partie de nos données que l'on souhaite observer,
				  on retrouve une structure similaire, avec la majorité des dépôts
				  sur le début de notre intervalle d'observation.")
			)
		)
	)
)