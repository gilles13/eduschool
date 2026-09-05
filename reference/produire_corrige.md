# Produire le corrige d'une fiche HTML ou PDF

Utilise le meme template que \[produire_fiche()\] mais affiche les
corrections et les reponses attendues.

## Usage

``` r
produire_corrige(
  exercices,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  titre = "Corrige des exercices",
  sous_titre = NULL,
  instructions = NULL,
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
