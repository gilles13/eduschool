# Consulter un programme scolaire

\`programme()\` fournit une vue directement exploitable des capacites
d'un niveau et d'une discipline. Les fonctions \[programmes()\] et
\[capacites()\] restent disponibles pour les consultations plus
techniques.

## Usage

``` r
programme(niveau, discipline = "MAT", version = NULL)
```

## Arguments

- niveau:

  Niveau scolaire.

- discipline:

  Discipline, \`"MAT"\` par defaut.

- version:

  Version scolaire facultative.

## Value

Un data.frame avec programme, theme et capacite.
