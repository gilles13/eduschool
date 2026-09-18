# Produire la carte des mathematiques

Produire la carte des mathematiques

## Usage

``` r
produire_carte_math(
  carte = carte_math(),
  fichier = NULL,
  largeur = 10,
  hauteur = 7,
  ouvrir = TRUE
)
```

## Arguments

- carte:

  Objet produit par \[carte_math()\].

- fichier:

  Fichier PNG a produire. Si \`NULL\`, utilise
  \`eduschool-carte-math.png\` dans le repertoire courant.

- largeur:

  Largeur du rendu en pouces.

- hauteur:

  Hauteur du rendu en pouces.

- ouvrir:

  Ouvrir le rendu apres sa creation.

## Value

Invisiblement, le chemin absolu du fichier produit.
