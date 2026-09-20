# Construire une revision de mathematiques

Avec un seul argument, \`revision()\` accepte soit un niveau scolaire et
retourne sa fiche essentielle, soit un theme et retrouve automatiquement
la fiche thematique correspondante. Le niveau reste disponible comme
filtre explicite lorsque plusieurs parcours sont possibles.

## Usage

``` r
revision(niveau = NULL, theme = NULL)
```

## Arguments

- niveau:

  Niveau scolaire facultatif. Avec un seul argument qui n'est pas un
  niveau connu, cet argument est interprete comme un theme.

- theme:

  Theme de revision facultatif, en langage courant.

## Value

Un objet \`eduschool_revision\`.
