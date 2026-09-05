# Explorer un parcours scolaire

\`parcours()\` est la porte d'entree courte pour obtenir une synthese
lisible d'un niveau scolaire. Elle s'appuie sur \[genere_resume()\] et
ne remplace pas les fonctions de consultation plus detaillees.

## Usage

``` r
parcours(niveau, matiere = "all", version = "2026_2027", serie = NULL)
```

## Arguments

- niveau:

  Identifiant du niveau, par exemple \`"6E"\`, \`"3E"\` ou \`"2GT"\`.

- matiere:

  Matiere a afficher. Par defaut \`"all"\`.

- version:

  Version scolaire.

- serie:

  Serie facultative au lycee.

## Value

Un data.frame de synthese.
