# Instancier un exercice compose

Instancier un exercice compose

## Usage

``` r
generer_exercice_compose(gabarit_compose_id, seed = NULL, contexte_id = NULL)
```

## Arguments

- gabarit_compose_id:

  Identifiant du gabarit compose.

- seed:

  Graine aleatoire facultative.

- contexte_id:

  Contexte semantique facultatif. S il est omis, un contexte compatible
  est tire.

## Value

Une liste contenant contexte, questions, corrections et ressource.
