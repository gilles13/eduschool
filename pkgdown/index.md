# Comprendre sa scolarité. Travailler les mathématiques.

**eduschool** cartographie la scolarité des collégiens et lycéens en France et
propose des outils pour réviser et s'entraîner en mathématiques.

:::: {.edu-hero}
::: {.edu-hero-main}
**PARCOURS SCOLAIRE · MATHÉMATIQUES · R**

Des données structurées pour comprendre les parcours scolaires, explorer les
programmes et accompagner le travail en mathématiques.

[**Explorer un parcours →**](articles/parcours-scolaires.html){.edu-btn .edu-btn-primary}
[**Réviser les maths →**](articles/fiches-revision-mathematiques.html){.edu-btn .edu-btn-math}
:::

::: {.edu-hero-side}
### Collège → Lycée → Après le bac

Comprendre les étapes, les choix d'orientation et les poursuites d'études sans
transformer le package en encyclopédie scolaire générale.
:::
::::

:::: {.edu-grid .edu-grid-4}
::: {.edu-card .edu-card-path}
### [↗ Parcours scolaire](articles/parcours-scolaires.html)

Niveaux et cycles, voies et séries, options, spécialités, orientation et
Parcoursup.
:::

::: {.edu-card .edu-card-math}
### [∑ Mathématiques](articles/fiches-revision-mathematiques.html)

Programmes, capacités, fiches de révision, exercices et ressources pour
progresser.
:::

::: {.edu-card .edu-card-data}
### [R · Données et API](reference/index.html)

Une API simple pour explorer les données, avec le mini-SI disponible pour aller
plus loin.
:::

::: {.edu-card .edu-card-understand}
### [⚙ Comprendre eduschool](articles/rentrer-en-profondeur-dans-eduschool.html)

Architecture relationnelle, contrôles, conventions et fonctionnement interne du
package.
:::
::::

## Commencer avec quelques verbes

L'API principale privilégie des verbes courts, faciles à lire et à combiner :

```r
library(eduschool)

parcours("3E")
orientation("2GT")
programme("6E")
revision("6E")
exercices("6E", n = 5)
```

Les fonctions détaillées restent disponibles : cette façade simplifie l'entrée
dans `eduschool` sans fermer l'accès au système relationnel sous-jacent.

:::: {.edu-grid .edu-grid-3}
::: {.edu-panel}
### Élèves

Comprendre un parcours, retrouver les notions essentielles et s'entraîner en
mathématiques.
:::

::: {.edu-panel}
### Parents

Suivre la scolarité, comprendre les choix d'orientation et disposer de supports
synthétiques.
:::

::: {.edu-panel}
### Utilisateurs R

Interroger les référentiels, produire des documents, contrôler les relations et
adapter les outils.
:::
::::

## Créer et partager

`eduschool` est open source. La prochaine étape fonctionnelle consiste à rendre
la création de supports aussi simple que leur consultation : composer une fiche,
ajouter une notion, une formule, un graphique ou des exercices, puis produire le
document avec une API publique commune aux fiches du package et aux fiches
personnelles.

::: {.edu-share}
**Utiliser → créer → adapter → partager**

Corrections de données, ressources, fiches, exercices, visualisations et
améliorations de l'API peuvent être mutualisés.

[**Contribuer au projet →**](articles/contribuer-et-partager.html){.edu-btn .edu-btn-outline}
:::

## Un projet volontairement centré

L'architecture d'`eduschool` est générique et peut accueillir d'autres matières.
Le projet lui-même reste néanmoins centré sur les **mathématiques** pour ses
fiches de révision et ses exercices. Cette limite volontaire permet de garder un
outil cohérent, maintenable et réellement utile.
