# Produire une fiche, son corrige et un manifeste

Genere un lot d'exercices avec le moteur historique, produit la fiche et
le corrige correspondants, puis ecrit un manifeste CSV decrivant les
exercices generes. Pour les nouveaux usages, les fonctions
\[generer_fiche()\], \[produire_fiche()\] et \[produire_corrige()\] sont
a privilegier.

## Usage

``` r
produire_rapport_exercices(
  niveau_id,
  capacite_id = NULL,
  n = 10,
  difficulte = 1,
  seed = 1,
  sortie_dir = file.path(getwd(), "rapports", "sorties", "exercices"),
  prefixe = NULL,
  compiler = nzchar(Sys.which("pdflatex")),
  afficher_metadonnees = FALSE,
  ouvrir = c("aucun", "fiche", "corrige", "les_deux")
)
```

## Arguments

- niveau_id:

  Identifiant du niveau scolaire.

- capacite_id:

  Identifiant d'une capacite a cibler, ou \`NULL\` pour un lot mixte.

- n:

  Nombre d'exercices a generer.

- difficulte:

  Niveau de difficulte demande.

- seed:

  Graine aleatoire utilisee pour rendre la generation reproductible.

- sortie_dir:

  Repertoire dans lequel ecrire les fichiers produits.

- prefixe:

  Prefixe des noms de fichiers. Si \`NULL\`, il est construit a partir
  du niveau, de la capacite, de la difficulte et de la graine.

- compiler:

  Si \`TRUE\`, compiler les fichiers LaTeX en PDF.

- afficher_metadonnees:

  Afficher les metadonnees techniques dans les documents.

- ouvrir:

  Document PDF a ouvrir apres generation : \`"aucun"\`, \`"fiche"\`,
  \`"corrige"\` ou \`"les_deux"\`.

## Value

Invisiblement, une liste contenant le lot, la fiche, le corrige et le
chemin du manifeste CSV.
