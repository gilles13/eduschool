# Quiz sur les ensembles de nombres

Construit de cinq a dix QCM courts sur les inclusions usuelles, les plus
petits ensembles contenant quelques nombres et la difference entre
appartenance et inclusion. Le resultat peut etre passe directement a
\[produire_quiz()\].

## Usage

``` r
exercices_ensembles_nombres(seed = NULL, n = 5L)
```

## Arguments

- seed:

  Graine facultative utilisee pour melanger les propositions.

- n:

  Nombre de questions a produire, de 1 a 10. Par defaut, 5.

## Value

Une liste de \`n\` exercices eduschool munis d'un QCM.

## Details

Les cinq premieres questions constituent le parcours court historique.
Avec \`n = 10\`, cinq questions supplementaires ajoutent quelques pieges
utiles : zero, une fraction qui se simplifie, un decimal negatif, racine
de deux et raisonnement par inclusion.

## Examples

``` r
if (FALSE) { # \dontrun{
exercices_ensembles_nombres(seed = 2026) |>
  produire_quiz(titre = "Mes 5 rappels sur les ensembles")

exercices_ensembles_nombres(seed = 2026, n = 10) |>
  produire_quiz(titre = "Jouons avec les ensembles de nombres")
} # }
```
