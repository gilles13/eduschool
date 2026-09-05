# Comprendre sa scolarité. Travailler les mathématiques.

**eduschool** cartographie la scolarité des collégiens et lycéens en
France et propose des outils pour réviser et s’entraîner en
mathématiques.

**PARCOURS SCOLAIRE · MATHÉMATIQUES · R**

Des données structurées pour comprendre les parcours scolaires, explorer
les programmes et accompagner le travail en mathématiques.

[**Explorer un parcours
→**](https://gilles13.github.io/eduschool/articles/parcours-scolaires.md)
[**Réviser les maths
→**](https://gilles13.github.io/eduschool/articles/fiches-revision-mathematiques.md)

### Collège → Lycée → Après le bac

Comprendre les étapes, les choix d’orientation et les poursuites
d’études sans transformer le package en encyclopédie scolaire générale.

### [↗ Parcours scolaire](https://gilles13.github.io/eduschool/articles/parcours-scolaires.md)

Niveaux et cycles, voies et séries, options, spécialités, orientation et
Parcoursup.

### [∑ Mathématiques](https://gilles13.github.io/eduschool/articles/fiches-revision-mathematiques.md)

Programmes, capacités, fiches de révision, exercices et ressources pour
progresser.

### [R · Données et API](https://gilles13.github.io/eduschool/reference/index.md)

Une API simple pour explorer les données, avec le mini-SI disponible
pour aller plus loin.

### [⚙ Comprendre eduschool](https://gilles13.github.io/eduschool/articles/rentrer-en-profondeur-dans-eduschool.md)

Architecture relationnelle, contrôles, conventions et fonctionnement
interne du package.

## Commencer avec quelques verbes

L’API principale privilégie des verbes courts, faciles à lire et à
combiner :

``` r

library(eduschool)

parcours("3E")
orientation("2GT")
programme("6E")
revision("6E")
exercices("6E", n = 5)
```

Les fonctions détaillées restent disponibles : cette façade simplifie
l’entrée dans `eduschool` sans fermer l’accès au système relationnel
sous-jacent.

### Élèves

Comprendre un parcours, retrouver les notions essentielles et
s’entraîner en mathématiques.

### Parents

Suivre la scolarité, comprendre les choix d’orientation et disposer de
supports synthétiques.

### Utilisateurs R

Interroger les référentiels, produire des documents, contrôler les
relations et adapter les outils.

## Créer et partager

`eduschool` est open source. La prochaine étape fonctionnelle consiste à
rendre la création de supports aussi simple que leur consultation :
composer une fiche, ajouter une notion, une formule, un graphique ou des
exercices, puis produire le document avec une API publique commune aux
fiches du package et aux fiches personnelles.

**Utiliser → créer → adapter → partager**

Corrections de données, ressources, fiches, exercices, visualisations et
améliorations de l’API peuvent être mutualisés.

[**Contribuer au projet
→**](https://gilles13.github.io/eduschool/articles/contribuer-et-partager.md)

## Un projet volontairement centré

L’architecture d’`eduschool` est générique et peut accueillir d’autres
matières. Le projet lui-même reste néanmoins centré sur les
**mathématiques** pour ses fiches de révision et ses exercices. Cette
limite volontaire permet de garder un outil cohérent, maintenable et
réellement utile.
