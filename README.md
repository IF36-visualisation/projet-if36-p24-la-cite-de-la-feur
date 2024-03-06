[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)

# Analyse : GitHub Public Repository Metadata

> Projet de *Data visualization* de l'unité d'enseignement IF36 de l'[Université de Technologie de Troyes (UTT)](https://www.utt.fr/).

Nom du groupe : La cité de la *f*eur.

Membres : [Baptiste Toussaint](https://github.com/I3at57),

Langue : Français

---

## Introduction

### Description des données.

#### Présentation de GitHub

*[GitHub](https://github.com/)* est un service web à destination des développeurs permettant d'héberger, partager, et versionner du code.
Initialement conçu comme outil complémentaire à *Git* pour le contrôle de version,
*GitHub* est aujourd'hui une véritable plateforme de développement utilisée par plus de 100 millions d'utilisateurs à travers le monde.

*GitHub* voit le jour en 2008 est s'impose rapidement comme l'outil d'hébergement en ligne privilégié des développeurs, en particulier dans la communauté des projet open source et libres de droit.

La plateforme propose une offre gratuite performante permettant à n'importe quelle équipe de créer et faire vivre leurs projets en ligne. Elle propose aussi des offres payantes pour les entreprises de plus grande taille.

Ainsi, il est possible de retrouver sur GitHub le code de grandes compagnies comme *[Google](https://github.com/google)* ou *[Microsoft](https://github.com/microsoft/)*.

*GitHub*, les utilisateurs créent des **dépôts** (en anglais *repositories* ou *repo* pour la version courte) qui accueil l'ensemble des fichiers d'un programme, un logiciel, etc.

Le 8 novembre dernier, l'entreprise *GitHub* déclarait alors près de 420 millions de projets présents sur la plateforme, dont 284 millions publics [](https://github.blog/2023-11-08-the-state-of-open-source-and-ai/).

#### Les métadonnées de l'API GitHub

GitHub met à disposition une [API](https://docs.github.com/en/rest/about-the-rest-api/about-the-rest-api?apiVersion=2022-11-28) permettant aux utilisateurs d'automatiser une série de tâches en lien avec le service. Cette API peut notamment être utilisée pour récupérer des informations relatives à la télémétrie des dépôts : nom du dépôt, nombre de contributeur, dates des contributions, etc.

L'utilisateur [Peter Elmers](https://pelmers.com/blog/) a développé un [script](https://github.com/pelmers/github-repository-metadata) qui utilise cette API pour extraire les informations (*scraping*) d'environ trois millions de *repo* publics.

Le résultat de ce script est un fichier JSON hébergé sur la plateforme *[Kaggle](https://www.kaggle.com/datasets/pelmers/github-repository-metadata-with-5-stars/data).

#### Présentation des données

Le jeu de données contient donc environ trois millions de dépôts publics, tous ayant plus cinq étoiles. Chaque objet du fichier JSON représente un dépôt décrit par les variables suivantes :

- `owner` (propriaitaire ou créateur du dépôt) [type : `string`] ;
- `name` (nom du dépôt) [type : `string`] ;
- `stars` (nombre d'étoiles) [type : `int`] ;
- `forks` (nombre de *fork* du projet) [type : `int`] ;
- `watchers` (nombre d'utilisateurs surveillant le projet) [type : `int`] ;
- `isFork` (précise si le dépôt est un *fork* d'un autre dépôt) [type : `bool`] ;
- `isArchived` (précise si le dépôt est archivé ou non) [type : `bool`] ;
- `languages` (une structure de type `list` regroupant les langages de programmation utilisés dans le projet. Chaque élément de la liste est composé du nom du langage et de la taille en octet, consacré à ce langage dans ce dépôt) ;
- `languageCount` (nombre de language utilisés) [type : `int`] ;
- `topics` (une structure de type `list` regroupant les *topics* associés au dépôt. Pour chaque *topic* on retrouve le nom et le nombre d'étoiles associées.) ;
- `topicCount`(nombre de *topic*) [type : `int`] ;
`diskUsageKb` (taille du dépot en kB) [type : `int`] ;
`pullRequests` (nombre de *pull request*) [type : `int`] ;
`issues` (nombre d'*issues*) [type : int] ;
`description`:string"freeCodeCamp.org's open-source codebase and curriculum. Learn to code for free."
`primaryLanguage`:string"TypeScript"
"createdAt":string"2014-12-24T17:49:19Z"
"pushedAt":string"2023-08-18T08:50:17Z"
"defaultBranchCommitCount":int33585
"license":string"BSD 3-Clause "New" or "Revised" License"
"assignableUserCount":int48
"codeOfConduct":string"Other"
"forkingAllowed":booltrue
"nameWithOwner":string"freeCodeCamp/freeCodeCamp"
"parent":NULL

---