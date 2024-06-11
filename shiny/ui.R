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
		sidebarMenu(
			id = 'tabs',
			# Onglet présentation des données
			menuItem(
				"Présentation des données",
				tabName = "presentData",
				icon = icon("dashboard")
			),
			
			# Onglet Répartition des stars
			menuItem(
				"Répartition des étoiles",
				tabName = "repartitionStars",
				icon = icon("th")
			),
			# Onglet Répartition des langues
			menuItem(
			  "Répartition des langues",
			  tabName = "repartitionLangues",
			  icon = icon("th")
			),
			selected = "presentData"
		)
	),
	
	# body
	dashboardBody(
		
		tags$head(
			tags$style(type = "text/css", "
			
			#presentData_rechercheRepo_input {
				white-space: pre-line;
			}
			
			#presentData_rechercheRepo_nom {
				width: 75%;
			}
			
          "
			)
		),
		
		
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
					p(em("Créateurs du Dashbord : Baptiste Toussaint, Shilun XU"))
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
									class = 'infoBoxes',
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
			,
			
			# Onglet Répartition des langues
			tabItem(
			  tabName = "repartitionLangues",
			  h1("Graphiques montrant la répartition et la tendance des langues sur les dépôts"),
			  fluidRow(
			    box(
			      h2("La répartition des langues"),
			      plotOutput("etudeLangues_languesPlotDistribution"),
			      sliderInput("etudeLangues_sliderSelection1",
			                  "Fréquence:",
			                  min = 0,
			                  max = 40000,
			                  value = c(5000,40000))
			    ),
			    box(
			      h2("La tendance des langues"),
			      plotOutput("etudeLangues_languesPlotTendance"),
			      sliderInput("etudeLangues_sliderSelection2",
			                  "Année entre:",
			                  min = 2009,
			                  max = 2024,
			                  value = c(2009,2024))
			    )
			  ),
			  h2("Explications"),
			  p("Nous pouvons filtrer un ou plusieurs langages de programmation que nous souhaitons étudier en fonction du tableau de distribution et visualiser les tendances changeantes des langages de programmation sélectionnés sur une période de temps.",br(),
			    "Sur la figure, nous pouvons voir que python et JavaScript étaient les premiers langages de nombreux entrepôts au début, mais leur utilisation a considérablement augmenté vers 2016 et est finalement devenue le taux d'utilisation de ces deux langages que nous voyons maintenant.")
			)
		)
	)
)