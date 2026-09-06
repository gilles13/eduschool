# Produire un corrige d'exercices historique

Produit le corrige LaTeX d'un lot d'exercices cree par le moteur
historique de rapports. Cette fonction est conservee pour compatibilite
; pour les nouveaux usages, preferer \[produire_corrige()\].

## Usage

``` r
produire_corrige_exercices(
  lot,
  sortie,
  compiler = nzchar(Sys.which("pdflatex")),
  titre = "Corrigé des exercices",
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

  Titre du corrige.

- afficher_metadonnees:

  Afficher les metadonnees techniques des exercices.

- ouvrir:

  Si \`TRUE\`, ouvrir le PDF produit lorsque la compilation a reussi.

## Value

Invisiblement, une liste contenant les chemins du fichier LaTeX et du
PDF eventuel, ainsi que le lot utilise.
