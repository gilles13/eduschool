# Controler l'ensemble du projet eduschool

Reunit les controles du mini-SI, des mathematiques et des examens dans
un tableau unique. L'objectif est de controler davantage sans multiplier
les fichiers de donnees ni dupliquer les regles metier.

## Usage

``` r
controle_integrite(strict = FALSE)
```

## Arguments

- strict:

  Si \`TRUE\`, leve une erreur lorsqu'au moins un controle echoue.

## Value

Un data.frame avec une colonne \`couche\` et une ligne par controle.
