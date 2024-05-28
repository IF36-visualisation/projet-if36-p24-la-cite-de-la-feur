# Les packages sont déjà chargé dans le fichier server
# 
# 
# 

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
			tabName = "present_data",
			icon = icon("fa-solid-fa-file")
		),
		
		# Onglet Analyse quantitative
		menuItem(
			"Analyse quantitative",
			tabName = "quanti_analyse",
			icon = icon("fa-solid-fa-cubes")
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
				tabName = "present_data",
				
				# Header de l'onglet
				tags$header(
					h1("Présentation des données : 3 Million Github Repositories"),
					p(em(
							"Données par Peter Elmers (", a("https://pelmers.com/blog/"),
							") publiées sur Kaagle (",
							a("https://www.kaggle.com/datasets/pelmers/github-repository-metadata-with-5-stars/data"),
							")."
						)),
					p(em("Créateurs du Dashbord : Baptiste Toussaint, "))
				),
				
				# Body de l'onglet
				tags$body(
					splitLayout(
						
						h1('salut'),
						
						tabsetPanel(
							tabPanel('Liste', DTOutput('repos_1_200000')),
							tabPanel('Recherche')
						)
						
					)
				)
			)
			
			# Onglet Analyse quantitative
		)
	)
)