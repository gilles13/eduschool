# Consulter la documentation pédagogique

Accès aux notions, aux liens notion-capacité, aux prérequis et aux
rappels Markdown.

## Usage

``` r
notions(discipline_id = NULL)
notions_capacite(capacite_id)
prerequis_notion(notion_id, recursif = FALSE)
prerequis_capacite(capacite_id, recursif = FALSE)
obtenir_rappel(notion_id, collapse = "\n")
rappels_capacite(capacite_id)
chercher_notions(texte, discipline_id = "MAT")
couverture_documentation(niveau = NULL)
```

## Arguments

- discipline_id:

  Identifiant de discipline.

- capacite_id:

  Identifiant de capacité.

- notion_id:

  Identifiant de notion.

- recursif:

  Inclure les prérequis transitifs.

- collapse:

  Séparateur utilisé pour réunir les lignes Markdown.

- texte:

  Texte ou fragments à rechercher.

- niveau:

  Niveau scolaire facultatif.

## Value

Selon la fonction, un `data.frame`, une liste ou une chaîne de
caractères.
