# Produire un sujet de brevet et son corrige

Produire un sujet de brevet et son corrige

## Usage

``` r
produire_brevet(
  sujet = "GEO-A-001",
  format = NULL,
  mode = "sujet_corrige",
  dossier = "/tmp",
  largeur_figure = 13,
  ouvrir = TRUE
)
```

## Arguments

- sujet:

  Identifiant(s) des exercices.

- format:

  NULL : PDF si LaTeX est disponible, sinon HTML.

- mode:

  "sujet", "corrige" ou "sujet_corrige".

- dossier:

  Repertoire de sortie.

- largeur_figure:

  Largeur des figures, en centimetres.

- ouvrir:

  Ouvrir avec le lecteur par defaut du systeme.

## Value

Vecteur nomme des fichiers produits, invisiblement.
