[![Review Assignment Due
Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)

# Analyse : GitHub Public Repository Metadata

> Projet de *Data visualization* de l'unité d'enseignement IF36 de
> l'[Université de Technologie de Troyes (UTT)](https://www.utt.fr/).

Nom du groupe : La cité de la *f*eur.

Membres : [Baptiste Toussaint](https://github.com/I3at57),[XU Shilun](https://github.com/yvlann),

Langue : Français

------------------------------------------------------------------------

## Introduction

### Description des données.

#### Présentation de GitHub

[*GitHub*](https://github.com/) est un service web à destination des
développeurs permettant d'héberger, partager, et versionner du code.
Initialement conçu comme outil complémentaire à *Git* pour le contrôle
de version, *GitHub* est aujourd'hui une véritable plateforme de
développement utilisée par plus de 100 millions d'utilisateurs à travers
le monde.

*GitHub* voit le jour en 2008 est s'impose rapidement comme l'outil
d'hébergement en ligne privilégié des développeurs, en particulier dans
la communauté des projet open source et libres de droit.

La plateforme propose une offre gratuite performante permettant à
n'importe quelle équipe de créer et faire vivre leurs projets en ligne.
Elle propose aussi des offres payantes pour les entreprises de plus
grande taille.

Ainsi, il est possible de retrouver sur GitHub le code de grandes
compagnies comme [*Google*](https://github.com/google) ou
[*Microsoft*](https://github.com/microsoft/).

*GitHub*, les utilisateurs créent des **dépôts** (en anglais
*repositories* ou *repo* pour la version courte) qui accueil l'ensemble
des fichiers d'un programme, un logiciel, etc.

Le 8 novembre dernier, l'entreprise *GitHub* déclarait alors près de 420
millions de projets présents sur la plateforme, dont 284 millions
publics.

#### Les métadonnées de l'API GitHub

GitHub met à disposition une
[API](https://docs.github.com/en/rest/about-the-rest-api/about-the-rest-api?apiVersion=2022-11-28)
permettant aux utilisateurs d'automatiser une série de tâches en lien
avec le service. Cette API peut notamment être utilisée pour récupérer
des informations relatives à la télémétrie des dépôts : nom du dépôt,
nombre de contributeur, dates des contributions, etc.

L'utilisateur [Peter Elmers](https://pelmers.com/blog/) a développé un
[script](https://github.com/pelmers/github-repository-metadata) qui
utilise cette API pour extraire les informations (*scraping*) d'environ
trois millions de *repo* publics.

Il est important de noter que le fichier JSON de Peter Elmers ne
contient que des repos publiques (visibles de tous) possédants au
minimum 5 étoiles (l'équivalent des *like* sur la plateforme github).

Le résultat de ce script est un fichier JSON hébergé sur la plateforme
[Kaggle](https://www.kaggle.com/datasets/pelmers/github-repository-metadata-with-5-stars/data).

Pour faciliter la manipulation des données, nous avons décidé de ne
conserver que les 100000 premières entrées de ce fichier JSON pour le
moment. Cela correspond aux 100000 repos possédant le plus *d'étoiles*
sur la plateforme (les repos les plus *likés* si l'on peut se permettre
cette analogie).

Nous pourrons sans problème ajouter des données durant notre analyse si
nous en ressentons le besoin.

Nous n'excluons pas non plus de recourir à l'API de GitHub pour
augmenter les données pour améliorer l'analyse.

Le fichier JSON étant extrêmement lourd (2.34GB environ) nous avons du
légèrement le manipuler pour extraire les données

**DECRIRE LES OPERATIONS EFFECTUES**

Afin de résoudre le problème des fichiers json trop lourd, nous avons décidé d'exécuter le code python suivant dans le notebook de Kaggle pour exporter les données par sections:

    import pandas as pd

    # read json file
    json_file_path = '/kaggle/input/github-repository-metadata-with-5-stars/repo_metadata.json'
    df = pd.read_json(json_file_path)

    # every chunk row
    chunk_size = 10000

    # calculate rows
    total_rows = df.shape[0]

    # calculate the number of files
    num_files = (total_rows + chunk_size - 1) // chunk_size

    # split and output files
    for i in range(num_files):
        start_idx = i * chunk_size
        end_idx = min((i + 1) * chunk_size, total_rows)
        
        # get current data
        chunk_df = df.iloc[start_idx:end_idx]
        
        # generate file path
        output_file_path = f'/kaggle/working/data_{i + 1}.csv'
        
        # output data to csv
        chunk_df.to_csv(output_file_path, index=False)

        print(f'File {i + 1} written to {output_file_path}')


Nous avons donc dix fichiers nommés `data_X.csv` numérotés de un à dix.
Nous avons ensuite regroupé les données de ces dix fichiers dans un
unique fichier nommé `data_1_100000.csv` pour en faciliter la
manipulation.

Ces fichiers se trouvent dans dans le dossier `./data/githubStar1-10/`.

#### Présentation des données

Le jeu de données contient donc environ trois millions de dépôts
publics, tous ayant plus cinq étoiles.

Chaque objet du fichier JSON représente un dépôt décrit par les
variables suivantes (description mise en ligne par Peter Elmer
[ici](https://github.com/pelmers/github-repository-metadata)).

-   `owner`, propriétaire ou créateur du dépôt, identifié par son nom
    d'utilisateur sur la plateforme GitHub. [type : `string`] ;

-   `name`, nom du dépôt. [type : `string`] ;

-   `stars`, nombre d'étoiles, de *like* du dépot. [type : `int`] ;

-   `forks`, nombre de *fork* du projet. [type : `int`] ;

-   `watchers`, nombre d'utilisateurs surveillant le projet. [type :
    `int`] ;

-   `isFork`, précise si le dépôt est un *fork* d'un autre dépôt.
    [type:`bool`] ;

-   `isArchived`, précise si le dépôt est archivé ou non. [type :`bool`] ;

-   `languages`, une structure de type `list` regroupant les langages de
    programmation utilisés dans le projet. Chaque élément de la liste
    est composé du nom du langage et de la taille en octet, consacré à
    ce langage dans le dépôt. [type : `list`] ;

-   `languageCount`, nombre de language utilisés. [type : `int`] ;

-   `topics`, une structure de type `list` regroupant les *topics*
    associés au dépôt. Pour chaque *topic* on retrouve le nom et le
    nombre d'étoiles associées pour ce *topic* sur l'ensemble de la
    plateforme. Les *topic* permettent aux créateurs des dépôts
    d'identifier les objectifs ou catégories de leurs projets. Cela
    ressemble au système des hashtag popularisé par *Twitter*. [type :
    `list`] ;

-   `topicCount`, nombre de *topic* associés au dépôt. [type : `int`] ;

-   `diskUsageKb`, taille du dépot en kB. [type : `int`] ;

-   `pullRequests`, nombre de *pull request*. [type : `int`] ;

-   `issues`, nombre d'*issues*. [type : `int`] ;

-   `description`, description du *repo*. [type : `string`] ;

-   `primaryLanguage`, nom du langage de programmation principalement dans le projet. [type : `string`]

-   `createdAt`, date de création du dépôt. La date est au format : 
    "AAAA-MM-JJTHH:MM:SSZ", par exemple : "2015-03-14T22:35:11Z". Attention
    cependant, il faudra préciser quel fuseau horraire est utilisé par l'API pour ne pas
    fausser n'analyse. [type : `string`] ;

-   `pushedAt`, dernière date de *push* du projet, soit la dernière date de mise à jour
    du dépôt par un contributeur. Le format est identique à l'attribut `createdAt`.
    [type : `string`] ;

-   `defaultBranchCommitCount`, nombre de *commit* sur la *branche principale*. Nous
    rentrerons dans l'explication complète du système de *commit* dans l'analyse des
    données. À ce stade on peut approximer le nombre de *commit* comme le nombre
    de version du projet. [type : `int`] ;

-   `license`, license utilisée par le projet. Permet de connaître les droits donnés
    aux utilisateurs.

-   `assignableUserCount`, nombre d'utilisateurs ayant des droits d'accès sur le projet.
    [type : `int`] ;

-   `codeOfConduct`, si le projet possède un code de bonne conduite pour ses utilisateurs
    (règles de communauté), mentionne son nom. [type : `string`] ;
    
-   `forkingAllowed`, indique si il est possible de *fork* le projet : si il est possible
    d'en faire une copie. Indique vrai ou faux : `TRUE` ou `FALSE`. [type : `bool`] ;

-   `nameWithOwner`, concaténation du nom du dépôt avec le nom du créateur. [type : `string`] ;

-   `parent`, indique le nom du dépôt parent si ce dépôt est un *fork*. [type : `string`].

#### Pourquoi étudier ces données ?

Nous sommes trois étudiants de l'UTT avec un parcours tourné vers l'informatique, les
nouvelles technologies et la programmation.

GitHub est une plateforme que nous utilisons personnellement (en plus de l’utiliser pour ce projet) de manières différentes : les langages de programmation utilisées dans la branche ISI de l'UTT sont
différents des langages utilisés en branche GI.

***ON PEUT DETAILLER EN PRESENTANT NOS GITHUB RESPECTIFS ***

L'avantage de ce jeu de données est de permettre de présenter les langages de programmations utilisés dans les projets les plus populaires de la plateforme et pourquoi pas de comparer nos résultats avec nos langages préférés.

### Plan de l'analyse

