# Produire une fiche d'exercices HTML ou PDF

Transforme directement une liste produite par \[generer_fiche()\] en
document. Le format \`"auto"\` produit un PDF lorsque LaTeX est
disponible et un HTML sinon.

## Usage

``` r
produire_fiche(
  exercices,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  titre = "Fiche d'exercices",
  sous_titre = NULL,
  instructions =
    "Rediger les calculs et justifier les etapes lorsque cela est necessaire.",
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
)
```

## Arguments

- exercices:

  Liste d'exercices produite par \[generer_fiche()\].

- fichier:

  Chemin de sortie, avec ou sans extension. Si \`NULL\`, un nom est
  construit automatiquement a partir du niveau et de la capacite.

- format:

  Format de sortie : \`"auto"\`, \`"html"\` ou \`"pdf"\`.

- titre:

  Titre du document.

- sous_titre:

  Sous-titre. Si \`NULL\`, il est deduit des exercices.

- instructions:

  Consigne generale affichee avant les exercices.

- afficher_metadonnees:

  Afficher les identifiants techniques des exercices.

- ouvrir:

  Ouvrir le document apres sa creation.

## Value

Invisiblement, le chemin absolu du fichier produit.
