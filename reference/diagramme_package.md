# Produire un diagramme technique du package

Produire un diagramme technique du package

## Usage

``` r
diagramme_package(
  type = c("architecture_si", "tests_package"),
  fichier = NULL,
  ouvrir = FALSE
)
```

## Arguments

- type:

  Diagramme technique : \`"architecture_si"\` ou \`"tests_package"\`.

- fichier:

  Chemin du fichier HTML à produire. Si \`NULL\`, un fichier temporaire
  est cree.

- ouvrir:

  Ouvrir le fichier avec l'application associée après sa création.

## Value

Invisiblement, le chemin absolu du fichier HTML produit.
