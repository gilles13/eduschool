# Consulter un programme scolaire

\`programme()\` fournit une vue directement exploitable des capacites
d'un niveau et d'une discipline. Les fonctions \[programmes()\] et
\[capacites()\] restent disponibles pour les consultations plus
techniques.

## Usage

``` r
programme(
  niveau,
  discipline = "MAT",
  version = NULL,
  detail = c("capacites", "themes", "complet")
)
```

## Arguments

- niveau:

  Niveau scolaire.

- discipline:

  Discipline, \`"MAT"\` par defaut.

- version:

  Version scolaire facultative.

- detail:

  Niveau de lecture : \`"themes"\` pour les grands themes,
  \`"capacites"\` pour les capacites attendues, ou \`"complet"\` pour
  ajouter leur description detaillee.

## Value

Un data.frame organise par theme. Le niveau de detail depend de
\`detail\`.
