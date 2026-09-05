# Exercices et révisions

![Chaîne de génération des exercices et
révisions](../reference/figures/exercices_revisions.svg)

Chaîne de génération des exercices et révisions

Le moteur d’exercices est déterministe lorsqu’un `seed` est fourni. Pour
voir immédiatement les énoncés dans la console :

``` r

generer_fiche(
  "6E",
  "ITM_MAT_C3_6E_C09",
  n = 5,
  seed = 123,
  afficher = TRUE
)
```

## Produire une fiche HTML ou PDF

La sortie de
[`generer_fiche()`](https://gilles13.github.io/eduschool/reference/exercices.md)
peut être envoyée directement vers un document :

``` r

generer_fiche(
  "6E",
  "ITM_MAT_C3_6E_C09",
  n = 10,
  seed = 123
) |>
  produire_fiche(format = "auto")
```

Le nom est construit automatiquement à partir du niveau et de la
capacité. Pour une fiche multi-capacités, le suffixe `mixte` est
utilisé. L’argument `fichier` permet toujours de choisir soi-même le
chemin de sortie.

`format = "auto"` choisit le PDF si `pdflatex` est disponible sur la
machine et le HTML sinon. Pour imposer un format :

``` r

generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 10, seed = 123) |>
  produire_fiche(format = "html")

generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 10, seed = 123) |>
  produire_fiche(format = "pdf")
```

La sortie HTML ne nécessite pas LaTeX. Les deux formats reposent sur le
rendu R Markdown/Pandoc ; la sortie PDF nécessite en plus une
installation LaTeX fournissant `pdflatex`.

## Produire le corrigé

Le même lot d’exercices peut être envoyé au template de corrigé :

``` r

generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 10, seed = 123) |>
  produire_corrige(format = "auto")
```

Les anciennes fonctions de rapport LaTeX restent disponibles pour
compatibilité, mais
[`produire_fiche()`](https://gilles13.github.io/eduschool/reference/produire_fiche.md)
et
[`produire_corrige()`](https://gilles13.github.io/eduschool/reference/produire_corrige.md)
constituent l’interface conseillée pour les nouveaux usages.
