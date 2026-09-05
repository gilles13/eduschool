# Produire une fiche de revision HTML ou PDF

Produire une fiche de revision HTML ou PDF

## Usage

``` r
produire_revision(
  revision,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  ouvrir = FALSE
)
```

## Arguments

- revision:

  Objet produit par \[generer_revision()\] ou \[generer_essentiel()\].

- fichier:

  Chemin de sortie. Si \`NULL\`, le nom est construit automatiquement.

- format:

  \`"auto"\`, \`"html"\` ou \`"pdf"\`.

- ouvrir:

  Ouvrir le document apres creation.

## Value

Invisiblement, le chemin absolu du fichier produit.
