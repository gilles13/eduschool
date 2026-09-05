# Comprendre sa scolarité. Travailler les mathématiques.

**eduschool** cartographie la scolarité des collégiens et lycéens en France et
propose des outils simples pour réviser, s'entraîner et progresser en
mathématiques.

**[Explorer un parcours →](articles/parcours-scolaires.html)** ·
**[Réviser les maths →](articles/fiches-revision-mathematiques.html)**

De la 6e à la Terminale · données structurées · outils R · projet open source
et collaboratif.

---

## Les quatre portes d'entrée

::: {.row .eduschool-entries}

::: {.col-md-6 .eduschool-entry}

![](identite/parcours.png)

### [Parcours scolaire](articles/parcours-scolaires.html)

Niveaux, cycles, voies, séries, options, spécialités, orientation et Parcoursup.

:::

::: {.col-md-6 .eduschool-entry}

![](identite/maths.png)

### [Mathématiques](articles/fiches-revision-mathematiques.html)

Programmes, capacités, fiches de révision, exercices et ressources.

:::

::: {.col-md-6 .eduschool-entry}

![](identite/partage.png)

### [Créer et partager](articles/contribuer-et-partager.html)

Adapter les outils, proposer des corrections et mutualiser fiches et exercices.

:::

::: {.col-md-6 .eduschool-entry}

![](identite/donnees.png)

### [Données et R](reference/index.html)

Une API simple pour explorer les données, produire des documents et aller plus loin.

:::

:::

---

## Commencer avec quelques verbes

L'API principale privilégie des verbes courts et faciles à lire :

```r
library(eduschool)

parcours("3E")
orientation("2GT")
programme("6E")
revision("6E")
exercices("6E", n = 5)
```

Les fonctions détaillées restent disponibles. Cette façade simplifie l'entrée
dans `eduschool` sans masquer le système relationnel sous-jacent.

---

## Pour qui ?

| Élèves | Parents | Utilisateurs R et enseignants |
|:--|:--|:--|
| Réviser, s'entraîner et comprendre son parcours. | Suivre la scolarité et comprendre les choix d'orientation. | Interroger les référentiels, produire et adapter des supports. |

---

## Créer, adapter, partager

![Partager les connaissances](identite/connaissances.png)

`eduschool` est un projet open source. Son architecture doit permettre de
construire progressivement ses propres fiches et exercices avec les mêmes
briques que celles utilisées par le package.

**Utiliser → créer → adapter → partager**

Les corrections de données, ressources, fiches, exercices, visualisations et
améliorations de l'API ont vocation à être mutualisées.

**[Voir comment contribuer →](articles/contribuer-et-partager.html)**

---

## Un projet volontairement centré sur les math

::: {.eduschool-maths-focus}

![](identite/compas.png)

L'architecture d'`eduschool` peut accueillir d'autres disciplines. Les fiches
de révision et les exercices restent volontairement consacrés aux mathématiques.
Cette limite permet de garder un outil cohérent, maintenable et réellement utile.

:::
