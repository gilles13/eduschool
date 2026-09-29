# Produire une fiche ou un quiz HTML/PDF

Produire une fiche ou un quiz HTML/PDF

## Usage

``` r
produire(
  notion,
  support,
  dossier = NULL,
  format = "html",
  variantes = 5L,
  ouvrir = TRUE,
  niveau = "",
  n = NULL,
  tirages = NULL,
  humour_ratio = 0.2,
  seed = NULL
)
```

## Arguments

- notion:

  Notion simple ou famille definie dans familles_notions.csv.

- support:

  "decouverte", "synthese", "quiz" ou "tous".

- dossier:

  Repertoire de destination ; NULL cree un fichier temporaire.

- format:

  "html" ou "pdf".

- variantes:

  Ancien nom de tirages (conserve pour compatibilite).

- ouvrir:

  Ouvrir le document genere (TRUE par defaut).

- niveau:

  Niveau scolaire facultatif.

- n:

  Nombre de questions par quiz ; NULL utilise toute la banque.

- tirages:

  Nombre de quiz pre-calcules pour le HTML ; NULL reprend variantes.

- humour_ratio:

  Proportion cible de questions avec humour, entre 0 et 1.

- seed:

  Graine facultative pour reproduire les tirages et l'humour.

## Details

support = "tous" produit les supports disponibles dans un meme dossier.
Pour une famille, les fiches rassemblent les Markdown des membres dans
l'ordre du referentiel ; le quiz utilise leurs banques JSON.
