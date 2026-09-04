# eduschool

`eduschool` est un package R en cours de développement pour consulter des référentiels scolaires français, relier programmes, capacités et notions pédagogiques, et produire des exercices de révision reproductibles.

## V0.10.0 : première version package

Cette version marque le passage de l'ancien projet à une architecture de package. Les ressources CSV et Markdown sont désormais installées sous `inst/`; le code public est regroupé directement dans `R/`; les objets globaux `tables`, `con`, `project_dir` et `data_dir` ne sont plus nécessaires pour les consultations usuelles.

## Développement

Depuis la racine du dépôt :

```r
devtools::load_all()
```

Puis :

```r
niveaux()
capacites("6E")
chercher_notions("fraction")
```

Sans `devtools`, le fichier de compatibilité suivant reste utilisable dans l'arbre source :

```r
source("launcher.R")
```

## Installation locale

Une fois le dépôt récupéré :

```r
install.packages(".", repos = NULL, type = "source")
library(eduschool)
```

En développement, `devtools::install()` est plus confortable.

## Premier usage

```r
library(eduschool)

# Les niveaux disponibles
niveaux()

# Capacités mathématiques de 6e
x = capacites("6E")
head(x)

# Documentation pédagogique
chercher_notions("fraction")
notions_capacite("ITM_MAT_C3_6E_C09")
cat(obtenir_rappel("MAT_FRACTION_ADD"))

# Générer des exercices
fiche = generer_fiche(
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C09",
  n = 5,
  difficulte = 1,
  seed = 2026
)
```

## DuckDB

DuckDB est un moteur relationnel disponible lorsque les requêtes deviennent plus complexes, mais il n'est pas nécessaire pour simplement consulter les référentiels ou les rappels :

```r
con = ouvrir_base()
DBI::dbListTables(con)
DBI::dbDisconnect(con)
```

Aucun argument `shared_home` n'est utilisé.

## Documentation

Commencer par `vignettes/prise-en-main.Rmd`. Les guides détaillent ensuite les programmes/capacités, la documentation pédagogique, les exercices et l'architecture des données. Le dossier `docs/` contient la documentation destinée au mainteneur.

## Versionnement

Le dépôt source doit maintenant devenir la référence. Les ZIP ne sont plus conçus comme un mode de développement : ils ne servent qu'à transmettre ponctuellement un instantané. Voir `documentation/versionnement-git.md`.
