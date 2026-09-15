# Produire un examen redige et son corrige

Produit, a partir du meme objet redige, le sujet et son corrige. Le
format \`"auto"\` choisit le PDF lorsque LaTeX est disponible et HTML
sinon.

## Usage

``` r
produire_examen(
  examen,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  ouvrir = c("examen", "les_deux", "aucun"),
  detaille = FALSE
)
```

## Arguments

- examen:

  Objet produit par \[rediger_examen()\].

- fichier:

  Chemin de base du sujet. Le corrige recoit le suffixe \`"-corrige"\`.
  Si \`NULL\`, les noms sont construits automatiquement.

- format:

  \`"auto"\`, \`"html"\` ou \`"pdf"\`.

- ouvrir:

  Document a ouvrir apres creation : \`"examen"\` par defaut,
  \`"les_deux"\` ou \`"aucun"\`.

- detaille:

  Pour le corrige, afficher les etapes de raisonnement detaillees lorsqu
  elles sont disponibles.

## Value

Invisiblement, un vecteur nomme contenant les chemins du sujet et du
corrige.
