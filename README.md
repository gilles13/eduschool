# eduschool

<p align="center">
  <img src="man/figures/logo.png" alt="Logo eduschool" width="360">
</p>

`eduschool` permet de consulter simplement les programmes scolaires français,
les notions essentielles d'un niveau et de générer des exercices de révision.

## Installation

```r
install.packages("remotes")
remotes::install_github("gilles13/eduschool")
```

Puis :

```r
library(eduschool)
```

## Commencer en quelques commandes

Obtenir une vue synthétique d'une classe :

```r
genere_resume("6E")
```

Se concentrer sur une matière :

```r
genere_resume("6E", matiere = "maths")
```

La même interface permet d'explorer le lycée, par exemple la seconde générale
et technologique :

```r
genere_resume("2GT")
genere_resume("2GT", matiere = "maths")
```

Générer immédiatement quelques exercices et afficher leurs énoncés :

```r
generer_fiche(
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C09",
  n = 3,
  difficulte = 1,
  seed = 2026,
  afficher = TRUE
)
```

Pour créer directement une fiche imprimable, la sortie peut être envoyée dans
`produire_fiche()` avec le pipe natif :

```r
generer_fiche(
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C09",
  n = 5,
  seed = 2026
) |>
  produire_fiche(format = "auto")
```

Le nom du fichier est construit automatiquement à partir du niveau et de la
capacité. Il reste possible de fournir un chemin explicite avec l'argument
`fichier`. Avec `format = "auto"`, `eduschool` produit un PDF si LaTeX est
disponible et un fichier HTML sinon. Le même principe s'applique au corrigé avec
`produire_corrige()`.

## Documentation

Pour découvrir le package, commencer par la vignette **Explorer une classe de
6e avec eduschool**. La vignette **Explorer une classe de 2de générale et
technologique** donne ensuite un exemple lycée plus complet, notamment sur les
mathématiques et l'orientation après la seconde.

Les autres vignettes conservent chacune un rôle précis : prise en main, parcours
scolaires, programmes et capacités, documentation pédagogique, exercices,
architecture des données et développement.

```r
browseVignettes("eduschool")
```

La documentation complète est également publiée sur le site pkgdown du package.
