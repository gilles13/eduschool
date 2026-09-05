# Generer un exercice

Generer un exercice

## Usage

``` r
exercices(
  niveau,
  capacite = NULL,
  n = 5,
  difficulte = 1,
  seed = 1,
  afficher = FALSE
)

generer_exercice(
  modele_id, niveau_id, capacite_id = NA_character_,
  difficulte = 1, seed = NULL, afficher = FALSE
)
generer_lot_exercices(
  modele_id, niveau_id, n = 10, capacite_id = NA_character_,
  difficulte = 1, seed = 1, afficher = FALSE
)
generer_fiche(
  niveau_id, capacite_id = NULL, n = 10,
  difficulte = 1, seed = 1, afficher = FALSE
)

generer_lot_exercices(
  modele_id,
  niveau_id,
  n = 10,
  capacite_id = NA_character_,
  difficulte = 1,
  seed = 1,
  afficher = FALSE
)

generer_fiche(
  niveau_id,
  capacite_id = NULL,
  n = 10,
  difficulte = 1,
  seed = 1,
  afficher = FALSE
)
```

## Arguments

- niveau:

  Niveau scolaire.

- capacite:

  Identifiant de capacite facultatif.

- n:

  Nombre d'exercices.

- difficulte:

  Niveau de difficulte.

- seed:

  Graine aleatoire pour rendre la generation reproductible.

- afficher:

  Afficher directement l'enonce genere.

- modele_id:

  Identifiant du modele d'exercice.

- niveau_id:

  Identifiant du niveau scolaire.

- capacite_id:

  Identifiant de capacite facultatif.

## Value

Un exercice ou une liste d'exercices.
