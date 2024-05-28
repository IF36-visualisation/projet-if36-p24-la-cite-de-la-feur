# Ce premier ichier permet d'effectuer quelques prêt traitement des données.
# Le fichier ui contient l'ensemble des éléments relatifs à l'ui
# Le fichier server contient les fonctions de routine métier

# nettoie la mémoire
# rm(list=ls())

library(tidyverse)

source("./server.R")
source("./ui.R")

shinyApp(ui, server)