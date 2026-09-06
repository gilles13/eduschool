# Recuperer des donnees officielles

Le prototype 0.21.0 execute un appel Insee/Melodi a partir d'une source
declaree. Les donnees ne sont pas copiees dans le package : elles sont
demandees au moment ou un exercice, un graphique ou une fiche en a
besoin. La provenance est attachee au data.frame retourne.

## Usage

``` r
recuperer_donnees(source)
```

## Arguments

- source:

  Objet \`eduschool_source\`.

## Value

Un data.frame portant un attribut \`eduschool_provenance\`.
