# Produire une ressource graphique d'examen

Transforme une specification declarative attachee a une question en
figure. Le PDF et le SVG restent vectoriels et sont privilegies pour
l'impression.

## Usage

``` r
produire_ressource_examen(
  ressource,
  fichier = NULL,
  format = c("pdf", "svg", "png"),
  largeur = 4.8,
  hauteur = 2.6
)
```

## Arguments

- ressource:

  Specification de ressource produite par \[rediger_examen()\].

- fichier:

  Chemin du fichier a produire. Si \`NULL\`, un fichier temporaire est
  cree.

- format:

  \`"pdf"\`, \`"svg"\` ou \`"png"\`.

- largeur:

  Largeur du dessin en pouces.

- hauteur:

  Hauteur du dessin en pouces.

## Value

Invisiblement, le chemin absolu du fichier produit.
