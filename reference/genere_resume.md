# Generer un resume pedagogique lisible

Fournit une vue courte d'un niveau scolaire, adaptee aux vignettes et au
site pkgdown. Les tables techniques restent accessibles avec
\[resume_niveau()\], \[themes_niveau()\] et \[notions_niveau()\].

## Usage

``` r
genere_resume(
  niveau,
  matiere = "all",
  version = "2026_2027",
  max_themes = 5L,
  max_notions = 6L
)
```

## Arguments

- niveau:

  Niveau scolaire, par exemple \`"6E"\`, \`"3E"\` ou \`"2GT"\`.

- matiere:

  Matiere a conserver. \`"all"\` affiche toutes les matieres. Les
  identifiants (\`"MAT"\`, \`"FRA"\`, etc.) et quelques alias usuels
  sont acceptes.

- version:

  Version scolaire, par defaut \`"2026_2027"\`.

- max_themes:

  Nombre maximal de themes affiches par ligne.

- max_notions:

  Nombre maximal de notions affichees par ligne.

## Value

Un \`data.frame\` avec quatre colonnes : \`matiere\`, \`horaire\`,
\`themes\` et \`notions\`.
