# Generer un exercice

Generer un exercice

## Usage

``` r
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

exercices(
  niveau,
  notion = NULL,
  capacite = NULL,
  n = 5,
  difficulte = 1,
  seed = 1,
  humour_ratio = 0.2,
  afficher = FALSE
)
```

## Arguments

- modele_id:

  Identifiant du modele d'exercice.

- niveau_id:

  Identifiant du niveau scolaire.

- capacite_id:

  Identifiant de capacite facultatif.

- difficulte:

  Niveau de difficulte.

- seed:

  Graine pseudo-aleatoire utilisee pour controler les tirages de la
  generation.

- afficher:

  Afficher directement l'enonce genere.

- n:

  Nombre d'exercices.

- niveau:

  Niveau scolaire.

- notion:

  Notion a travailler, en langage courant, par exemple \`"pythagore"\`
  ou \`"fractions"\`.

- capacite:

  Identifiant de capacite facultatif pour un pilotage avance.

- humour_ratio:

  Ratio d'exercices recevant une touche humoristique lorsqu'elle est
  disponible. Nombre compris entre 0 et 1. Par defaut \`0.2\`, soit
  environ un exercice sur cinq.

## Value

Un exercice ou une liste d'exercices.
