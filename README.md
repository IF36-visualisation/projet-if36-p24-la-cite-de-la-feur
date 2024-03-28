[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)

```{=html}
<! -- Uniquement pour les couleurs de titre -->
<! -- De préférence utiliser un logiciel pour lire du Markdown car le site GitHub affiche le block de HTML tel quel -->

<style>
    blue {
        color: #032ac5;
    }
</style>
```
# Analyse : GitHub Public Repository Metadata

> Projet de *Data visualization* de l'unité d'enseignement IF36 de l'[Université de Technologie de Troyes (UTT)](https://www.utt.fr/).

Nom du groupe : ***La cité de la*** <blue>f</blue>eur.

Membres : [Baptiste Toussaint](https://github.com/I3at57), [XU Shilun](https://github.com/yvlann), [Louis Duhal Berruer](https://github.com/louisduhalberruer)

Langue : Français

------------------------------------------------------------------------

## <blue>Introduction</blue>

### <blue>1. Description des données.</blue>

#### <blue>1.1. Présentation de GitHub</blue>

<center><img src="./src/img/GitHub_Logo.png" alt="Logo de la mascotte de GitHub" width="200" margin="20"/> <img src="./src/img/github-mark.png" alt="Logo de GitHub" width="100" margin="20"/></center>

> Logo de GitHub et de sa mascotte : Octocat

[*GitHub*](https://github.com/) est un service web à destination des développeurs permettant d'héberger, partager, et versionner du code. Initialement conçu comme outil complémentaire à *Git* pour le contrôle de version, *GitHub* est aujourd'hui une véritable plateforme de développement utilisée par plus de 100 millions d'utilisateurs à travers le monde.

*GitHub* voit le jour en 2008 et s'impose rapidement comme l'outil d'hébergement en ligne privilégié des développeurs, en particulier dans la communauté des projet open source et libres de droit.

La plateforme propose une offre gratuite performante permettant à n'importe quelle équipe de créer et faire vivre leurs projets en ligne. Elle propose aussi des offres payantes pour les entreprises de plus grande taille.

Ainsi, il est possible de retrouver sur GitHub le code de grandes compagnies comme [*Google*](https://github.com/google) ou [*Microsoft*](https://github.com/microsoft/).

*GitHub*, les utilisateurs créent des **dépôts** (en anglais *repositories* ou *repo* pour la version courte) qui accueillent l'ensemble des fichiers d'un programme, un logiciel, etc.

Le 8 novembre dernier, l'entreprise *GitHub* déclarait alors près de 420 millions de projets présents sur la plateforme, dont 284 millions publics.

#### <blue>1.2. Les métadonnées de l'API GitHub</blue>

GitHub met à disposition une [API](https://docs.github.com/en/rest/about-the-rest-api/about-the-rest-api?apiVersion=2022-11-28) permettant aux utilisateurs d'automatiser une série de tâches en lien avec le service. Cette API peut notamment être utilisée pour récupérer des informations relatives à la télémétrie des dépôts : nom du dépôt, nombre de contributeur, dates des contributions, etc.

L'utilisateur [Peter Elmers](https://pelmers.com/blog/) a développé un [script](https://github.com/pelmers/github-repository-metadata) qui utilise cette API pour extraire les informations (*scraping*) d'environ trois millions de *repo* publics.

Il est important de noter que le fichier JSON de Peter Elmers ne contient que des repos publiques (visibles de tous) possédants au minimum 5 étoiles (l'équivalent des *like* sur la plateforme github).

Le résultat de ce script est un fichier JSON hébergé sur la plateforme [Kaggle](https://www.kaggle.com/datasets/pelmers/github-repository-metadata-with-5-stars/data).

Pour faciliter la manipulation des données, nous avons décidé de ne conserver que les 200000 premières entrées de ce fichier JSON pour le moment. Cela correspond aux 200000 repos possédant le plus *d'étoiles* sur la plateforme (les repos les plus *likés* si l'on peut se permettre cette analogie).

Nous pourrons sans problème ajouter des données durant notre analyse si nous en ressentons le besoin.

Nous n'excluons pas non plus de recourir à l'API de GitHub pour augmenter les données pour améliorer l'analyse.

Afin de résoudre le problème des fichiers json trop lourd, nous avons décidé d'exécuter le code python suivant dans un notebook de sur Kaggle pour exporter les données par sections en format de CSV:

```         
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
```

Nous avons donc dix fichiers nommés `data_X.csv` numérotés de 1 à 10. Les dix premiers fichiers sont rangés dans le dossier : `githubStar1-10`, les dix suivants sont rangés dans le dossier : `githubStar11-20`.

Nous avons ensuite regroupé les données de ces vingts fichiers dans un unique fichier nommé `data_1_200000.csv` pour en faciliter la manipulation.

Ces fichiers se trouvent dans le dossier `./data/` de ce dépôt.

#### <blue>1.3. Présentation des données</blue>

Le jeu de données contient donc environ trois millions de dépôts publics, tous ayant plus de cinq étoiles (nous reviendrons plus loin sur la signification de ces étoiles).

Chaque objet du fichier JSON représente un dépôt décrit par les variables suivantes (description mise en ligne par Peter Elmer [ici](https://github.com/pelmers/github-repository-metadata)).

-   `owner`, propriétaire ou créateur du dépôt, identifié par son nom
d'utilisateur sur la plateforme GitHub. [type : `string`] ;

-   `name`, nom du dépôt. [type : `string`] ;

-   `stars`, nombre d'étoiles, de *like* du dépôt. [type : `int`] ;

-   `forks`, nombre de *fork* du projet. [type : `int`] ;

-   `watchers`, nombre d'utilisateurs surveillant le projet. [type : `int`] ;

-   `isFork`, précise si le dépôt est un *fork* d'un autre dépôt. [type:`bool`] ;

-   `isArchived`, précise si le dépôt est archivé ou non. [type :`bool`] ;

-   `languages`, une structure de type `list` regroupant les langages de programmation utilisés dans le projet. Chaque élément de la liste est composé du nom du langage et de la taille en octet, consacré à ce langage dans le dépôt. [type : `list`] ;

-   `languageCount`, nombre de langage utilisés. [type : `int`] ;

-   `topics`, une structure de type `list` regroupant les *topics* associés au dépôt. Pour chaque *topic* on retrouve le nom et le nombre d'étoiles associées pour ce *topic* sur l'ensemble de la plateforme. Les *topic* permettent aux créateurs des dépôts d'identifier les objectifs ou catégories de leurs projets. Cela ressemble au système des *hashtag* popularisé par *Twitter*. [type : `list`] ;

-   `topicCount`, nombre de *topic* associés au dépôt. [type : `int`] ;

-   `diskUsageKb`, taille du dépôt en kB. [type : `int`] ;

-   `pullRequests`, nombre de *pull request*. [type : `int`] ;

-   `issues`, nombre d'*issues*. [type : `int`] ;

-   `description`, description du *repo*. [type : `string`] ;

-   `primaryLanguage`, nom du langage de programmation principalement dans le projet. [type : `string`] ;

-   `createdAt`, date de création du dépôt. La date est au format : "AAAA-MM-JJTHH:MM:SSZ", par exemple : "2015-03-14T22:35:11Z". Attention cependant, il faudra préciser quel fuseau horaire est utilisé par l'API pour ne pas fausser n'analyse. [type : `string`] ;

-   `pushedAt`, dernière date de *push* du projet, soit la dernière date de mise à jour du dépôt par un contributeur. Le format est identique à l'attribut `createdAt`. [type : `string`] ;

-   `defaultBranchCommitCount`, nombre de *commit* sur la *branche principale*. Nous rentrerons dans l'explication complète du système de *commit* dans l'analyse des données. À ce stade on peut approximer le nombre de *commit* comme le nombre de version du projet. [type : `int`] ;

-   `license`, licence utilisée par le projet. Permet de connaître les droits donnés aux utilisateurs.

-   `assignableUserCount`, nombre d'utilisateurs ayant des droits d'accès sur le projet. [type : `int`] ;

-   `codeOfConduct`, si le projet possède un code de bonne conduite pour ses utilisateurs (règles de communauté), mentionne son nom. [type : `string`] ;

-   `forkingAllowed`, indique s'il est possible de *fork* le projet : s'il est possible d'en faire une copie. Indique vrai ou faux : `TRUE` ou `FALSE`. [type : `bool`] ;

-   `nameWithOwner`, concaténation du nom du dépôt avec le nom du créateur. [type : `string`] ;

-   `parent`, indique le nom du dépôt parent si ce dépôt est un *fork*. [type : `string`].

#### <blue>1.4. Pourquoi étudier ces données ?</blue>

Nous sommes trois étudiants de l'UTT avec un parcours tourné vers l'informatique, les nouvelles technologies et la programmation.

GitHub est une plateforme que nous utilisons personnellement (en plus de l’utiliser pour ce projet) de manières différentes : les langages de programmation utilisées dans la branche ISI de l'UTT sont différents des langages utilisés en branche GI par exemple.

L'avantage de ce jeu de données est de permettre de présenter les langages de programmations utilisés dans les projets
les plus "populaires" de la plateforme et pourquoi pas de comparer nos résultats avec nos langages préférés.

Ce travail d'analyse des tendance est déjà fait par GitHub chaque années à travers
ces articles [Octoverse report](https://octoverse.github.com/).

------------------------------------------------------------------------

### <blue>2. Plan d'analyse</blue>

#### <blue>2.1 Objectifs de l'analyses</blue>

Nous possédons donc les entrées relatives aux 200000 dépôts les plus *likés* de GitHub (ceux ayant obtenu les plus d'étoiles : *stars* ).

Dans un premier temps, nous nous demanderons comment se répartissent les *stars* de notre population.

On peut s'attendre à ce qu'une petite partie de projet possèdent un nombre important d'étoile, et ce nombre décroit rapidement, comme une exponentielle décroissante.

Si l'on s'en tient au principe de [Pareto](https://fr.wikipedia.org/wiki/Principe_de_Pareto) (principe du 80/20), on peut penser que 20% des dépôts sur GitHub concentrent 80% du nombre total d'étoiles attribués par les utilisateurs. Cette hypothèse n'est pas déraisonnable, puisque que ce principe est applicable dans beaucoup de domaine.

Bien que le principe de [Pareto](https://fr.wikipedia.org/wiki/Principe_de_Pareto) ne soit pas une règle parfaite, c'est en général une première approche naïve utile pour appréhender des phénomènes.

Si l'on considère GitHub comme un réseaux social, et que l'on considère que les *stars* d'un projet mesurent sa "popularité", nous chercherons dans la suite de l'étude à trouver ce qui peut expliquer la popularité d'un projet sur *GitHub*.

Nous allons donc lier la caractéristique du nombre d'étoile avec les autres paramètres de notre jeu de données.

#### <blue>2.2 Mesure de la popularité</blue>

Nous disposons de la date de création des dépôts (notre jeu de données contient des dépôts créés entre 2009 et 2023), nous pourrons chercher s'il existe une corrélation entre la date de création et la popularité du projet. En effet on peut penser que les dépôts les plus anciens sont les dépôts les plus appréciées.

Avec le nombre de *fork* (ou clonage en français) par dépôt nous pourront essayer de voir si les projets les plus aimés sont aussi les projets les plus repris par les utilisateurs.

Quand un utilisateur *fork* un dépôt, il en crée une copie personnelle sur laquelle il est libre d'ajouter les modifications qu'il souhaite.

Le nombre de clonage peut être un indicateur supplémentaire de popularité et on peut chercher à savoir si cet indicateur est corrélé au nombre d'étoile d'un projet.

Le paramètre *watchers* est une donnée supplémentaire d'analyse de "popularité". Quand on utilisateur *watchs* (que l'on peut traduire par surveiller ou suivre, en français) un projet, il est averti quand ce dernier subit une modification.

Là encore, on pourra chercher à vérifier l’existence d'une corrélation entre le nombre d'étoile, le nombre de clone, et le nombre de suivi des dépôts.

#### <blue>2.3 Mesure des contributions</blue>

GitHub est énormément utilisé par les projets collaboratifs pour permettre aux développeurs du monde entier de contribuer à des projets.

Selon leurs politiques de gouvernance, les propriétaires de dépôts peuvent permettre à certains utilisateurs autorisés ou à n'importe quel contributeur de proposer des modifications (les *pullRequests*) ou signaler des bugs (les *issues*).

On dispose donc de ces deux indicateurs qui permettent de quantifier l'interactivité d'un projet : plus ces deux valeurs sont grandes, plus on peut considérer le projet comme actif.

Nous ne disposons cependant pas du nombre de contributeurs par dépôt. L'attribut : `assignableUserCount` semble uniquement représenter le nombre de contributeurs ayant des droits d'accès spécifiques.

Nous pourrons par exemple utiliser l'API pour augmenter notre jeu de données et trouver pour chaque dépôt le nombre de contributeur réel.

#### <blue>2.4 Étude des langages de programmation utilisés</blue>

Nous pourrons ensuite analyser les types de langage utilisés.

Nous chercherons à faire une cartographie des langages les plus utilisés et nous pourrons peut-être lier cette analyse avec la popularité des dépôts : existe-t-il des langages plus populaires que les autres ?

On peut supposer par exemple que les dépôts très populaires ne contiennent pas de *Pascal* ou d'*Ada*...

#### <blue>2.5 Prise en compte des *topics*</blue>

Toute notre analyse jusqu'ici repose sur une hypothèse : les dépôts GitHub ne contiennent que des projets de programmation ou de code.

Cette hypothèse est fausse ! En effet, avec sa démocratisation, GitHub a connu une diversification des usages.

Aujourd'hui en tant que véritable réseau social pour développeurs et geek en tous genres, certains utilise la plateforme pour créer des portfolios en ligne, des pages vitrines pour un site ou un service, etc.

Par exemple, le dépôt : [papers-we-love](https://github.com/papers-we-love/papers-we-love) est une immense compilation de papiers scientifiques relatifs à l'informatique.

Il est donc très difficile de comparer ce genre de dépôt avec des projets informatiques.

L'attribut `topics` du dataset peut nous aider à classifier les dépôts selon leurs objectifs et catégories identifiées : projets, vitrines, listes, cours, etc.

Que ce soit pour les langages de programmation ou les *topics* utilisées, nous pourrons
essayer de reproduire un résultat montré par l'utilisateur 
