# Controler la coherence metier des mathematiques

Verifie les liens entre concepts, programmes, niveaux, methodes,
formules, erreurs et types d'exercices. Ces controles completent le
controle general du mini-SI sans ajouter de table de donnees.

## Usage

``` r
controle_integrite_math(strict = FALSE)
```

## Arguments

- strict:

  Si \`TRUE\`, leve une erreur lorsqu'au moins un controle echoue.

## Value

Un data.frame avec une ligne par controle.
