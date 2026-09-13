# Produire une fiche d'exercices HTML ou PDF

Transforme directement une liste produite par \[exercices()\] ou
\[generer_fiche()\] en document. Accepte aussi le chemin d'un fichier
Markdown (\`.md\`) ou un objet tabulaire (\`matrix\` ou \`data.frame\`).
Un \`data.frame\` contenant \`notion_id\` et \`libelle\` est rendu comme
une fiche de revision categorisee ; une colonne facultative \`statut\`
permet d'indiquer les notions acquises, en cours ou a decouvrir. Le
format \`"auto"\` produit un PDF lorsque LaTeX est disponible et un HTML
sinon. Par defaut, le document produit est ouvert automatiquement.

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
  ouvrir = TRUE
)
```

## Arguments

- exercices:

  Liste d'exercices produite par \[exercices()\] ou \[generer_fiche()\],
  chemin vers un fichier Markdown (\`.md\`), matrice ou \`data.frame\`.
  Un tableau de notions peut contenir \`categorie\`, \`statut\` et
  \`ordre\`.

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

  Ouvrir le document apres sa creation. \`TRUE\` par defaut pour
  afficher immediatement la fiche a l'utilisateur.

## Value

Invisiblement, le chemin absolu du fichier produit.

## Examples

``` r
if (FALSE) { # \dontrun{
exercices("6E") |>
  produire_fiche()

exercices("6E") |>
  produire_fiche(format = "html", ouvrir = FALSE)

produire_fiche("ma-fiche.md", format = "html")

table_multiplication() |>
  produire_fiche(titre = "Tables de multiplication", format = "html")
} # }
```
