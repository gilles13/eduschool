# Produire un quiz HTML auto-corrigeant

Produit un fichier HTML autonome : aucun serveur, aucune bibliotheque
JavaScript et aucune session R ne sont necessaires pour faire le quiz.
Chaque question comporte quatre propositions et une seule bonne reponse.
L'en-tete reprend la charte eduschool et, lorsqu'elles sont fournies par
les QCM, la notion et une courte formule de rappel.

## Usage

``` r
produire_quiz(
  exercices,
  fichier = NULL,
  titre = "Mon entrainement eduschool",
  questions_par_quiz = 5L,
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

- questions_par_quiz:

  Nombre de questions affichees dans chaque quiz. Toutes les questions
  fournies dans \`exercices\` sont embarquees dans le HTML. Le bouton
  \`Lancer un nouveau quiz\` effectue un nouveau tirage cote navigateur,
  sans session R. Pour obtenir un contenu different, \`exercices\` doit
  contenir plus de questions que \`questions_par_quiz\`.

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
