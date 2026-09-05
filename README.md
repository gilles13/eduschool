# eduschool

<p align="center">
  <img src="man/figures/logo.png" alt="Logo eduschool" width="360">
</p>

> **Comprendre sa scolarité. Travailler les mathématiques.**

`eduschool` cartographie la scolarité des collégiens et lycéens en France et
propose des outils pour réviser et s'entraîner en mathématiques.

Le projet repose sur des données structurées et interconnectées : niveaux,
cycles, voies, séries, enseignements, programmes, orientation et poursuites
d'études. Les contenus pédagogiques produits par `eduschool` sont volontairement
centrés sur les mathématiques. L'architecture reste assez générique pour être
étendue à d'autres disciplines par des contributeurs, sans que cela devienne
l'objectif principal du package.

## Installation

```r
install.packages("remotes")
remotes::install_github("gilles13/eduschool")
library(eduschool)
```

## Une API simple, orientée usages

L'interface principale de `eduschool` s'organise progressivement autour de
quelques verbes faciles à mémoriser :

```r
parcours("3E")
orientation("2GT")
programme("6E")
revision("6E")
exercices("6E", n = 5)
```

Les fonctions détaillées historiques restent disponibles pour explorer les
référentiels, contrôler le système relationnel ou personnaliser les productions.
La simplification de l'API ne masque donc pas les données : elle offre une porte
d'entrée plus naturelle.

## Deux axes

### Cartographier la scolarité

`eduschool` aide à comprendre où se situe un élève et quelles bifurcations sont
possibles : passage du collège au lycée, voies générale, technologique et
professionnelle, spécialités et options, orientation et poursuites post-bac.

```r
parcours("3E")
orientation("3E")
orientation("2GT")
```

### Travailler les mathématiques

Le package relie programmes, capacités, notions, fiches de révision et exercices.

```r
programme("6E", "MAT")
revision("6E")
exercices("6E", n = 5, seed = 2026)
```

Les fonctions de production HTML/PDF restent disponibles pour transformer ces
objets en supports imprimables.

## Créer, mutualiser, partager

`eduschool` est un projet open source. Son ambition n'est pas seulement de
publier des données et des fiches, mais aussi de fournir progressivement des
briques simples permettant à chacun de composer ses propres supports de
révision et d'exercices.

L'objectif fonctionnel est que les fiches fournies par le package et les fiches
créées par les utilisateurs reposent à terme sur **la même API publique de
composition**. Une contribution pourra ainsi être utilisée localement, adaptée,
puis proposée au projet sans dépendre d'un moteur interne inaccessible.

Les corrections de données, propositions de ressources, idées de fiches,
modèles d'exercices et améliorations de documentation sont les bienvenues. Voir
[documentation/CONTRIBUTING.md](documentation/CONTRIBUTING.md) pour les principes de contribution.

## Documentation

Le site pkgdown est organisé par accès thématiques : **Découvrir eduschool**,
**Parcours et orientation**, **Mathématiques**, **Comprendre eduschool** et
**Contribuer et partager**.

```r
browseVignettes("eduschool")
```

Les données officielles restent des références externes : `eduschool` les
structure et les met en relation, sans prétendre devenir une source de vérité
institutionnelle.
