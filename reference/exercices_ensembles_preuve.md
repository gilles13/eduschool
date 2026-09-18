# Labo : de la conjecture a la demonstration

Propose cinq QCM pour distinguer exemple, conjecture, contre-exemple et
demonstration. Le parcours part de la reflexivite de l'inclusion puis
demande ce qui permet, ou non, d'etablir une affirmation universelle.

## Usage

``` r
exercices_ensembles_preuve(seed = NULL)
```

## Arguments

- seed:

  Graine facultative utilisee pour melanger les propositions.

## Value

Une liste de cinq exercices eduschool munis d'un QCM.

## Examples

``` r
if (FALSE) { # \dontrun{
exercices_ensembles_preuve(seed = 2026) |>
  produire_quiz(titre = "Comment sais-tu que c'est vrai ?")
} # }
```
