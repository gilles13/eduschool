# Architecture

## Principe

Le package sépare trois couches : ressources persistantes (`inst/`), logique R (`R/`) et sorties utilisateur (`rapports/`, non versionnées).

Les fonctions de consultation ne dépendent pas d'objets globaux. DuckDB est une couche de requête facultative, pas la source de vérité. Les CSV et Markdown restent les formats persistants et inspectables.

## Ressources

- `inst/referentiels/` : identifiants et nomenclatures ;
- `inst/programmes/` : programmes, capacités et applications ;
- `inst/documentation/` : notions, prérequis et rappels ;
- `inst/exercices/` : catalogue et liens vers capacités ;
- `inst/templates/` : modèles de sortie.

## Règle de dépendance

Le code métier ne doit jamais dépendre du répertoire courant. Toute ressource installée passe par `eduschool_path()`.
