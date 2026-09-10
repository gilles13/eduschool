# Produire un quiz HTML auto-corrigeant

Produit un fichier HTML autonome : aucun serveur, aucune bibliotheque
JavaScript et aucune session R ne sont necessaires pour faire le quiz.
Chaque question comporte quatre propositions et une seule bonne reponse.

## Usage

``` r
produire_quiz(
  exercices,
  fichier = NULL,
  titre = "Mon entrainement eduschool",
  ouvrir = TRUE
)
```

## Arguments

- exercices:

  Liste d'exercices munis de propositions QCM.

- fichier:

  Chemin du fichier HTML. Si \`NULL\`, un nom est construit
  automatiquement a partir des exercices.

- titre:

  Titre affiche dans le quiz.

- ouvrir:

  Ouvrir le quiz dans le navigateur apres sa creation.

## Value

Invisiblement, le chemin absolu du fichier HTML produit.

## Examples

``` r
if (FALSE) { # \dontrun{
exercices("6E", "proportionnalite", n = 5) |>
  produire_quiz()
} # }
```
