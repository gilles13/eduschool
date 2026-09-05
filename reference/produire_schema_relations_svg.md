# Produire un schema relationnel du mini-SI

Le diagramme est construit dynamiquement depuis \`tables.csv\` et
\`relations.csv\`.

## Usage

``` r
produire_schema_relations_svg(fichier = NULL, focus = NULL)
```

## Arguments

- fichier:

  Chemin du fichier SVG a produire.

- focus:

  Noms de tables a conserver. \`NULL\` produit le schema global.

## Value

Invisiblement, le chemin absolu du SVG.
