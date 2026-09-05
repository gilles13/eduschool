# API publique

## Façade principale

Depuis la version 0.12.0, l'entrée recommandée dans `eduschool` s'organise autour
de quelques verbes courts :

- `parcours()` : comprendre un niveau scolaire ;
- `orientation()` : voir les bifurcations possibles ;
- `programme()` : consulter les capacités d'un programme ;
- `revision()` : obtenir une fiche de révision de mathématiques ;
- `exercices()` : générer simplement un lot d'exercices.

Cette façade ne remplace pas les fonctions historiques. Elle les compose et offre
une convention plus facile à mémoriser.

## API détaillée

Les fonctions plus spécialisées restent publiques pour les utilisateurs qui ont
besoin de contrôler précisément les données et les sorties :

- référentiels : `niveaux()`, `voies()`, `series()`, `disciplines()`, `enseignements()` ;
- programmes : `programmes()`, `capacites()` ;
- documentation : `notions()`, `chercher_notions()`, `notions_capacite()`, `prerequis_capacite()`, `obtenir_rappel()` ;
- exercices : `generer_exercice()`, `generer_fiche()`, `produire_rapport_exercices()` ;
- révisions : `generer_revision()`, `generer_essentiel()`, `produire_revision()` ;
- orientation : fonctions `parcoursup_*()`, `filieres_postbac()` et fonctions de diagrammes ;
- mini-SI : `tables_si()`, `relations_si()`, `controle_integrite_si()` ;
- données avancées : `ouvrir_base()` ;
- ressources : `eduschool_path()`.

## Composition et contribution

La prochaine couche de l'API publique concernera la création de supports. Le but
est que les fiches distribuées par `eduschool` et les fiches personnelles soient
construites avec les mêmes briques publiques : création, ajout de notions,
graphiques, exercices et production du document.

Une fonction non exportée peut évoluer sans garantie de compatibilité.
