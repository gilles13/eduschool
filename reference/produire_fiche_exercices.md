# Produire une fiche d'exercices historique

Produit une fiche d'exercices au format LaTeX a partir d'un lot cree par
le moteur historique de rapports. Cette fonction est conservee pour
compatibilite ; pour les nouveaux usages, preferer \[produire_fiche()\].

## Usage

``` r
produire_fiche_exercices(
  lot,
  sortie,
  compiler = nzchar(Sys.which("pdflatex")),
  titre = "Fiche d'exercices",
  instructions =
    "Rédiger les calculs et justifier les étapes lorsque cela est nécessaire.",
  afficher_metadonnees = FALSE,
  ouvrir = FALSE
)
```

## Arguments

- lot:

  Objet de classe \`rapport_exercices\`, cree avec
  \`creer_lot_rapport()\`.

- sortie:

  Chemin de sortie, avec ou sans extension \`.tex\`.

- compiler:

  Si \`TRUE\`, compiler egalement le fichier LaTeX en PDF.

- titre:

  Titre de la fiche.

- instructions:

  Instructions affichees sur la fiche.

- afficher_metadonnees:

  Afficher les metadonnees techniques des exercices.

- ouvrir:

  Si \`TRUE\`, ouvrir le PDF produit lorsque la compilation a reussi.

## Value

Invisiblement, une liste contenant les chemins du fichier LaTeX et du
PDF eventuel, ainsi que le lot utilise.
