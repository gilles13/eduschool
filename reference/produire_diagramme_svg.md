# Produire un diagramme SVG

Génère un fichier SVG autonome, sans dépendance à Mermaid, Node, npm ou
à un navigateur. Le fichier peut être utilisé directement dans la
documentation pkgdown ou dans une vignette.

## Usage

``` r
produire_diagramme_svg(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
)
```

## Arguments

- type:

  Identifiant du diagramme. Voir \[diagrammes_disponibles()\].

- fichier:

  Chemin du fichier SVG à produire. Si \`NULL\`, un fichier temporaire
  est cree.

- ouvrir:

  Ouvrir le fichier avec l'application associée après sa création.

## Value

Invisiblement, le chemin absolu du fichier SVG produit.
