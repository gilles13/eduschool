# Generer des supports mathematiques imprimables

Genere un PDF d'exercices et son corrige explique a partir d'un niveau
et d'un concept mathematique. Le premier prototype prend en charge les
fractions en 6e.

## Usage

``` r
render_math(niveau, concept, n = 5L, output_dir = ".", seed = 1L)
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

## Value

Invisiblement, une liste contenant les exercices et les chemins des deux
PDF produits.
