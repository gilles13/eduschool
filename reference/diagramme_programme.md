# Produire un diagramme HTML d'un programme de mathematiques

Produit un document HTML a partir des referentiels de programmes
embarques dans eduschool. Par defaut, la vue synthetique affiche les
domaines, les themes et les capacites synthetiques eduschool. Les vues
officiel et complet permettent d'afficher les rubriques officielles
lorsqu'elles sont transcrites.

## Usage

``` r
diagramme_programme(
  niveau = "6E",
  detail = c("synthetique", "officiel", "complet"),
  fichier = NULL,
  ouvrir = interactive(),
  vue = "cartes"
)
```

## Arguments

- niveau:

  Identifiant scolaire, par exemple "CM1", "6E", "5E" ou "3E".

- detail:

  Niveau de detail : "synthetique" (defaut), "officiel" ou "complet".

- fichier:

  Fichier HTML de sortie ; NULL cree un fichier temporaire.

- ouvrir:

  Ouvrir le document dans le navigateur.

- vue:

  Organisation visuelle du diagramme. "cartes" reproduit la vue
  historique et constitue la valeur par defaut.

## Value

Invisiblement, le chemin absolu du document HTML produit.
