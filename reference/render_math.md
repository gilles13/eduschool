# Generer des supports mathematiques imprimables

Genere des supports mathematiques imprimables a partir d'un niveau et
d'un concept. Le prototype actuel prend en charge les fractions, la
proportionnalite et les nombres premiers.

## Usage

``` r
render_math(
  niveau,
  concept,
  n = 5L,
  output_dir = ".",
  seed = 1L,
  type = c("complet", "fiche", "exercices", "corrige", "plus_loin")
)
```

## Arguments

- niveau:

  Niveau scolaire, par exemple \`"6E"\`.

- concept:

  Concept demande. \`"fractions"\`, \`"fraction"\` et
  \`"MATC_FRACTION"\` sont acceptes pour le prototype.

- n:

  Nombre d'exercices.

- output_dir:

  Repertoire dans lequel ecrire les fichiers.

- seed:

  Graine aleatoire pour rendre la generation reproductible.

- type:

  Support a produire : \`"complet"\` produit tous les supports
  actuellement disponibles pour le concept ; \`"fiche"\`,
  \`"exercices"\`, \`"corrige"\` et \`"plus_loin"\` permettent de
  produire un seul document. Le support \`"plus_loin"\` est en cours de
  generalisation a tous les concepts.

## Value

Invisiblement, une liste contenant les exercices et les chemins des PDF
produits.
