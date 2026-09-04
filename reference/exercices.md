# Générer des exercices

Génère des exercices mathématiques reproductibles à partir du catalogue
du package.

## Usage

``` r
generer_exercice(modele_id, niveau_id, capacite_id = NA_character_, difficulte = 1, seed = NULL)
generer_lot_exercices(modele_id, niveau_id, n = 10, capacite_id = NA_character_, difficulte = 1, seed = 1)
generer_fiche(niveau_id, capacite_id = NULL, n = 10, difficulte = 1, seed = 1)
```

## Arguments

- modele_id:

  Identifiant du modèle d'exercice.

- niveau_id:

  Identifiant du niveau scolaire.

- capacite_id:

  Identifiant de capacité facultatif.

- difficulte:

  Niveau de difficulté.

- seed:

  Graine aléatoire pour rendre la génération reproductible.

- n:

  Nombre d'exercices.

## Value

Un exercice sous forme de liste ou une liste d'exercices.
