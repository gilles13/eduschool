# Controler la coherence metier des examens

Verifie notamment les totaux de duree et de points, les questions des
exercices composes, leurs contextes et la presence des generateurs R.

## Usage

``` r
controle_integrite_examens(strict = FALSE)
```

## Arguments

- strict:

  Si \`TRUE\`, leve une erreur lorsqu'au moins un controle echoue.

## Value

Un data.frame avec une ligne par controle.
