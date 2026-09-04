# Générer les SVG utilisés par la documentation

Régénère l'ensemble des diagrammes documentaires dans \`man/figures\`
par défaut. Cette fonction est destinée au travail depuis l'arbre source
du package.

## Usage

``` r
generer_diagrammes_documentation(repertoire = NULL)
```

## Arguments

- repertoire:

  Répertoire de destination. Si \`NULL\`, utilise \`man/figures\` dans
  l'arbre source courant.

## Value

Invisiblement, les chemins des fichiers SVG générés.
