# Générer toute la documentation visuelle

Produit les SVG documentaires ainsi que les pages HTML correspondantes.
Aucune dépendance externe à R n'est nécessaire.

## Usage

``` r
generer_documentation_visuelle(repertoire_svg = NULL, repertoire_html = NULL)
```

## Arguments

- repertoire_svg:

  Répertoire des SVG. Si \`NULL\`, utilise \`man/figures\` dans l'arbre
  source.

- repertoire_html:

  Répertoire des pages HTML. Si \`NULL\`, utilise
  \`rapports/sorties/diagrammes\` dans le répertoire de travail.

## Value

Invisiblement, une liste contenant les chemins \`svg\` et \`html\`.
